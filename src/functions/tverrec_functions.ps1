###################################################################################
#
#		TVerRec固有関数スクリプト
#
###################################################################################
Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)
Add-Type -AssemblyName 'System.Globalization'

#----------------------------------------------------------------------
#TVerRec最新化確認
#----------------------------------------------------------------------
function Invoke-TVerRecUpdateCheck {
	[OutputType([System.Void])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$progressPreference = 'silentlyContinue'
	Invoke-StatisticsCheck -Operation 'launch'
	$versionUp = $false

	#TVerRecの最新バージョン取得
	$repo = 'dongaba/TVerRec'
	$releases = ('https://api.github.com/repos/{0}/releases' -f $repo)
	try {
		$appReleases = (Invoke-RestMethod -Uri $releases -Method 'GET' )
		if (!$appReleases) { Write-Warning '最新版の情報を取得できませんでした' ; return }
	} catch { return }

	#GitHub側最新バージョンの整形
	#	v1.2.3 → 1.2.3
	$latestVersion = $appReleases[0].Tag_Name.Trim('v', ' ')
	#	v1.2.3 beta 4 → 1.2.3
	$latestMajorVersion = $latestVersion.split(' ')[0]

	#ローカル側バージョンの整形
	#	v1.2.3 beta 4 → 1.2.3
	$appMajorVersion = $script:appVersion.split(' ')[0]

	#バージョン判定
	$versionUp = switch ($true) {
		{ $latestMajorVersion -gt $appMajorVersion } { $true; continue }
		{ ($latestMajorVersion -eq $appMajorVersion) -and ($appMajorVersion -ne $script:appVersion) } { $true; continue }
		default { $false }
	}

	$progressPreference = 'Continue'

	#バージョンアップメッセージ
	if ($versionUp) {
		[Console]::ForegroundColor = 'Green'
		Write-Output ('')
		Write-Output ('❗ TVerRecの更新版があるようです。')
		Write-Output ('　Local Version {0}' -f $script:appVersion)
		Write-Output ('　Latest Version {0}' -f $latestVersion)
		Write-Output ('')
		[Console]::ResetColor()

		#変更履歴の表示
		foreach ($appRelease in @($appReleases | Where-Object { $_.Tag_Name.Trim('v', ' ') -gt $appMajorVersion })) {
			[Console]::ForegroundColor = 'Green'
			Write-Output ('----------------------------------------------------------------------')
			Write-Output ('{0}の更新内容' -f $appRelease.tag_name)
			Write-Output ('----------------------------------------------------------------------')
			Write-Output $appRelease.body.Replace('###', '■')
			Write-Output ('')
			[Console]::ResetColor()
		}

		#最新のアップデータを取得
		$latestUpdater = 'https://raw.githubusercontent.com/dongaba/TVerRec/master/src/functions/update_tverrec.ps1'
		Invoke-WebRequest -UseBasicParsing -Uri $latestUpdater -OutFile (Join-Path $script:scriptRoot 'functions//update_tverrec.ps1')
		if ($IsWindows) { Unblock-File -LiteralPath (Join-Path $script:scriptRoot 'functions//update_tverrec.ps1') }

		#アップデート実行
		Write-Warning ('TVerRecをアップデートするにはこのウィンドウを閉じ update_tverrec を実行してください。')
		foreach ($i in (1..10)) {
			$complete = ('#' * $i) * 5
			$remaining = ('.' * (10 - $i)) * 5
			Write-Warning ('残り{0}秒... [{1}{2}]' -f (10 - $i), $complete, $remaining)
			Start-Sleep -Second 1
		}
	}

	if (Test-Path Variable:versionUp) { Remove-Variable -Name versionUp }
	if (Test-Path Variable:repo) { Remove-Variable -Name repo }
	if (Test-Path Variable:releases) { Remove-Variable -Name releases }
	if (Test-Path Variable:appReleases) { Remove-Variable -Name appReleases }
	if (Test-Path Variable:latestVersion) { Remove-Variable -Name latestVersion }
	if (Test-Path Variable:latestMajorVersion) { Remove-Variable -Name latestMajorVersion }
	if (Test-Path Variable:appMajorVersion) { Remove-Variable -Name appMajorVersion }
	if (Test-Path Variable:latestUpdater) { Remove-Variable -Name latestUpdater }
	if (Test-Path Variable:complete) { Remove-Variable -Name complete }
	if (Test-Path Variable:remaining) { Remove-Variable -Name remaining }
}

#----------------------------------------------------------------------
#ytdl/ffmpegの最新化確認
#----------------------------------------------------------------------
function Invoke-ToolUpdateCheck {
	[CmdletBinding()]
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][string]$scriptName,
		[Parameter(Mandatory = $true)][string]$targetName
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$originalPreference = $progressPreference
	$progressPreference = 'silentlyContinue'
	& (Join-Path $scriptRoot ('functions/{0}' -f $scriptName) )
	if (!$?) { Write-Error ("❗ $targetName の更新に失敗しました") ; exit 1 }
	$progressPreference = $originalPreference

	if (Test-Path Variable:scriptName) { Remove-Variable -Name scriptName }
	if (Test-Path Variable:targetName) { Remove-Variable -Name targetName }
	if (Test-Path Variable:originalPreference) { Remove-Variable -Name originalPreference }
}

