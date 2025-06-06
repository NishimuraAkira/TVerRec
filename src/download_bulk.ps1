###################################################################################
#
#		一括ダウンロード処理スクリプト
#
###################################################################################
<#
	.SYNOPSIS
		TVerRecの一括ダウンロード処理を実行するスクリプト

	.DESCRIPTION
		TVerRecの一括ダウンロード処理を実行するスクリプトです。
		以下の処理を順番に実行します：
		1. キーワードリストの読み込み
		2. 各キーワードに対する動画検索
		3. ダウンロード履歴との照合
		4. 動画のダウンロード処理
		5. リネームに失敗したファイルの削除

	.PARAMETER guiMode
		オプションのパラメータ。GUIモードで実行するかどうかを指定します。
		- 指定なし: 通常モードで実行
		- 'gui': GUIモードで実行
		- その他の値: 通常モードで実行

	.NOTES
		前提条件:
		- Windows、Linux、またはmacOS環境で実行する必要があります
		- PowerShell 7.0以上を推奨します
		- TVerRecの設定ファイルが正しく設定されている必要があります
		- 十分なディスク容量が必要です
		- インターネット接続が必要です
		- TVerのアカウントが必要な場合があります
		- キーワードリストファイルが存在する必要があります

		処理の流れ:
		1. 環境設定の読み込み
		2. キーワードリストの読み込み
		3. 各キーワードに対する処理
		3.1 動画リンクの取得
		3.2 ダウンロード履歴との照合
		3.3 動画のダウンロード
		4. ダウンロード完了待機
		5. リネーム失敗ファイルの削除

	.EXAMPLE
		# 通常モードで実行
		.\download_bulk.ps1

		# GUIモードで実行
		.\download_bulk.ps1 gui

	.OUTPUTS
		System.Void
		このスクリプトは以下の出力を行います：
		- コンソールへの進捗状況の表示
		- トースト通知による進捗状況の表示
		- エラー発生時のエラーメッセージ
		- 処理完了時のサマリー情報
		- ダウンロードした動画ファイル
#>

