###################################################################################
#
#		一括ダウンロード処理スクリプト
#
#	Copyright (c) 2022 dongaba
#
#	Licensed under the MIT License;
#	Permission is hereby granted, free of charge, to any person obtaining a copy
#	of this software and associated documentation files (the "Software"), to deal
#	in the Software without restriction, including without limitation the rights
#	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the Software is
#	furnished to do so, subject to the following conditions:
#
#	The above copyright notice and this permission notice shall be included in
#	all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#	THE SOFTWARE.
#
###################################################################################

try { $script:uiMode = [String]$args[0] } catch { $script:uiMode = '' }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#環境設定
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Set-StrictMode -Version Latest
#----------------------------------------------------------------------
#初期化
try {
	if ($script:myInvocation.MyCommand.CommandType -ne 'ExternalScript') { $script:scriptRoot = Convert-Path . }
	else { $script:scriptRoot = Split-Path -Parent -Path $script:myInvocation.MyCommand.Definition }
	Set-Location $script:scriptRoot
	$script:confDir = Convert-Path (Join-Path $script:scriptRoot '../conf')
	$script:devDir = Join-Path $script:scriptRoot '../dev'
} catch { Write-Error ('❗ カレントディレクトリの設定に失敗しました') ; exit 1 }
if ($script:scriptRoot.Contains(' ')) { Write-Error ('❗ TVerRecはスペースを含むディレクトリに配置できません') ; exit 1 }
try {
	. (Convert-Path (Join-Path $script:scriptRoot '../src/functions/initialize.ps1'))
	if ($? -eq $false) { exit 1 }
} catch { Write-Error ('❗ 関数の読み込みに失敗しました') ; exit 1 }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#メイン処理

#設定で指定したファイル・ディレクトリの存在チェック
checkRequiredFile

$local:keywordNames = @(loadKeywordList)
getToken

$local:keywordNum = 0
$local:keywordTotal = $local:keywordNames.Count

showProgress2Row `
	-ProgressText1 '一括ダウンロード中' `
	-ProgressText2 'キーワードから番組を抽出しダウンロード' `
	-WorkDetail1 '読み込み中...' `
	-WorkDetail2 '読み込み中...' `
	-Tag $script:appName `
	-Duration 'long' `
	-Silent $false `
	-Group 'Bulk'