#----------------------------------------------------------------------
#ファイル・ディレクトリの存在チェック、なければサンプルファイルコピー
#----------------------------------------------------------------------
function Invoke-TverrecPathCheck {
	Param(
		[Parameter(Mandatory = $true )][string]$path,
		[Parameter(Mandatory = $true )][string]$errorMessage,
		[Parameter(Mandatory = $false)][switch]$isFile,
		[Parameter(Mandatory = $false)][string]$sampleFilePath
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$pathType = if ($isFile) { 'Leaf' } else { 'Container' }

	if (!(Test-Path $path -PathType $pathType)) {
		if (!($sampleFilePath -and (Test-Path $sampleFilePath -PathType 'Leaf'))) {
			Write-Error ('❗ {0}が存在しません。終了します。' -f $errorMessage) ; exit 1
		}
		Copy-Item -LiteralPath $sampleFilePath -Destination $path -Force
	}

	if (Test-Path Variable:path) { Remove-Variable -Name path }
	if (Test-Path Variable:errorMessage) { Remove-Variable -Name errorMessage }
	if (Test-Path Variable:isFile) { Remove-Variable -Name isFile }
	if (Test-Path Variable:sampleFilePath) { Remove-Variable -Name sampleFilePath }
	if (Test-Path Variable:pathType) { Remove-Variable -Name pathType }
}

#----------------------------------------------------------------------
#設定で指定したファイル・ディレクトリの存在チェック
#----------------------------------------------------------------------
function Invoke-RequiredFileCheck {
	[OutputType([System.Void])]
	Param ()

	Write-Debug ($MyInvocation.MyCommand.Name)

	if ($script:downloadBaseDir -eq '') { Write-Error ('❗ 番組ダウンロード先ディレクトリが設定されていません。終了します。') ; exit 1 }
	else { Invoke-TverrecPathCheck -Path $script:downloadBaseDir -errorMessage '番組ダウンロード先ディレクトリ' }
	if ($script:downloadWorkDir -eq '') { Write-Error ('❗ ダウンロード作業ディレクトリが設定されていません。終了します。') ; exit 1 }
	else { Invoke-TverrecPathCheck -Path $script:downloadWorkDir -errorMessage 'ダウンロード作業ディレクトリ' }
	if ($script:saveBaseDir -ne '') {
		$script:saveBaseDirArray = $script:saveBaseDir.split(';').Trim()
		foreach ($saveDir in $script:saveBaseDirArray) {
			Invoke-TverrecPathCheck -Path $saveDir.Trim() -errorMessage '番組移動先ディレクトリ'
		}
	}

	Invoke-TverrecPathCheck -Path $script:ytdlPath -errorMessage 'youtube-dl' -isFile
	Invoke-TverrecPathCheck -Path $script:ffmpegPath -errorMessage 'ffmpeg' -isFile
	if ($script:simplifiedValidation) {
		Invoke-TverrecPathCheck -Path $script:ffprobePath -errorMessage 'ffprobe' -isFile
	}

	Invoke-TverrecPathCheck -Path $script:keywordFilePath -errorMessage 'ダウンロード対象キーワードファイル' -isFile -sampleFilePath $script:keywordFileSamplePath
	Invoke-TverrecPathCheck -Path $script:ignoreFilePath -errorMessage 'ダウンロード対象外番組ファイル' -isFile -sampleFilePath $script:ignoreFileSamplePath
	Invoke-TverrecPathCheck -Path $script:histFilePath -errorMessage 'ダウンロード履歴ファイル' -isFile -sampleFilePath $script:histFileSamplePath
	Invoke-TverrecPathCheck -Path $script:listFilePath -errorMessage 'ダウンロードリストファイル' -isFile -sampleFilePath $script:listFileSamplePath

	if (Test-Path Variable:saveDir) { Remove-Variable -Name saveDir }
}


#----------------------------------------------------------------------
#ダウンロード対象キーワードの読み込み
#----------------------------------------------------------------------
function Read-KeywordList {
	[OutputType([String[]])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$keywords = @()
	if (Test-Path $script:keywordFilePath -PathType Leaf) {
		try {
			#コメントと空行を除いて抽出
			$keywords = [String[]]((Get-Content $script:keywordFilePath -Encoding UTF8).Where({ $_ -notmatch '^\s*$|^#.*$' }))
		} catch {
			Write-Error ('❗ ダウンロード対象キーワードの読み込みに失敗しました') ; exit 1
		}
	}
	return @($keywords)

	if (Test-Path Variable:keywords) { Remove-Variable -Name keywords }
}


#----------------------------------------------------------------------
#ダウンロード履歴の読み込み
#----------------------------------------------------------------------
function Read-HistoryFile {
	[OutputType([String[]])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	if (Test-Path $script:histFilePath -PathType Leaf) {
		try {
			while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
			$histFileData = @(Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8)
		} catch { Write-Warning ('❗ ダウンロード履歴の読み込みに失敗しました') ; exit 1 }
		finally { $null = Unlock-File $script:histLockFilePath }
	} else { $histFileData = @() }

	return @($histFileData)

	if (Test-Path Variable:histFileData) { Remove-Variable -Name histFileData }
}

#----------------------------------------------------------------------
#ダウンロードリストの読み込み
#----------------------------------------------------------------------
function Read-DownloadList {
	[OutputType([String[]])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	if (Test-Path $script:listFilePath -PathType Leaf) {
		try {
			while ((Lock-File $script:listLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
			$listFileData = @(Import-Csv -LiteralPath $script:listFilePath -Encoding UTF8)
		} catch { Write-Warning ('❗ ダウンロードリストの読み込みに失敗しました') ; exit 1 }
		finally { $null = Unlock-File $script:listLockFilePath }
	} else { $listFileData = @() }

	return @($listFileData)

	if (Test-Path Variable:listFileData) { Remove-Variable -Name listFileData }
}

#----------------------------------------------------------------------
#ダウンロードリストからダウンロードリンクの読み込み
#----------------------------------------------------------------------
function Get-LinkFromDownloadList {
	[OutputType([String[]])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	if (Test-Path $script:listFilePath -PathType Leaf) {
		try {
			while ((Lock-File $script:listLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
			#空行とダウンロード対象外を除き、EpisodeIDのみを抽出
			$videoLinks = @((Import-Csv -LiteralPath $script:listFilePath -Encoding UTF8).Where({ !($_ -cmatch '^\s*$') }).Where({ !($_.EpisodeID -cmatch '^#') }) | Select-Object episodeID)
		} catch { Write-Error ('❗ ダウンロードリストの読み込みに失敗しました') ; exit 1 }
		finally { $null = Unlock-File $script:listLockFilePath }
	} else { $videoLinks = @() }

	$videoLinks = $videoLinks.episodeID -replace '^(.+)', 'https://tver.jp/episodes/$1'

	return @($videoLinks)

	if (Test-Path Variable:videoLinks) { Remove-Variable -Name videoLinks }
}

#----------------------------------------------------------------------
#ダウンロード対象外番組の読み込
#----------------------------------------------------------------------
function Read-IgnoreList {
	[OutputType([String[]])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	if (Test-Path $script:ignoreFilePath -PathType Leaf) {
		try {
			while ((Lock-File $script:ignoreLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
			#コメントと空行を除いて抽出
			$ignoreTitles = @((Get-Content $script:ignoreFilePath -Encoding UTF8).Where({ !($_ -cmatch '^\s*$') }).Where({ !($_ -cmatch '^;.*$') }))
		} catch { Write-Error ('❗ ダウンロード対象外の読み込みに失敗しました') ; exit 1 }
		finally { $null = Unlock-File $script:ignoreLockFilePath }
	} else { $ignoreTitles = @() }

	return @($ignoreTitles)

	if (Test-Path Variable:ignoreTitles) { Remove-Variable -Name ignoreTitles }
}

#----------------------------------------------------------------------
#ダウンロード対象外番組のソート(使用したものを上に移動)
#----------------------------------------------------------------------
function Update-IgnoreList {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][String]$ignoreTitle
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$ignoreListNew = @()
	$ignoreComment = @()
	$ignoreTarget = @()
	$ignoreElse = @()
	try {
		while ((Lock-File $script:ignoreLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
		$ignoreLists = @((Get-Content $script:ignoreFilePath -Encoding UTF8).Where( { $_ -notmatch '^\s*$|^(;;.*)$' }))
		$ignoreComment = @(Get-Content $script:ignoreFileSamplePath -Encoding UTF8)
		$ignoreTarget = @($ignoreLists.Where({ $_ -eq $ignoreTitle }) | Sort-Object -Unique)
		$ignoreElse = @($ignoreLists.Where({ $_ -notin $ignoreTitle }))
		if ($ignoreComment) { $ignoreListNew += $ignoreComment }
		if ($ignoreTarget) { $ignoreListNew += $ignoreTarget }
		if ($ignoreElse) { $ignoreListNew += $ignoreElse }
		#改行コードLFを強制 + NFCで出力
		$ignoreListNew.ForEach({ "{0}`n" -f $_ }).Normalize([Text.NormalizationForm]::FormC)  | Out-File -LiteralPath $script:ignoreFilePath -Encoding UTF8 -NoNewline
		Write-Debug ('ダウンロード対象外リストのソート更新完了')
	} catch { Write-Error ('❗ ダウンロード対象外リストのソートに失敗しました') ; exit 1 }
	finally { $null = Unlock-File $script:ignoreLockFilePath }

	if (Test-Path Variable:ignoreTitle) { Remove-Variable -Name ignoreTitle }
	if (Test-Path Variable:ignoreListNew) { Remove-Variable -Name ignoreListNew }
	if (Test-Path Variable:ignoreComment) { Remove-Variable -Name ignoreComment }
	if (Test-Path Variable:ignoreTarget) { Remove-Variable -Name ignoreTarget }
	if (Test-Path Variable:ignoreElse) { Remove-Variable -Name ignoreElse }
	if (Test-Path Variable:ignoreListNew) { Remove-Variable -Name ignoreListNew }
}

#----------------------------------------------------------------------
#URLが既にダウンロード履歴に存在するかチェックし、ダウンロード対象番組だけ返す
#----------------------------------------------------------------------
function Invoke-HistoryMatchCheck {
	[OutputType([String[]])]
	Param (
		[Parameter(Mandatory = $true)][Alias('links')][String[]]$resultLinks
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	#ダウンロード履歴ファイルのデータを読み込み
	$histFileData = @(Read-HistoryFile)
	if ($histFileData.Count -eq 0) { $histVideoPages = @() } else { $histVideoPages = @($histFileData.VideoPage) }

	#URLがすでにダウンロード履歴に存在する場合は検索結果から除外
	$histCompResult = @(Compare-Object -IncludeEqual $resultLinks $histVideoPages)
	try { $processedCount = ($histCompResult | Where-Object { $_.SideIndicator -eq '==' }).Count } catch { $processedCount = 0 }
	try { $videoLinks = @(($histCompResult | Where-Object { $_.SideIndicator -eq '<=' }).InputObject) } catch { $videoLinks = @() }

	return @($videoLinks, $processedCount)

	if (Test-Path Variable:resultLinks) { Remove-Variable -Name resultLinks }
	if (Test-Path Variable:histFileData) { Remove-Variable -Name histFileData }
	if (Test-Path Variable:histVideoPages) { Remove-Variable -Name histVideoPages }
	if (Test-Path Variable:histCompResult) { Remove-Variable -Name histCompResult }
	if (Test-Path Variable:processedCount) { Remove-Variable -Name processedCount }
	if (Test-Path Variable:videoLinks) { Remove-Variable -Name videoLinks }
}

#----------------------------------------------------------------------
#URLが既にダウンロードリストまたはダウンロード履歴に存在するかチェックし、ダウンロード対象番組だけ返す
#----------------------------------------------------------------------
function Invoke-HistoryAndListfileMatchCheck {
	[OutputType([String[]])]
	Param (
		[Parameter(Mandatory = $true)][Alias('links')][String[]]$resultLinks
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	#ダウンロードリストファイルのデータを読み込み
	$listFileData = @(Read-DownloadList)
	$listVideoPages = @()
	foreach ($listFileLine in $listFileData) {
		$listVideoPages += ('https://tver.jp/episodes/{0}' -f $listFileLine.EpisodeID.Replace('#', ''))
	}

	#ダウンロード履歴ファイルのデータを読み込み
	$histFileData = @(Read-HistoryFile)
	if ($histFileData.Count -eq 0) { $histVideoPages = @() } else { $histVideoPages = @($histFileData.VideoPage) }

	#ダウンロードリストとダウンロード履歴をマージ
	$histVideoPages += $listVideoPages

	#URLがすでにダウンロード履歴に存在する場合は検索結果から除外
	$histCompResult = @(Compare-Object -IncludeEqual $resultLinks $histVideoPages)
	try { $processedCount = ($histCompResult | Where-Object { $_.SideIndicator -eq '==' }).Count } catch { $processedCount = 0 }
	try { $videoLinks = @(($histCompResult | Where-Object { $_.SideIndicator -eq '<=' }).InputObject) } catch { $videoLinks = @() }

	return @($videoLinks, $processedCount)

	if (Test-Path Variable:resultLinks) { Remove-Variable -Name resultLinks }
	if (Test-Path Variable:listFileData) { Remove-Variable -Name listFileData }
	if (Test-Path Variable:listVideoPages) { Remove-Variable -Name listVideoPages }
	if (Test-Path Variable:listFileLine) { Remove-Variable -Name listFileLine }
	if (Test-Path Variable:histFileData) { Remove-Variable -Name histFileData }
	if (Test-Path Variable:histVideoPages) { Remove-Variable -Name histVideoPages }
	if (Test-Path Variable:histCompResult) { Remove-Variable -Name histCompResult }
	if (Test-Path Variable:processedCount) { Remove-Variable -Name processedCount }
	if (Test-Path Variable:videoLinks) { Remove-Variable -Name videoLinks }
}


#----------------------------------------------------------------------
#youtube-dlプロセスの確認と待機
#----------------------------------------------------------------------
function Wait-YtdlProcess {
	[OutputType([System.Void])]
	Param ([Int32]$parallelDownloadFileNum)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$psCmd = 'ps'

	$processName = switch ($script:preferredYoutubedl) {
		'yt-dlp' { 'yt-dlp' ; continue }
		'ytdl-patched' { 'youtube-dl' ; continue }
	}

	#youtube-dlのプロセスが設定値を超えたら一時待機
	while ($true) {
		try {
			$ytdlCount = switch ($true) {
				$IsWindows { [Math]::Round((Get-Process -ErrorAction Ignore -Name 'youtube-dl').Count / 2, [MidpointRounding]::AwayFromZero) ; continue }
				$IsLinux { @(Get-Process -ErrorAction Ignore -Name $processName).Count ; continue }
				$IsMacOS { (& $psCmd | grep 'youtube-dl' | grep -v grep | grep -c ^).Trim() ; continue }
				default { 0 }
			}
		} catch {
			Write-Debug ('ダウンロードプロセスの数を取得できませんでした')
			$ytdlCount = 0
		}

		if ([Int]$ytdlCount -lt [Int]$parallelDownloadFileNum ) { break }

		Write-Host ('ダウンロードが{0}多重に達したので一時待機します。 ({1})' -f $parallelDownloadFileNum, (Get-TimeStamp))
		Write-Verbose ('現在のダウンロードプロセス一覧 ({0}個)' -f $ytdlCount)
		Start-Sleep -Seconds 60
	}

	if (Test-Path Variable:parallelDownloadFileNum) { Remove-Variable -Name parallelDownloadFileNum }
	if (Test-Path Variable:psCmd) { Remove-Variable -Name psCmd }
	if (Test-Path Variable:processName) { Remove-Variable -Name processName }
	if (Test-Path Variable:ytdlCount) { Remove-Variable -Name ytdlCount }
}


#----------------------------------------------------------------------
#ダウンロード履歴データの作成
#----------------------------------------------------------------------
function Format-HistoryRecord {
	Param(
		[Parameter(Mandatory = $true)][pscustomobject]$videoInfo
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	return [pscustomobject]@{
		videoPage       = $videoInfo.episodePageURL
		videoSeriesPage = $videoInfo.seriesPageURL
		genre           = $videoInfo.keyword
		series          = $videoInfo.seriesName
		season          = $videoInfo.seasonName
		title           = $videoInfo.episodeName
		media           = $videoInfo.mediaName
		broadcastDate   = $videoInfo.broadcastDate
		downloadDate    = Get-TimeStamp
		videoDir        = $videoInfo.fileDir
		videoName       = $videoInfo.fileName
		videoPath       = $videoInfo.fileRelPath
		videoValidated  = $videoInfo.validated
	}

	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
}

#----------------------------------------------------------------------
#ダウンロードリストデータの作成
#----------------------------------------------------------------------
function Format-ListRecord {
	Param(
		[Parameter(Mandatory = $true)][pscustomobject]$videoInfo
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	if ($script:extractDescTextToList) {
		return [pscustomobject]@{
			seriesName      = $videoInfo.seriesName
			seriesID        = $videoInfo.seriesID
			seriesPageURL   = $videoInfo.seriesPageURL
			seasonName      = $videoInfo.seasonName
			seasonID        = $videoInfo.seasonID
			episodeNo       = $videoInfo.episodeNum
			episodeName     = $videoInfo.episodeName
			episodeID       = $videoInfo.episodeID
			episodePageURL  = $videoInfo.episodePageURL
			media           = $videoInfo.mediaName
			provider        = $videoInfo.providerName
			broadcastDate   = $videoInfo.broadcastDate
			endTime         = $videoInfo.endTime
			keyword         = $videoInfo.keyword
			ignoreWord      = $videoInfo.ignoreWord
			descriptionText = $videoInfo.descriptionText
		}
	} else {
		return [pscustomobject]@{
			seriesName     = $videoInfo.seriesName
			seriesID       = $videoInfo.seriesID
			seriesPageURL  = $videoInfo.seriesPageURL
			seasonName     = $videoInfo.seasonName
			seasonID       = $videoInfo.seasonID
			episodeNo      = $videoInfo.episodeNum
			episodeName    = $videoInfo.episodeName
			episodeID      = $videoInfo.episodeID
			episodePageURL = $videoInfo.episodePageURL
			media          = $videoInfo.mediaName
			provider       = $videoInfo.providerName
			broadcastDate  = $videoInfo.broadcastDate
			endTime        = $videoInfo.endTime
			keyword        = $videoInfo.keyword
			ignoreWord     = $videoInfo.ignoreWord
		}
	}

	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
}

#----------------------------------------------------------------------
#「《」と「》」で挟まれた文字を除去
#----------------------------------------------------------------------
Function Remove-SpecialNote {
	Param($text)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	return ($text -replace '《.*?》', '').Replace('  ', ' ').Trim()

	if (Test-Path Variable:text) { Remove-Variable -Name text }
}

#----------------------------------------------------------------------
#TVer番組ダウンロードのメイン処理
#----------------------------------------------------------------------
function Invoke-VideoDownload {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true )][String]$keyword,
		[Parameter(Mandatory = $true )][String]$episodePage,
		[Parameter(Mandatory = $false)][Boolean]$force = $false
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$newVideo = $null
	$skipDownload = $false
	$episodeID = $episodePage.Replace('https://tver.jp/episodes/', '')

	#TVerのAPIを叩いて番組情報取得
	Invoke-StatisticsCheck -Operation 'getinfo' -TVerType 'link' -TVerID $episodeID
	try { $videoInfo = Get-VideoInfo $episodeID }
	catch { Write-Warning ('❗ 情報取得エラー。スキップします Err:90') ; continue }
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'keyword' -Value $keyword

	#ダウンロードファイル名を生成
	$videoInfo = Format-VideoFileInfo $videoInfo
	#番組タイトルが取得できなかった場合はスキップ次の番組へ
	if ($videoInfo.fileName -eq '.mp4') { Write-Warning ('❗ 番組タイトルを特定できませんでした。スキップします') ; continue }

	#番組情報のコンソール出力
	Show-VideoInfo $videoInfo
	if ($DebugPreference -ne 'SilentlyContinue') { Show-VideoDebugInfo $videoInfo }

	if ($force) {
		$videoInfo | Add-Member -MemberType NoteProperty -Name 'validated' -Value '0'
		$newVideo = Format-HistoryRecord $videoInfo
	} else {
		#ここまで来ているということはEpisodeIDでは履歴とマッチしなかったということ
		#考えられる原因は履歴ファイルがクリアされてしまっていること、または、EpisodeIDが変更になったこと
		#	履歴ファイルに存在する	→番組IDが変更になったあるいは、番組名の重複
		#		検証済	→元々の番組IDとしては問題ないのでSKIP
		#		検証中	→元々の番組IDとしてはそのうち検証されるのでSKIP
		#		未検証	→元々の番組IDとしては次回検証されるのでSKIP
		#	履歴ファイルに存在しない
		#		ファイルが存在する	→検証だけする
		#		ファイルが存在しない
		#			ダウンロード対象外リストに存在する	→無視
		#			ダウンロード対象外リストに存在しない	→ダウンロード
		#ダウンロード履歴ファイルのデータを読み込み
		$histFileData = @(Read-HistoryFile)
		$histMatch = @($histFileData.Where({ $_.videoPath -eq $videoInfo.fileRelPath }))
		if (($histMatch.Count -ne 0)) {
			#履歴ファイルに存在する	→スキップして次のファイルに
			Write-Warning ('❗ 同名のファイルがすでに履歴ファイルに存在します。番組IDが変更になった可能性があります。ダウンロードをスキップします')
			$videoInfo | Add-Member -MemberType NoteProperty -Name 'validated' -Value '1'
			$videoInfo.fileName = '-- SKIPPED --'
			$newVideo = Format-HistoryRecord $videoInfo
			$skipDownload = $true
		} elseif ( Test-Path $videoInfo.filePath) {
			#履歴ファイルに存在しないが、実ファイルが存在する	→検証だけする
			Write-Warning ('❗ 履歴ファイルに存在しませんが番組ファイルが存在します。整合性検証の対象とします')
			$videoInfo | Add-Member -MemberType NoteProperty -Name 'validated' -Value '0'
			$videoInfo.fileName = '-- SKIPPED --'
			$newVideo = Format-HistoryRecord $videoInfo
			$skipDownload = $true
		} else {
			#履歴ファイルに存在せず、実ファイルも存在せず、ダウンロード対象外リストと合致	→無視する
			$ignoreTitles = @(Read-IgnoreList)
			foreach ($ignoreTitle in $ignoreTitles) {
				if (($videoInfo.fileName -like ('*{0}*' -f $ignoreTitle)) `
						-or ($videoInfo.seriesName -like ('*{0}*' -f $ignoreTitle))) {
					Update-IgnoreList $ignoreTitle
					Write-Output ('❗ ダウンロード対象外としたファイルをダウンロード履歴に追加します')
					$videoInfo | Add-Member -MemberType NoteProperty -Name 'validated' -Value '0'
					$videoInfo.fileName = '-- IGNORED --'
					$videoInfo.fileRelPath = '-- IGNORED --'
					$newVideo = Format-HistoryRecord $videoInfo
					$skipDownload = $true
					break
				}
			}
			#履歴ファイルに存在せず、実ファイルも存在せず、ダウンロード対象外リストとも合致しない	→ダウンロードする
			if (!$skipDownload) {
				Write-Output ('💡 ダウンロードするファイルをダウンロード履歴に追加します')
				$videoInfo | Add-Member -MemberType NoteProperty -Name 'validated' -Value '0'
				$newVideo = Format-HistoryRecord $videoInfo
			}
		}
	}

	#ダウンロード履歴CSV書き出し
	try {
		while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
		$newVideo | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8 -Append
		Write-Debug ('ダウンロード履歴を書き込みました')
	} catch { Write-Warning ('❗ ダウンロード履歴を更新できませんでした。処理をスキップします') ; continue }
	finally { $null = Unlock-File $script:histLockFilePath }

	#スキップ対象やダウンロード対象外は飛ばして次のファイルへ
	if ($skipDownload) { continue }

	#移動先ディレクトリがなければ作成
	if (-Not (Test-Path $videoInfo.fileDir -PathType Container)) {
		try { $null = New-Item -ItemType Directory -Path $videoInfo.fileDir -Force }
		catch { Write-Warning ('❗ 移動先ディレクトリを作成できませんでした') ; continue }
	}
	#youtube-dl起動
	try { Invoke-Ytdl $videoInfo }
	catch { Write-Warning ('❗ youtube-dlの起動に失敗しました') }
	#5秒待機
	Start-Sleep -Seconds 5

	if (Test-Path Variable:keyword) { Remove-Variable -Name keyword }
	if (Test-Path Variable:episodePage) { Remove-Variable -Name episodePage }
	if (Test-Path Variable:force) { Remove-Variable -Name force }
	if (Test-Path Variable:newVideo) { Remove-Variable -Name newVideo }
	if (Test-Path Variable:skipDownload) { Remove-Variable -Name skipDownload }
	if (Test-Path Variable:episodeID) { Remove-Variable -Name episodeID }
	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
	if (Test-Path Variable:histFileData) { Remove-Variable -Name histFileData }
	if (Test-Path Variable:histMatch) { Remove-Variable -Name histMatch }
	if (Test-Path Variable:ignoreTitles) { Remove-Variable -Name ignoreTitles }
	if (Test-Path Variable:ignoreTitle) { Remove-Variable -Name ignoreTitle }
}

#----------------------------------------------------------------------
#TVer番組ダウンロードリスト作成のメイン処理
#----------------------------------------------------------------------
function Update-VideoList {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][String]$keyword,
		[Parameter(Mandatory = $true)][String]$episodePage
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$ignoreWord = ''
	$newVideo = $null
	$ignore = $false

	$episodeID = $episodePage.Replace('https://tver.jp/episodes/', '')

	#TVerのAPIを叩いて番組情報取得
	Invoke-StatisticsCheck -Operation 'getinfo' -TVerType 'link' -TVerID $episodeID
	try { $videoInfo = Get-VideoInfo $episodeID }
	catch { Write-Warning ('❗ 情報取得エラー。スキップします Err:91') ; continue }
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'keyword' -Value $keyword

	#ダウンロード対象外に入っている番組の場合はリスト出力しない
	$ignoreTitles = @(Read-IgnoreList)
	foreach ($ignoreTitle in $ignoreTitles) {
		if ($ignoreTitle -ne '') {
			if (($videoInfo.seriesName -cmatch [Regex]::Escape($ignoreTitle)) -or ($videoInfo.episodeName -cmatch [Regex]::Escape($ignoreTitle))) {
				$ignoreWord = $ignoreTitle
				Update-IgnoreList $ignoreTitle
				$ignore = $true
				$videoInfo.episodeID = ('#{0}' -f $videoInfo.episodeID)
				#ダウンロード対象外と合致したものはそれ以上のチェック不要
				break
			}
		}
	}
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'ignoreWord' -Value $ignoreWord

	#番組情報のコンソール出力
	if ($DebugPreference -ne 'SilentlyContinue') { Show-VideoDebugInfo $videoInfo }

	#スキップフラグが立っているかチェック
	if ($ignore) {
		Write-Output ('❗ 番組をコメントアウトした状態でリストファイルに追加します')
		$newVideo = Format-ListRecord $videoInfo
	} else {
		Write-Output ('💡 番組をリストファイルに追加します')
		$newVideo = Format-ListRecord $videoInfo
	}

	#ダウンロードリストCSV書き出し
	try {
		while ((Lock-File $script:listLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
		$newVideo | Export-Csv -LiteralPath $script:listFilePath -Encoding UTF8 -Append
		Write-Debug ('ダウンロードリストを書き込みました')
	} catch { Write-Warning ('❗ ダウンロードリストを更新できませんでした。スキップします') ; continue }
	finally { $null = Unlock-File $script:listLockFilePath }

	if (Test-Path Variable:keyword) { Remove-Variable -Name keyword }
	if (Test-Path Variable:episodePage) { Remove-Variable -Name episodePage }
	if (Test-Path Variable:ignoreWord) { Remove-Variable -Name ignoreWord }
	if (Test-Path Variable:newVideo) { Remove-Variable -Name newVideo }
	if (Test-Path Variable:ignore) { Remove-Variable -Name ignore }
	if (Test-Path Variable:episodeID) { Remove-Variable -Name episodeID }
	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
	if (Test-Path Variable:ignoreTitles) { Remove-Variable -Name ignoreTitles }
	if (Test-Path Variable:ignoreTitle) { Remove-Variable -Name ignoreTitle }
	if (Test-Path Variable:ignoreWord) { Remove-Variable -Name ignoreWord }
}

#----------------------------------------------------------------------
#TVerのAPIを叩いて番組情報取得
#----------------------------------------------------------------------
function Get-VideoInfo {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][String]$episodeID
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	#----------------------------------------------------------------------
	#番組説明以外
	$tverVideoInfoBaseURL = 'https://platform-api.tver.jp/service/api/v1/callEpisode/'
	$tverVideoInfoURL = ('{0}{1}?platform_uid={2}&platform_token={3}' -f $tverVideoInfoBaseURL, $episodeID, $script:platformUID, $script:platformToken)
	$response = Invoke-RestMethod -Uri $tverVideoInfoURL -Method 'GET' -Headers $script:requestHeader -TimeoutSec $script:timeoutSec

	#シリーズ
	#	Series.Content.Titleだと複数シーズンがある際に現在メインで配信中のシリーズ名が返ってくることがある
	#	Episode.Content.SeriesTitleだとSeries名+Season名が設定される番組もある
	#	なのでSeries.Content.TitleとEpisode.Content.SeriesTitleの短い方を採用する
	if ($response.Result.Episode.Content.SeriesTitle.Length -le $response.Result.Series.Content.Title.Length ) {
		$videoSeries = (Remove-SpecialCharacter (Get-NarrowChars ($response.Result.Episode.Content.SeriesTitle))).Trim()
	} else {
		$videoSeries = (Remove-SpecialCharacter (Get-NarrowChars ($response.Result.Series.Content.Title))).Trim()
	}
	$videoSeriesID = $response.Result.Series.Content.Id
	$videoSeriesPageURL = ('https://tver.jp/series/{0}' -f $response.Result.Series.Content.Id)

	#シーズン
	$videoSeason = (Remove-SpecialCharacter (Get-NarrowChars ($response.Result.Season.Content.Title))).Trim()
	$videoSeasonID = $response.Result.Season.Content.Id

	#エピソード
	$episodeName = (Remove-SpecialCharacter (Get-NarrowChars ($response.Result.Episode.Content.Title))).Trim()
	$videoEpisodeID = $response.Result.Episode.Content.Id
	$videoEpisodePageURL = ('https://tver.jp/episodes/{0}' -f $videoEpisodeID)

	#放送局
	$mediaName = (Get-NarrowChars ($response.Result.Episode.Content.BroadcasterName)).Trim()
	$providerName = (Get-NarrowChars ($response.Result.Episode.Content.ProductionProviderName)).Trim()

	#放送日
	$broadcastDate = (($response.Result.Episode.Content.BroadcastDateLabel).Replace('ほか', '').Replace('放送分', '放送')).Trim()

	#配信終了日時
	$endTime = (ConvertFrom-UnixTime ($response.Result.Episode.Content.EndAt)).AddHours(9)

	#----------------------------------------------------------------------
	#番組説明
	$versionNum = $response.Result.Episode.Content.version
	$tverVideoInfoBaseURL = 'https://statics.tver.jp/content/episode/'
	$tverVideoInfoURL = ('{0}{1}.json?v={2}' -f $tverVideoInfoBaseURL, $episodeID, $versionNum)
	$videoInfo = Invoke-RestMethod -Uri $tverVideoInfoURL -Method 'GET' -Headers $script:requestHeader -TimeoutSec $script:timeoutSec
	$descriptionText = (Get-NarrowChars ($videoInfo.Description).Replace('&amp;', '&')).Trim()
	$videoEpisodeNum = (Get-NarrowChars ($videoInfo.No)).Trim()

	#----------------------------------------------------------------------
	#各種整形

	#「《」と「》」で挟まれた文字を除去
	if ($script:removeSpecialNote) {
		$videoSeries = Remove-SpecialNote $videoSeries
		$videoSeason = Remove-SpecialNote $videoSeason
		$episodeName = Remove-SpecialNote $episodeName
	}

	#シーズン名が本編の場合はシーズン名をクリア
	if ($videoSeason -eq '本編') { $videoSeason = '' }

	#シリーズ名がシーズン名を含む場合はシーズン名をクリア
	if ($videoSeries -cmatch [Regex]::Escape($videoSeason)) { $videoSeason = '' }

	#エピソード番号を極力修正
	if (($videoEpisodeNum -eq 1) -and ($episodeName -imatch '([#|第|Episode|ep|Take|Vol|Part|Chapter|Case|Stage|Mystery|Ope|Story|Trap|Letter|Act]+\.?\s?)(\d+)(.*)')) {
		$videoEpisodeNum = $matches[2]
	}

	#放送日を整形
	if ($broadcastDate -cmatch '([0-9]+)(月)([0-9]+)(日)(.+?)(放送)') {
		$currentYear = (Get-Date).Year
		$parsedBroadcastDate = [DateTime]::ParseExact(('{0}{1}{2}' -f $currentYear, $matches[1].padleft(2, '0'), $matches[3].padleft(2, '0')), 'yyyyMMdd', $null)
		#実日付の翌日よりも放送日が未来だったら当年ではなく昨年の番組と判断する(年末の番組を年初にダウンロードするケース)
		$broadcastYear = $parsedBroadcastDate -gt (Get-Date).AddDays(+1) ? $currentYear - 1 : $currentYear
		$broadcastDate = ('{0}年{1}{2}{3}{4}{5}' -f $broadcastYear, $matches[1].padleft(2, '0'), $matches[2], $matches[3].padleft(2, '0'), $matches[4], $matches[6])
	}

	return [pscustomobject]@{
		seriesName      = $videoSeries
		seriesID        = $videoSeriesID
		seriesPageURL   = $videoSeriesPageURL
		seasonName      = $videoSeason
		seasonID        = $videoSeasonID
		episodeNum      = $videoEpisodeNum
		episodeID       = $videoEpisodeID
		episodePageURL  = $videoEpisodePageURL
		episodeName     = $episodeName
		mediaName       = $mediaName
		providerName    = $providerName
		broadcastDate   = $broadcastDate
		endTime         = $endTime
		versionNum      = $versionNum
		videoInfoURL    = $tverVideoInfoURL
		descriptionText = $descriptionText
	}

	if (Test-Path Variable:episodeID) { Remove-Variable -Name episodeID }
	if (Test-Path Variable:tverVideoInfoBaseURL) { Remove-Variable -Name tverVideoInfoBaseURL }
	if (Test-Path Variable:tverVideoInfoURL) { Remove-Variable -Name tverVideoInfoURL }
	if (Test-Path Variable:response) { Remove-Variable -Name response }
	if (Test-Path Variable:videoSeries) { Remove-Variable -Name videoSeries }
	if (Test-Path Variable:videoSeriesID) { Remove-Variable -Name videoSeriesID }
	if (Test-Path Variable:videoSeriesPageURL) { Remove-Variable -Name videoSeriesPageURL }
	if (Test-Path Variable:videoSeason) { Remove-Variable -Name videoSeason }
	if (Test-Path Variable:videoSeasonID) { Remove-Variable -Name videoSeasonID }
	if (Test-Path Variable:episodeName) { Remove-Variable -Name episodeName }
	if (Test-Path Variable:videoEpisodeID) { Remove-Variable -Name videoEpisodeID }
	if (Test-Path Variable:videoEpisodePageURL) { Remove-Variable -Name videoEpisodePageURL }
	if (Test-Path Variable:mediaName) { Remove-Variable -Name mediaName }
	if (Test-Path Variable:providerName) { Remove-Variable -Name providerName }
	if (Test-Path Variable:broadcastDate) { Remove-Variable -Name broadcastDate }
	if (Test-Path Variable:endTime) { Remove-Variable -Name endTime }
	if (Test-Path Variable:versionNum) { Remove-Variable -Name versionNum }
	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
	if (Test-Path Variable:descriptionText) { Remove-Variable -Name descriptionText }
	if (Test-Path Variable:videoEpisodeNum) { Remove-Variable -Name videoEpisodeNum }
	if (Test-Path Variable:currentYear) { Remove-Variable -Name currentYear }
	if (Test-Path Variable:parsedBroadcastDate) { Remove-Variable -Name parsedBroadcastDate }
	if (Test-Path Variable:broadcastYear) { Remove-Variable -Name broadcastYear }
	if (Test-Path Variable:broadcastDate) { Remove-Variable -Name broadcastDate }
}

#----------------------------------------------------------------------
#保存ファイル名を設定
#----------------------------------------------------------------------
function Format-VideoFileInfo {
	[OutputType([pscustomobject])]
	Param (
		[Parameter(Mandatory = $true)][pscustomobject]$videoInfo
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$videoName = ''

	#ファイル名を生成
	if ($script:addSeriesName) { $videoName = ('{0}{1} ' -f $videoName, $videoInfo.seriesName) }
	if ($script:addSeasonName) { $videoName = ('{0}{1} ' -f $videoName, $videoInfo.seasonName) }
	if ($script:addBrodcastDate) { $videoName = ('{0}{1} ' -f $videoName, $videoInfo.broadcastDate) }
	if ($script:addEpisodeNumber) { $videoName = ('{0}Ep{1} ' -f $videoName, $videoInfo.episodeNum) }
	$videoName = ('{0}{1}' -f $videoName, $videoInfo.episodeName)

	#ファイル名にできない文字列を除去
	$videoName = (Get-FileNameWithoutInvalidChars $videoName).Replace('  ', ' ').Trim()

	#SMBで255バイトまでしかファイル名を持てないらしいので、超えないようにファイル名をトリミング
	#youtube-dlの中間ファイル等を考慮して安全目の上限値
	$fileNameLimit = $script:fileNameLengthMax - 25

	if ([System.Text.Encoding]::UTF8.GetByteCount($videoName) -gt $fileNameLimit) {
		while ([System.Text.Encoding]::UTF8.GetByteCount($videoName) -gt $fileNameLimit) {
			$videoName = $videoName.Substring(0, $videoName.Length - 1)
		}
		$videoName = ('{0}……' -f $videoName)
	}
	$videoName = Get-FileNameWithoutInvalidChars ('{0}.mp4' -f $videoName)
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'fileName' -Value $videoName

	$videoFileDir = Get-FileNameWithoutInvalidChars (Remove-SpecialCharacter ('{0} {1}' -f $videoInfo.seriesName, $videoInfo.seasonName ).Trim(' ', '.'))
	if ($script:sortVideoByMedia) { $videoFileDir = (Join-Path $script:downloadBaseDir (Get-FileNameWithoutInvalidChars $videoInfo.mediaName) | Join-Path -ChildPath $videoFileDir) }
	else { $videoFileDir = (Join-Path $script:downloadBaseDir $videoFileDir) }
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'fileDir' -Value $videoFileDir

	$videoFilePath = Join-Path $videoFileDir $videoInfo.fileName
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'filePath' -Value $videoFilePath

	$videoFileRelPath = $videoInfo.filePath.Replace($script:downloadBaseDir, '').Replace('\', '/').TrimStart('/')
	$videoInfo | Add-Member -MemberType NoteProperty -Name 'fileRelPath' -Value $videoFileRelPath

	return $videoInfo

	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
	if (Test-Path Variable:videoName) { Remove-Variable -Name videoName }
	if (Test-Path Variable:fileNameLimit) { Remove-Variable -Name fileNameLimit }
	if (Test-Path Variable:videoFileDir) { Remove-Variable -Name videoFileDir }
	if (Test-Path Variable:videoFilePath) { Remove-Variable -Name videoFilePath }
	if (Test-Path Variable:videoFileRelPath) { Remove-Variable -Name videoFileRelPath }
}

#----------------------------------------------------------------------
#番組情報表示
#----------------------------------------------------------------------
function Show-VideoInfo {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][pscustomobject]$videoInfo
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	Write-Output ('　番組名:　 {0}' -f $videoInfo.fileName.Replace('.mp4', ''))
	Write-Output ('　放送日:　 {0}' -f $videoInfo.broadcastDate)
	Write-Output ('　テレビ局: {0}' -f $videoInfo.mediaName)
	Write-Output ('　配信終了: {0}' -f $videoInfo.endTime)
	Write-Output ('　番組説明: {0}' -f $videoInfo.descriptionText)

	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
}
#----------------------------------------------------------------------
#番組情報デバッグ表示
#----------------------------------------------------------------------
function Show-VideoDebugInfo {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][pscustomobject]$videoInfo
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	Write-Debug $videoInfo.episodePageURL

	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
}

#----------------------------------------------------------------------
#youtube-dlプロセスの起動
#----------------------------------------------------------------------
function Invoke-Ytdl {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][pscustomobject]$videoInfo
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	Invoke-StatisticsCheck -Operation 'download'
	if ($IsWindows) {
		if ($script:downloadWorkDir.Substring($script:downloadWorkDir.Length - 1, 1) -eq ':') { $script:downloadWorkDir += '\\' }
		if ($script:downloadBaseDir.Substring($script:downloadBaseDir.Length - 1, 1) -eq ':') { $script:downloadBaseDir += '\\' }
	}
	$tmpDir = ('temp:{0}' -f $script:downloadWorkDir)
	$saveDir = ('home:{0}' -f $videoInfo.fileDir)
	$subttlDir = ('subtitle:{0}' -f $script:downloadWorkDir)
	$thumbDir = ('thumbnail:{0}' -f $script:downloadWorkDir)
	$chaptDir = ('chapter:{0}' -f $script:downloadWorkDir)
	$descDir = ('description:{0}' -f $script:downloadWorkDir)
	$saveFile = ('{0}' -f $videoInfo.fileName)
	$ytdlArgs = (' {0}' -f $script:ytdlBaseArgs)
	$ytdlArgs += (' {0} {1}' -f '--concurrent-fragments', $script:parallelDownloadNumPerFile)
	if ($script:rateLimit -notin @(0, '')) {
		$ytdlArgs += (' {0} {1}M' -f '--limit-rate', [Int][Math]::Ceiling([Int]$script:rateLimit / [Int]$script:parallelDownloadNumPerFile / 8))
	}
	if ($script:embedSubtitle) { $ytdlArgs += (' {0}' -f '--sub-langs all --convert-subs srt --embed-subs') }
	if ($script:embedMetatag) { $ytdlArgs += (' {0}' -f '--embed-metadata') }
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $saveDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $tmpDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $subttlDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $thumbDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $chaptDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $descDir)
	$ytdlArgs += (' {0} "{1}"' -f '--ffmpeg-location', $script:ffmpegPath)
	$ytdlArgs += (' {0} "{1}"' -f '--output', $saveFile)
	$ytdlArgs += (' {0} {1}' -f '--add-header', $script:ytdlAcceptLang)
	$ytdlArgs += (' {0}' -f $script:ytdlOption)
	$ytdlArgs += (' {0}' -f $videoInfo.episodePageURL)

	if ($IsWindows) {
		try {
			Write-Debug ('youtube-dl起動コマンド: {0}{1}' -f $script:ytdlPath, $ytdlArgs)
			$proc = Start-Process `
				-FilePath $script:ytdlPath `
				-ArgumentList $ytdlArgs `
				-PassThru `
				-WindowStyle $script:windowShowStyle
			$null = $proc.Handle
		} catch { Write-Error ('❗ youtube-dlの起動に失敗しました') ; return }
	} else {
		Write-Debug ('youtube-dl起動コマンド: {0}{1}' -f $script:ytdlPath, $ytdlArgs)
		try {
			$proc = Start-Process `
				-FilePath $script:ytdlPath `
				-ArgumentList $ytdlArgs `
				-PassThru `
				-RedirectStandardOutput /dev/null `
				-RedirectStandardError /dev/zero
			$null = $proc.Handle
		} catch { Write-Error ('❗ youtube-dlの起動に失敗しました') ; return }
	}

	if (Test-Path Variable:videoInfo) { Remove-Variable -Name videoInfo }
	if (Test-Path Variable:tmpDir) { Remove-Variable -Name tmpDir }
	if (Test-Path Variable:saveDir) { Remove-Variable -Name saveDir }
	if (Test-Path Variable:subttlDir) { Remove-Variable -Name subttlDir }
	if (Test-Path Variable:thumbDir) { Remove-Variable -Name thumbDir }
	if (Test-Path Variable:chaptDir) { Remove-Variable -Name chaptDir }
	if (Test-Path Variable:descDir) { Remove-Variable -Name descDir }
	if (Test-Path Variable:saveFile) { Remove-Variable -Name saveFile }
	if (Test-Path Variable:ytdlArgs) { Remove-Variable -Name ytdlArgs }
	if (Test-Path Variable:proc) { Remove-Variable -Name proc }
}

#----------------------------------------------------------------------
#youtube-dlプロセスの起動 (TVer以外のサイトへの対応)
#----------------------------------------------------------------------
function Invoke-NonTverYtdl {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][Alias('URL')]	[String]$videoPageURL
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	Invoke-StatisticsCheck -Operation 'nontver'
	if ($IsWindows) {
		if ($script:downloadWorkDir.Substring($script:downloadWorkDir.Length - 1, 1) -eq ':') { $script:downloadWorkDir += '\\' }
		if ($script:downloadBaseDir.Substring($script:downloadBaseDir.Length - 1, 1) -eq ':') { $script:downloadBaseDir += '\\' }
	}
	$tmpDir = ('temp:{0}' -f $script:downloadWorkDir)
	$baseDir = ('home:{0}' -f $script:downloadBaseDir)
	$subttlDir = ('subtitle:{0}' -f $script:downloadWorkDir)
	$thumbDir = ('thumbnail:{0}' -f $script:downloadWorkDir)
	$chaptDir = ('chapter:{0}' -f $script:downloadWorkDir)
	$descDir = ('description:{0}' -f $script:downloadWorkDir)
	$saveFile = ('{0}' -f $script:ytdlNonTVerFileName)
	$ytdlArgs = (' {0}' -f $script:ytdlBaseArgs)
	$ytdlArgs += (' {0} {1}' -f '--concurrent-fragments', $script:parallelDownloadNumPerFile)
	if ($script:rateLimit -notin @(0, '')) {
		$ytdlArgs += (' {0} {1}M' -f '--limit-rate', [Int][Math]::Ceiling([Int]$script:rateLimit / [Int]$script:parallelDownloadNumPerFile / 8))
	}
	if ($script:embedSubtitle) { $ytdlArgs += (' {0}' -f '--sub-langs all --convert-subs srt --embed-subs') }
	if ($script:embedMetatag) { $ytdlArgs += (' {0}' -f '--embed-metadata') }
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $baseDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $tmpDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $subttlDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $thumbDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $chaptDir)
	$ytdlArgs += (' {0} "{1}"' -f '--paths', $descDir)
	$ytdlArgs += (' {0} "{1}"' -f '--ffmpeg-location', $script:ffmpegPath)
	$ytdlArgs += (' {0} "{1}"' -f '--output', $saveFile)
	$ytdlArgs += (' {0} {1}' -f '--add-header', $script:ytdlAcceptLang)
	$ytdlArgs += (' {0}' -f $script:ytdlOption)
	$ytdlArgs += (' {0}' -f $videoPageURL)

	if ($IsWindows) {
		try {
			Write-Debug ('youtube-dl起動コマンド: {0}{1}' -f $script:ytdlPath, $ytdlArgs)
			$proc = Start-Process `
				-FilePath $script:ytdlPath `
				-ArgumentList $ytdlArgs `
				-PassThru `
				-WindowStyle $script:windowShowStyle
			$null = $proc.Handle
		} catch { Write-Error ('❗ youtube-dlの起動に失敗しました') ; return }
	} else {
		Write-Debug ('youtube-dl起動コマンド: {0}{1}' -f $script:ytdlPath, $ytdlArgs)
		try {
			$proc = Start-Process `
				-FilePath $script:ytdlPath `
				-ArgumentList $ytdlArgs `
				-PassThru `
				-RedirectStandardOutput /dev/null `
				-RedirectStandardError /dev/zero
			$null = $proc.Handle
		} catch { Write-Error ('❗ youtube-dlの起動に失敗しました') ; return }
	}

	if (Test-Path Variable:videoPageURL) { Remove-Variable -Name videoPageURL }
	if (Test-Path Variable:tmpDir) { Remove-Variable -Name tmpDir }
	if (Test-Path Variable:saveDir) { Remove-Variable -Name saveDir }
	if (Test-Path Variable:subttlDir) { Remove-Variable -Name subttlDir }
	if (Test-Path Variable:thumbDir) { Remove-Variable -Name thumbDir }
	if (Test-Path Variable:chaptDir) { Remove-Variable -Name chaptDir }
	if (Test-Path Variable:descDir) { Remove-Variable -Name descDir }
	if (Test-Path Variable:saveFile) { Remove-Variable -Name saveFile }
	if (Test-Path Variable:ytdlArgs) { Remove-Variable -Name ytdlArgs }
	if (Test-Path Variable:proc) { Remove-Variable -Name proc }
}

#----------------------------------------------------------------------
#youtube-dlのプロセスが終わるまで待機
#----------------------------------------------------------------------
function Wait-DownloadCompletion () {
	[OutputType([System.Void])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$psCmd = 'ps'

	$processName = switch ($script:preferredYoutubedl) {
		'yt-dlp' { 'yt-dlp' }
		'ytdl-patched' { 'youtube-dl' }
	}

	try {
		switch ($true) {
			$IsWindows { $ytdlCount = [Int][Math]::Round((Get-Process -ErrorAction Ignore -Name youtube-dl).Count / 2, [MidpointRounding]::AwayFromZero ) ; continue }
			$IsLinux { $ytdlCount = @(Get-Process -ErrorAction Ignore -Name $processName).Count ; continue }
			$IsMacOS { $ytdlCount = (& $psCmd | grep youtube-dl | grep -v grep | grep -c ^).Trim() ; continue }
			default { $ytdlCount = 0 ; continue }
		}
	} catch { $ytdlCount = 0 }

	while ($ytdlCount -ne 0) {
		try {
			Write-Verbose ('現在のダウンロードプロセス一覧 ({0}個)' -f $ytdlCount)
			Start-Sleep -Seconds 60
			switch ($true) {
				$IsWindows { $ytdlCount = [Int][Math]::Round((Get-Process -ErrorAction Ignore -Name youtube-dl).Count / 2, [MidpointRounding]::AwayFromZero ) ; continue }
				$IsLinux { $ytdlCount = @(Get-Process -ErrorAction Ignore -Name $processName).Count ; continue }
				$IsMacOS { $ytdlCount = (& $psCmd | grep youtube-dl | grep -v grep | grep -c ^).Trim() ; continue }
				default { $ytdlCount = 0 ; continue }
			}
		} catch { $ytdlCount = 0 }
	}

	if (Test-Path Variable:psCmd) { Remove-Variable -Name psCmd }
	if (Test-Path Variable:processName) { Remove-Variable -Name processName }
	if (Test-Path Variable:ytdlCount) { Remove-Variable -Name ytdlCount }
}

#----------------------------------------------------------------------
#ダウンロード履歴の不整合を解消
#----------------------------------------------------------------------
function Optimize-HistoryFile {
	[OutputType([System.Void])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$histData0 = @()
	$histData1 = @()
	$histData2 = @()
	$mergedHistData = @()

	try {
		while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }

		#videoValidatedが空白でないもの
		$histData = @((Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8).Where({ $null -ne $_.videoValidated }))
		$histData0 = @(($histData).Where({ $_.videoValidated -eq '0' }))
		$histData1 = @(($histData).Where({ $_.videoValidated -eq '1' }))
		$histData2 = @(($histData).Where({ $_.videoValidated -eq '2' }))

		$mergedHistData += $histData0
		$mergedHistData += $histData1
		$mergedHistData += $histData2
		$mergedHistData | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8

	} catch { Write-Warning ('❗ ダウンロード履歴の更新に失敗しました') }
	finally { $null = Unlock-File $script:histLockFilePath }

	if (Test-Path Variable:histData0) { Remove-Variable -Name histData0 }
	if (Test-Path Variable:histData1) { Remove-Variable -Name histData1 }
	if (Test-Path Variable:histData2) { Remove-Variable -Name histData2 }
	if (Test-Path Variable:mergedHistData) { Remove-Variable -Name mergedHistData }
	if (Test-Path Variable:histData) { Remove-Variable -Name histData }
}

#----------------------------------------------------------------------
#指定日以上前に処理したものはダウンロード履歴から削除
#----------------------------------------------------------------------
function Limit-HistoryFile {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][Int32]$retentionPeriod
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	try {
		while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
		$purgedHist = @((Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8).Where({ [DateTime]::ParseExact($_.downloadDate, 'yyyy-MM-dd HH:mm:ss', $null) -gt (Get-Date).AddDays(-1 * [Int32]$retentionPeriod) }))
		$purgedHist | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8
	} catch { Write-Warning ('❗ ダウンロード履歴のクリーンアップに失敗しました') }
	finally { $null = Unlock-File $script:histLockFilePath }

	if (Test-Path Variable:retentionPeriod) { Remove-Variable -Name retentionPeriod }
	if (Test-Path Variable:purgedHist) { Remove-Variable -Name purgedHist }
}


#----------------------------------------------------------------------
#ダウンロード履歴の重複削除
#----------------------------------------------------------------------
function Repair-HistoryFile {
	[OutputType([System.Void])]
	Param ()

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$uniquedHist = @()

	try {
		while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }

		#videoPageで1つしかないもの残し、ダウンロード日時でソート
		$uniquedHist = @(Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8 | Group-Object -Property 'videoPage' | Where-Object count -EQ 1 | Select-Object -ExpandProperty group | Sort-Object -Property downloadDate)
		$uniquedHist | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8

	} catch { Write-Warning ('❗ ダウンロード履歴の更新に失敗しました') }
	finally { $null = Unlock-File $script:histLockFilePath }

	if (Test-Path Variable:uniquedHist) { Remove-Variable -Name uniquedHist }
}

#----------------------------------------------------------------------
#番組の整合性チェック
#----------------------------------------------------------------------
function Invoke-ValidityCheck {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true)][String]$path,
		[Parameter(Mandatory = $false)][String]$decodeOption = ''
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$errorCount = 0
	$checkStatus = 0
	$videoFilePath = Join-Path (Convert-Path $script:downloadBaseDir) $path
	try { $null = New-Item -Path $script:ffpmegErrorLogPath -ItemType File -Force }
	catch { Write-Warning ('❗ ffmpegエラーファイルを初期化できませんでした') ; return }

	#これからチェックする番組のステータスをチェック
	try {
		while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
		$videoHists = @(Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8)
		$checkStatus = ($videoHists.Where({ $_.videoPath -eq $path })).videoValidated
		switch ($checkStatus) {
			#0:未チェック、1:チェック済、2:チェック中
			'0' {
				$videoHists.Where({ $_.videoPath -eq $path }).Where({ $_.videoValidated = '2' })
				$videoHists | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8
				continue
			}
			'1' { Write-Warning ('💡 他プロセスでチェック済です') ; return ; continue }
			'2' { Write-Warning ('💡 他プロセスでチェック中です') ; return ; continue }
			default { Write-Warning ('❗ 既にダウンロード履歴から削除されたようです: {0}' -f $path) ; return ; continue }
		}
	} catch { Write-Warning ('❗ ダウンロード履歴を更新できませんでした: {0}' -f $path) ; return }
	finally { $null = Unlock-File $script:histLockFilePath }

	Invoke-StatisticsCheck -Operation 'validate'

	if ($script:simplifiedValidation) {
		#ffprobeを使った簡易検査
		$ffprobeArgs = (' -hide_banner -v error -err_detect explode -i "{0}"' -f $videoFilePath)
		Write-Debug ('ffprobe起動コマンド: {0}{1}' -f $script:ffprobePath, $ffprobeArgs)
		try {
			if ($IsWindows) {
				$proc = Start-Process `
					-FilePath $script:ffprobePath `
					-ArgumentList $ffprobeArgs `
					-PassThru `
					-WindowStyle $script:windowShowStyle `
					-RedirectStandardError $script:ffpmegErrorLogPath `
					-Wait
				$null = $proc.Handle #proc.Handleをキャッシュ。PS7.4.0の終了コードを捕捉しないバグのために必要
				$proc.WaitForExit();
			} else {
				$proc = Start-Process `
					-FilePath $script:ffprobePath `
					-ArgumentList $ffprobeArgs `
					-PassThru `
					-RedirectStandardOutput /dev/null `
					-RedirectStandardError $script:ffpmegErrorLogPath `
					-Wait
				$proc.WaitForExit();
			}
		} catch { Write-Error ('❗ ffprobeを起動できませんでした') ; return }
	} else {
		#ffmpegeを使った完全検査
		$ffmpegArgs = (' -hide_banner -v error -xerror {0} -i "{1}" -f null - ' -f $decodeOption, $videoFilePath)
		Write-Debug ('ffmpeg起動コマンド: {0}{1}' -f $script:ffmpegPath, $ffmpegArgs)
		try {
			if ($IsWindows) {
				$proc = Start-Process `
					-FilePath $script:ffmpegPath `
					-ArgumentList $ffmpegArgs `
					-PassThru `
					-WindowStyle $script:windowShowStyle `
					-RedirectStandardError $script:ffpmegErrorLogPath
				$null = $proc.Handle #proc.Handleをキャッシュ。PS7.4.0の終了コードを捕捉しないバグのために必要
				$proc.WaitForExit();
			} else {
				$proc = Start-Process `
					-FilePath $script:ffmpegPath `
					-ArgumentList $ffmpegArgs `
					-PassThru `
					-RedirectStandardOutput /dev/null `
					-RedirectStandardError $script:ffpmegErrorLogPath
				$proc.WaitForExit();
			}
		} catch { Write-Error ('❗ ffmpegを起動できませんでした') ; return }
	}

	#ffmpegが正常終了しても、大量エラーが出ることがあるのでエラーをカウント
	try {
		if (Test-Path $script:ffpmegErrorLogPath) {
			$errorCount = (Get-Content -LiteralPath $script:ffpmegErrorLogPath | Measure-Object -Line).Lines
			Get-Content -LiteralPath $script:ffpmegErrorLogPath -Encoding UTF8 | Write-Debug
		}
	} catch { Write-Warning ('❗ ffmpegエラーの数をカウントできませんでした') ; $errorCount = 9999999 }

	#エラーをカウントしたらファイルを削除
	try { if (Test-Path $script:ffpmegErrorLogPath) { Remove-Item -LiteralPath $script:ffpmegErrorLogPath -Force -ErrorAction SilentlyContinue } }
	catch { Write-Warning ('❗ ffmpegエラーファイルを削除できませんでした') }

	if ($proc.ExitCode -ne 0 -or $errorCount -gt 30) {

		#終了コードが0以外 または エラーが一定以上 はダウンロード履歴とファイルを削除
		Write-Warning ('❗ チェックNGでした')
		Write-Warning ('　Exit Code: {0} Error Count: {1}' -f $proc.ExitCode, $errorCount)
		$script:validationFailed = $true

		#破損しているダウンロードファイルをダウンロード履歴から削除
		try {
			while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
			$videoHists = @(Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8)
			#該当の番組のレコードを削除
			$videoHists = @($videoHists.Where({ $_.videoPath -ne $path }))
			$videoHists | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8
		} catch { Write-Warning ('❗ ダウンロード履歴の更新に失敗しました: {0}' -f $path) }
		finally { $null = Unlock-File $script:histLockFilePath }

		#破損しているダウンロードファイルを削除
		try { Remove-Item -LiteralPath $videoFilePath -Force -ErrorAction SilentlyContinue }
		catch { Write-Warning ('❗ ファイル削除できませんでした: {0}' -f $videoFilePath) }

	} else {

		#終了コードが0のときはダウンロード履歴にチェック済フラグを立てる
		Write-Output ('　✔️')
		try {
			while ((Lock-File $script:histLockFilePath).fileLocked -ne $true) { Write-Warning ('ファイルのロック解除待ち中です') ; Start-Sleep -Seconds 1 }
			$videoHists = @(Import-Csv -LiteralPath $script:histFilePath -Encoding UTF8)
			#該当の番組のチェックステータスを1に
			$videoHists.Where({ $_.videoPath -eq $path }).Where({ $_.videoValidated = '1' })
			$videoHists | Export-Csv -LiteralPath $script:histFilePath -Encoding UTF8
		} catch { Write-Warning ('❗ ダウンロード履歴を更新できませんでした: {0}' -f $path) }
		finally { $null = Unlock-File $script:histLockFilePath }

	}

	if (Test-Path Variable:path) { Remove-Variable -Name path }
	if (Test-Path Variable:decodeOption) { Remove-Variable -Name decodeOption }
	if (Test-Path Variable:errorCount) { Remove-Variable -Name errorCount }
	if (Test-Path Variable:checkStatus) { Remove-Variable -Name checkStatus }
	if (Test-Path Variable:videoFilePath) { Remove-Variable -Name videoFilePath }
	if (Test-Path Variable:videoHists) { Remove-Variable -Name videoHists }
	if (Test-Path Variable:checkStatus) { Remove-Variable -Name checkStatus }
	if (Test-Path Variable:ffprobeArgs) { Remove-Variable -Name ffprobeArgs }
	if (Test-Path Variable:proc) { Remove-Variable -Name proc }
	if (Test-Path Variable:ffmpegArgs) { Remove-Variable -Name ffmpegArgs }
}

#region 環境

#----------------------------------------------------------------------
#設定取得
#----------------------------------------------------------------------
function Get-Setting {
	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$filePathList = @(
		(Join-Path $script:confDir 'system_setting.ps1'),
		(Join-Path $script:confDir 'user_setting.ps1')
	)
	$configList = @{}
	foreach ($filePath in $filePathList) {
		if (Test-Path $filePath) {
			$configs = (Select-String $filePath -Pattern '^(\$.+)=(.+)(\s*)$').ForEach({ $_.line })
			$excludePattern = '(.*PSStyle.*|.*Base64)'
			foreach ($config in $configs) {
				$configParts = $config -split '='
				$key = $configParts[0].replace('script:', '').replace('$', '').trim()
				if (!($key -match $excludePattern)) { $configList[$key] = (Get-Variable -Name $key).Value }
			}
		}
	}
	return $configList.GetEnumerator() | Sort-Object -Property key

	if (Test-Path Variable:filePathList) { Remove-Variable -Name filePathList }
	if (Test-Path Variable:configList) { Remove-Variable -Name configList }
	if (Test-Path Variable:filePath) { Remove-Variable -Name filePath }
	if (Test-Path Variable:configs) { Remove-Variable -Name configs }
	if (Test-Path Variable:excludePattern) { Remove-Variable -Name excludePattern }
	if (Test-Path Variable:config) { Remove-Variable -Name config }
	if (Test-Path Variable:configParts) { Remove-Variable -Name configParts }
	if (Test-Path Variable:key) { Remove-Variable -Name key }
}

#----------------------------------------------------------------------
#統計取得
#----------------------------------------------------------------------
function Invoke-StatisticsCheck {
	[OutputType([System.Void])]
	Param (
		[Parameter(Mandatory = $true )][String]$operation,
		[Parameter(Mandatory = $false)][String]$tverType = 'none',
		[Parameter(Mandatory = $false)][String]$tverID = 'none'
	)

	Write-Debug ('{0}' -f $MyInvocation.MyCommand.Name)

	$progressPreference = 'silentlyContinue'
	$statisticsBase = 'https://hits.sh/github.com/dongaba/TVerRec/'
	try { $null = Invoke-WebRequest `
			-UseBasicParsing `
			-Uri ('{0}{1}.svg' -f $statisticsBase, $operation) `
			-Method 'GET' `
			-TimeoutSec $script:timeoutSec
	} catch { Write-Debug ('Failed to collect count') }
	finally { $progressPreference = 'Continue' }
	if ($operation -eq 'search') { return }
	$epochTime = [Int64]([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() * 1000)
	$userProperties = @{	#max 25 properties, max 24 chars of property name, 36 chars of property value
		PSVersion    = @{ 'value' = $PSVersionTable.PSVersion.tostring() }
		AppVersion   = @{ 'value' = $script:appVersion }
		OS           = @{ 'value' = $script:os }
		Kernel       = @{ 'value' = $script:kernel }
		Architecture = @{ 'value' = $script:arch }
		Locale       = @{ 'value' = $script:locale }
		TimeZone     = @{ 'value' = $script:tz }
	}
	foreach ($clientEnv in $script:clientEnvs) {
		$value = [string]$clientEnv.Value
		$userProperties[$clientEnv.Key] = @{ 'value' = $value.Substring(0, [Math]::Min($value.Length, 36)) }
	}
	$eventParams = @{}	#max 25 parameters, max 40 chars of property name, 100 chars of property value
	foreach ($clientSetting in $script:clientSettings) {
		if (!($clientSetting.Name -match '(.*Dir|.*Path|app.*|timeout.*|.*Preference|.*Max|.*Period|parallel.*|.*BaseArgs|.*FileName)')) {
			$paramValue = [String]((Get-Variable -Name $clientSetting.Name).Value)
			$eventParams[$clientSetting.Key] = $paramValue.Substring(0, [Math]::Min($paramValue.Length, 99))
		}
	}
	$gaBody = [PSCustomObject]@{
		client_id            = $script:guid
		timestamp_micros     = $epochTime
		non_personalized_ads = $true
		user_properties      = $userProperties
		events               = @(	#max 25 events, 40 chars of event name
			@{
				name   = $operation
				params = $eventParams
			}
		)
	} | ConvertTo-Json -Depth 3
	$gaURL = 'https://www.google-analytics.com/mp/collect'
	$gaKey = 'api_secret=3URTslDhRVu4Qpb66nDyAA'
	$gaID = 'measurement_id=G-V9TJN18D5Z'
	$gaHeaders = @{
		'HOST'         = 'www.google-analytics.com'
		'Content-Type' = 'application/json'
	}
	$progressPreference = 'silentlyContinue'
	try { $null = Invoke-RestMethod `
			-Uri ('{0}?{1}&{2}' -f $gaURL, $gaKey, $gaID) `
			-Method 'POST' `
			-Headers $gaHeaders `
			-Body $gaBody `
			-TimeoutSec $script:timeoutSec
	} catch { Write-Debug ('Failed to collect statistics') }
	finally { $progressPreference = 'Continue' }

	if (Test-Path Variable:operation) { Remove-Variable -Name operation }
	if (Test-Path Variable:tverType) { Remove-Variable -Name tverType }
	if (Test-Path Variable:tverID) { Remove-Variable -Name tverID }
	if (Test-Path Variable:statisticsBase) { Remove-Variable -Name statisticsBase }
	if (Test-Path Variable:epochTime) { Remove-Variable -Name epochTime }
	if (Test-Path Variable:userProperties) { Remove-Variable -Name userProperties }
	if (Test-Path Variable:clientEnv) { Remove-Variable -Name clientEnv }
	if (Test-Path Variable:value) { Remove-Variable -Name value }
	if (Test-Path Variable:eventParams) { Remove-Variable -Name eventParams }
	if (Test-Path Variable:clientSetting) { Remove-Variable -Name clientSetting }
	if (Test-Path Variable:paramValue) { Remove-Variable -Name paramValue }
	if (Test-Path Variable:gaBody) { Remove-Variable -Name gaBody }
	if (Test-Path Variable:gaURL) { Remove-Variable -Name gaURL }
	if (Test-Path Variable:gaKey) { Remove-Variable -Name gaKey }
	if (Test-Path Variable:gaID) { Remove-Variable -Name gaID }
	if (Test-Path Variable:gaHeaders) { Remove-Variable -Name gaHeaders }
}

#endregion 環境

#----------------------------------------------------------------------
#GUID取得
#----------------------------------------------------------------------
switch ($true) {
	$IsWindows {
		$script:os = (Get-CimInstance -Class Win32_OperatingSystem).Caption
		$script:kernel = (Get-CimInstance -Class Win32_OperatingSystem).Version
		$script:arch = $Env:PROCESSOR_ARCHITECTURE.ToLower()
		$script:guid = (Get-CimInstance -Class Win32_ComputerSystemProduct).UUID
		$script:appId = (Get-StartApps | Where-Object { $_.Name -cmatch 'PowerShell*' })[0].AppId
		continue
	}
	$IsLinux {
		$script:os = if (Test-Path '/etc/os-release') { (& grep 'PRETTY_NAME' /etc/os-release).Replace('PRETTY_NAME=', '').Replace('"', '') } else { (& uname -n) }
		$script:kernel = [String][System.Environment]::OSVersion.Version
		$script:arch = (& uname -m | tr '[:upper:]' '[:lower:]')
		$script:guid = if (Test-Path '/etc/machine-id') { (Get-Content /etc/machine-id) } else { ([guid]::NewGuid()).tostring().replace('-', '') }
		continue
	}
	$IsMacOS {
		$script:os = ('{0} {1}' -f (& sw_vers -productName), (& sw_vers -productVersion))
		$script:kernel = (&  uname -r)
		$script:arch = (& uname -m | tr '[:upper:]' '[:lower:]')
		$script:guid = (& system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }').replace('-', '')
		continue
	}
	default {
		$script:os = [String][System.Environment]::OSVersion
		$script:kernel = ''
		$script:arch = ''
		$script:guid = ''
		continue
	}
}

$script:locale = (Get-Culture).Name
$script:tz = [String][TimeZoneInfo]::Local.BaseUtcOffset

$progressPreference = 'SilentlyContinue'
$script:clientEnvs = @{}
try {
	$GeoIPValues = (Invoke-RestMethod -Uri 'http://ip-api.com/json/?fields=18030841' -TimeoutSec $script:timeoutSec).psobject.properties
	foreach ($GeoIPValue in $GeoIPValues) { $script:clientEnvs.Add($GeoIPValue.Name, $GeoIPValue.Value) }
} catch {
	Write-Debug ('Failed to check Geo IP')
}
$progressPreference = 'Continue'
$script:clientEnvs = $script:clientEnvs.GetEnumerator() | Sort-Object -Property key
$script:clientSettings = Get-Setting