Set-StrictMode -Version Latest
$script:guiMode = if ($args) { [String]$args[0] } else { '' }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 環境設定
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
try {
	if ($myInvocation.MyCommand.CommandType -ne 'ExternalScript') { $script:scriptRoot = Convert-Path . }
	else { $script:scriptRoot = Split-Path -Parent -Path $myInvocation.MyCommand.Definition }
	Set-Location $script:scriptRoot
} catch { throw '❌️ カレントディレクトリの設定に失敗しました。Failed to set current directory.' }
if ($script:scriptRoot.Contains(' ')) { throw '❌️ TVerRecはスペースを含むディレクトリに配置できません。TVerRec cannot be placed in directories containing space' }
. (Convert-Path (Join-Path $script:scriptRoot '../src/functions/initialize.ps1'))

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# メイン処理
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
try {
	# 必須ファイルのチェックとトークンの取得
	Invoke-RequiredFileCheck
	Suspend-Process
	Get-Token

	# キーワードリストの読み込み
	$keywords = @(Read-KeywordList)
	if ($keywords.Count -eq 0) { throw 'キーワードリストが空です。処理を中断します。' }
	else { $keywordTotal = $keywords.Count }
	$keywordNum = 0

	# 進捗表示の初期化
	$toastShowParams = @{
		Text1      = $script:msg.BulkDownloading
		Text2      = $script:msg.ExtractAndDownloadVideoFromKeywords
		WorkDetail = $script:msg.Loading
		Tag        = $script:appName
		Silent     = $false
		Group      = 'Bulk'
	}
	Show-ProgressToast @toastShowParams

	# ジョブ管理の初期化
	$script:jobList = @()
	Register-EngineEvent PowerShell.Exiting -Action {
		foreach ($jobId in $script:jobList) {
			Stop-Job -Id $jobId -Force -ErrorAction SilentlyContinue
			Remove-Job -Id $jobId -Force -ErrorAction SilentlyContinue
		}
	} | Out-Null

	#======================================================================
	# ビデオリンクの収集
	#======================================================================
	$linkCollectionStartTime = Get-Date
	$uniqueEpisodeIDs = [System.Collections.Generic.HashSet[string]]::new()
	$videoKeywordMap = @{}

	Write-Output ($script:msg.LongBoldBorder)
	Write-Output ($script:msg.ExtractingVideoFromKeywords)

	foreach ($keyword in $keywords) {
		$keywordNum++
		$keyword = Remove-TabSpace($keyword)

		Write-Output ('')
		Write-Output ($script:msg.MediumBoldBorder)
		Write-Output ('{0}' -f $keyword)

		# 進捗情報の更新
		$secElapsed = (Get-Date) - $linkCollectionStartTime
		if ($keywordNum -ne 0) {
			$secRemaining = [Int][Math]::Ceiling(($secElapsed.TotalSeconds / $keywordNum) * ($keywordTotal - $keywordNum))
			$minRemaining = ('{0}分' -f ([Int][Math]::Ceiling($secRemaining / 60)))
		} else { $minRemaining = '' }

		$toastUpdateParams = @{
			Title     = (Remove-TabSpace ($keyword))
			Rate      = [Float]($keywordNum / $keywordTotal)
			LeftText  = ('{0}/{1}' -f $keywordNum, $keywordTotal)
			RightText = $minRemaining
			Tag       = $script:appName
			Group     = 'Bulk'
		}
		Update-ProgressToast @toastUpdateParams

		# キーワードの正規化とビデオリンク取得
		$keyword = Get-ContentWoComment($keyword.Replace('https://tver.jp/', '').Trim())
		$resultLinks = @(Get-VideoLinksFromKeyword $keyword)

		# 履歴チェックと重複排除
		if ($resultLinks.Count -ne 0) {
			$episodeIDs, $processedCount = Invoke-HistoryMatchCheck $resultLinks
			foreach ($link in $episodeIDs) {if ($uniqueEpisodeIDs.Add($link)) { $videoKeywordMap[$link] = $keyword } }
		} else { $episodeIDs = @() ; $processedCount = 0 }

		$videoCount = $episodeIDs.Count
		if ($videoCount -eq 0) { Write-Output ($script:msg.VideoCountWhenZero -f $videoCount, $processedCount) }
		else { Write-Output ($script:msg.VideoCountNonZero -f $videoCount, $processedCount) }
	}

	#======================================================================
	# ビデオのダウンロード
	#======================================================================
	$downloadStartTime = Get-Date
	$videoTotal = $uniqueEpisodeIDs.Count
	$videoNum = 0

	Write-Output ('')
	Write-Output ($script:msg.LongBoldBorder)
	Write-Output ($script:msg.DownloadingVideo)

	foreach ($episodeID in $uniqueEpisodeIDs) {
		$videoNum++
		$keyword = $videoKeywordMap[$episodeID]

		# ディレクトリの存在確認
		if (!(Test-Path $script:downloadBaseDir -PathType Container)) { throw $script:msg.DownloadDirNotAccessible }

		# 空き容量少ないときは中断
		if ((Get-RemainingCapacity $script:downloadWorkDir) -lt $script:minDownloadWorkDirCapacity ) { Write-Warning ($script:msg.NoEnoughCapacity -f $script:downloadWorkDir ) ; break }
		if ((Get-RemainingCapacity $script:downloadBaseDir) -lt $script:minDownloadBaseDirCapacity ) { Write-Warning ($script:msg.NoEnoughCapacity -f $script:downloadBaseDir ) ; break }

		# 進捗率の計算
		$secElapsed = (Get-Date) - $downloadStartTime
		if ($videoNum -ne 0) {
			$secRemaining = [Int][Math]::Ceiling(($secElapsed.TotalSeconds / $videoNum) * ($videoTotal - $videoNum))
			$minRemaining = ('{0}分' -f ([Int][Math]::Ceiling($secRemaining / 60)))
		} else { $minRemaining = '' }

		# 進捗情報の更新
		$toastUpdateParams = @{
			Title     = $episodeID
			Rate      = [Float]($videoNum / $videoTotal)
			LeftText  = ('{0}/{1}' -f $videoNum, $videoTotal)
			RightText = $minRemaining
			Tag       = $script:appName
			Group     = 'Bulk'
		}
		Update-ProgressToast @toastUpdateParams

		Write-Output ($script:msg.ShortBoldBorder)
		Write-Output ('{0}/{1} - {2}' -f $videoNum, $videoTotal, $episodeID)

		# ダウンロードプロセスの制御
		Wait-YtdlProcess $script:parallelDownloadFileNum
		Suspend-Process

		# ビデオのダウンロード
		Invoke-VideoDownload -Keyword $keyword -episodeID $episodeID -Force $false
	}

	#======================================================================
	# 後処理
	#======================================================================
	# youtube-dlのプロセスが終わるまで待機
	Write-Output ('')
	Write-Output ($script:msg.WaitingDownloadCompletion)
	Wait-DownloadCompletion

	# リネームに失敗したファイルを削除
	Write-Output ('')
	Write-Output ($script:msg.DeleteFilesFailedToRename)
	Remove-UnRenamedTempFile

	# 最終進捗表示
	$toastUpdateParams = @{
		Title     = $script:msg.BulkDownloading
		Rate      = 1
		LeftText  = ''
		RightText = $script:msg.Completed
		Tag       = $script:appName
		Group     = 'Bulk'
	}
	Update-ProgressToast @toastUpdateParams

	# 完了メッセージ
	Write-Output ('')
	Write-Output ($script:msg.LongBoldBorder)
	Write-Output ($script:msg.BulkDownloadCompleted)
	Write-Output ($script:msg.LongBoldBorder)
} catch {
	Write-Error "Error occurred: $($_.Exception.Message)"
	Write-Error "Stack trace: $($_.ScriptStackTrace)"
	throw
} finally {
	# 変数のクリーンアップ
	Remove-Variable -Name args, keywords, keywordTotal, keywordNum, toastShowParams,
	totalStartTime, keyword, resultLinks, processedCount, videoLinks, videoCount,
	secElapsed, secRemaining, videoLink, toastUpdateParams, videoProcessed,
	uniqueVideoLinks, videoKeywordMap, errorCount, maxErrors -ErrorAction SilentlyContinue

	# ガベージコレクション
	Invoke-GarbageCollection
}