#======================================================================
#個々のジャンルページチェックここから
$local:totalStartTime = Get-Date
foreach ($local:keywordName in $local:keywordNames) {
	$local:keywordName = trimTabSpace($local:keywordName)

	#ジャンルページチェックタイトルの表示
	Write-Output ('')
	Write-Output ('----------------------------------------------------------------------')
	Write-Output ('{0}' -f $local:keywordName)

	$local:resultLinks = @(getVideoLinksFromKeyword($local:keywordName))
	$local:keywordName = $local:keywordName.Replace('https://tver.jp/', '')

	#ダウンロード履歴ファイルのデータを読み込み
	$local:histFileData = @(loadHistFile)

	#URLがすでにダウンロード履歴に存在する場合は検索結果から除外
	if ($local:histFileData.Count -eq 0) { $local:histVideoPages = @() }
	else { $local:histVideoPages = @($local:histFileData.VideoPage) }
	$local:histCompResult = @(Compare-Object -IncludeEqual $local:resultLinks $local:histVideoPages)
	$local:histMatch = @($local:histCompResult.Where({ $_.SideIndicator -eq '==' }))
	$local:histUnmatch = @($local:histCompResult.Where({ $_.SideIndicator -eq '<=' }))
	if ($local:histMatch.Count -eq 0) { $local:processedCount = 0 }
	else { $local:processedCount = $local:histMatch.Count }
	if ($local:histUnmatch.Count -eq 0) { $local:videoLinks = @() }
	else { $local:videoLinks = @($local:histUnmatch.InputObject) }
	$local:videoTotal = $local:videoLinks.Count

	if ($local:videoTotal -eq 0) {
		Write-Output ('　処理対象{0}本　処理済{1}本' -f $local:videoTotal, $local:processedCount)
	} else {
		Write-Output ('　💡 処理対象{0}本　処理済{1}本' -f $local:videoTotal, $local:processedCount)
	}

	#処理時間の推計
	$local:secElapsed = (Get-Date) - $local:totalStartTime
	if ($local:keywordNum -ne 0) {
		$local:secRemaining1 = [Int][Math]::Ceiling(($local:secElapsed.TotalSeconds / $local:keywordNum) * ($local:keywordTotal - $local:keywordNum))
	} else { $local:secRemaining1 = -1 }
	$local:progressRate1 = [Float]($local:keywordNum / $local:keywordTotal)
	$local:progressRate2 = 0

	#キーワード数のインクリメント
	$local:keywordNum += 1

	#進捗更新
	updateProgress2Row `
		-ProgressActivity1 $local:keywordNum/$local:keywordTotal `
		-CurrentProcessing1 (trimTabSpace ($local:keywordName)) `
		-Rate1 $local:progressRate1 `
		-SecRemaining1 $local:secRemaining1 `
		-ProgressActivity2 '' `
		-CurrentProcessing2 '' `
		-Rate2 $local:progressRate2 `
		-SecRemaining2 '' `
		-Tag $script:appName `
		-Group 'Bulk'

	#----------------------------------------------------------------------
	#個々の番組ダウンロードここから
	$local:videoNum = 0
	foreach ($local:videoLink in $local:videoLinks) {
		$local:videoNum += 1
		#ダウンロード先ディレクトリの存在確認(稼働中に共有ディレクトリが切断された場合に対応)
		if (Test-Path $script:downloadBaseDir -PathType Container) {}
		else { Write-Error ('❗ 番組ダウンロード先ディレクトリにアクセスできません。終了します') ; exit 1 }
		#進捗率の計算
		$local:progressRate2 = [Float]($local:videoNum / $local:videoTotal)
		#進捗更新
		updateProgress2Row `
			-ProgressActivity1 $local:keywordNum/$local:keywordTotal `
			-CurrentProcessing1 (trimTabSpace ($local:keywordName)) `
			-Rate1 $local:progressRate1 `
			-SecRemaining1 $local:secRemaining1 `
			-ProgressActivity2 $local:videoNum/$local:videoTotal `
			-CurrentProcessing2 $local:videoLink `
			-Rate2 $local:progressRate2 `
			-SecRemaining2 '' `
			-Tag $script:appName `
			-Group 'Bulk'
		Write-Output ('--------------------------------------------------')
		Write-Output ('{0}/{1} - {2}' -f $local:videoNum, $local:videoTotal, $local:videoLink)
		#youtube-dlプロセスの確認と、youtube-dlのプロセス数が多い場合の待機
		waitTillYtdlProcessGetFewer $script:parallelDownloadFileNum
		#TVer番組ダウンロードのメイン処理
		downloadTVerVideo `
			-Keyword $local:keywordName `
			-URL $local:videoLink `
			-Link $local:videoLink.Replace('https://tver.jp', '') `
			-ForceDownload $false
	}
	#----------------------------------------------------------------------

}
#======================================================================

updateProgressToast2 `
	-Title1 'キーワードから番組の抽出' `
	-Rate1 '1' `
	-LeftText1 '' `
	-RightText1 '完了' `
	-Title2 '番組のダウンロード' `
	-Rate2 '1' `
	-LeftText2 '' `
	-RightText2 '完了' `
	-Tag $script:appName `
	-Group 'Bulk'

#youtube-dlのプロセスが終わるまで待機
Write-Output ('')
Write-Output ('ダウンロードの終了を待機しています')
waitTillYtdlProcessIsZero

[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
[System.GC]::Collect()

Write-Output ('')
Write-Output ('---------------------------------------------------------------------------')
Write-Output ('一括ダウンロード処理を終了しました。                                       ')
Write-Output ('---------------------------------------------------------------------------')
