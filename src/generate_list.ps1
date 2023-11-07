###################################################################################
#
#		番組リストファイル出力処理スクリプト
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
	if (!$?) { exit 1 }
} catch { Write-Error ('❗ 関数の読み込みに失敗しました') ; exit 1 }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#メイン処理

#設定で指定したファイル・ディレクトリの存在チェック
Invoke-RequiredFileCheck

$local:keywords = @(Get-KeywordList)
Get-Token

$local:keywordNum = 0
$local:keywordTotal = $local:keywords.Count

Show-Progress2Row `
	-Text1 'キーワードから番組リスト作成中' `
	-Text2 'キーワードから番組を抽出しダウンロード' `
	-Detail1 '読み込み中...' `
	-Detail2 '読み込み中...' `
	-Tag $script:appName `
	-Duration 'long' `
	-Silent $false `
	-Group 'ListGen'

#======================================================================
#個々のジャンルページチェックここから
$local:totalStartTime = Get-Date
foreach ($local:keyword in $local:keywords) {
	$local:keyword = Remove-TabSpace($local:keyword)

	#ジャンルページチェックタイトルの表示
	Write-Output ('')
	Write-Output ('----------------------------------------------------------------------')
	Write-Output ('{0}' -f $local:keyword)

	$local:listLinks = @(Get-VideoLinksFromKeyword($local:keyword))
	$local:keyword = $local:keyword.Replace('https://tver.jp/', '')

	#URLがすでにダウンロードリストまたはダウンロード履歴に存在する場合は検索結果から除外
	$local:videoLinks, $local:processedCount = Invoke-HistoryAndListfileMatchCheck $local:listLinks
	$local:videoTotal = $local:videoLinks.Count
	Write-Output ('')
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
	Update-Progress2Row `
		-Activity1 $local:keywordNum/$local:keywordTotal `
		-Processing1 (Remove-TabSpace ($local:keyword)) `
		-Rate1 $local:progressRate1 `
		-SecRemaining1 $local:secRemaining1 `
		-Activity2 '' `
		-Processing2 '' `
		-Rate2 $local:progressRate2 `
		-SecRemaining2 '' `
		-Tag $script:appName `
		-Group 'ListGen'

	#----------------------------------------------------------------------
	#個々の番組の情報の取得ここから
	$local:videoNum = 0
	foreach ($local:videoLink in $local:videoLinks) {
		$local:videoNum += 1
		#進捗率の計算
		$local:progressRate2 = [Float]($local:videoNum / $local:videoTotal)
		#進捗更新
		Update-Progress2Row `
			-Activity1 $local:keywordNum/$local:keywordTotal `
			-Processing1 (Remove-TabSpace ($local:keyword)) `
			-Rate1 $local:progressRate1 `
			-SecRemaining1 $local:secRemaining1 `
			-Activity2 $local:videoNum/$local:videoTotal `
			-Processing2 $local:videoLink `
			-Rate2 $local:progressRate2 `
			-SecRemaining2 '' `
			-Tag $script:appName `
			-Group 'ListGen'
		Write-Output ('--------------------------------------------------')
		Write-Output ('{0}/{1} - {2}' -f $local:videoNum, $local:videoTotal, $local:videoLink)
		#TVer番組ダウンロードのメイン処理
		Update-VideoList `
			-Keyword $local:keyword `
			-EpisodePage $local:videoLink
	}
	#----------------------------------------------------------------------

}
#======================================================================

Update-ProgressToast2 `
	-Title1 'キーワードから番組リスト作成' `
	-Rate1 '1' `
	-LeftText1 '' `
	-RightText1 '完了' `
	-Title2 '番組のダウンロード' `
	-Rate2 '1' `
	-LeftText2 '' `
	-RightText2 '完了' `
	-Tag $script:appName `
	-Group 'ListGen'

Invoke-GarbageCollection

Write-Output ('')
Write-Output ('---------------------------------------------------------------------------')
Write-Output ('番組リストファイル出力処理を終了しました。')
Write-Output ('💡 必要に応じてリストファイルを編集してダウンロード不要な番組を削除してください')
Write-Output ('　リストファイルパス: {0}' -f $script:listFilePath)
Write-Output ('---------------------------------------------------------------------------')
