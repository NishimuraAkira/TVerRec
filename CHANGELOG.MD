# Change Log

## [3.4.7](https://github.com/dongaba/TVerRec/releases/tag/v3.4.7)

### 3.4.7 Added

### 3.4.7 Changed

### 3.4.7 Fixed

- 放送局ごとのフォルダや番組ごとのフォルダを作成しない設定だとダウンロードに失敗する不具合を修正 #264

## [3.4.6](https://github.com/dongaba/TVerRec/releases/tag/v3.4.6)

### 3.4.6 Added

- デバッグモードの追加
- コメントベースヘルプの追加(AIにお任せ)

### 3.4.6 Changed

- 作業ディレクトリをTVerRec専用で使わない人がいるようなので、不要ファイル削除の処理を変更
- ファイル名、ディレクトリ名のクリーニングロジックを変更(代替文字が連続する場合に1つだけに)
- キーワードからのリンク抽出を終えてからダウンロードやリスト作成を実行するように変更

### 3.4.6 Fixed

- 番組ごとのディレクトリ配下にダウンロードファイルを保存「しない」設定をすると動画のない空のフォルダが作成される不具合を修正 #256
- フリーワード検索が400 (Bad Request)を返す不具合を修正 #257

## [3.4.5](https://github.com/dongaba/TVerRec/releases/tag/v3.4.5)

### 3.4.5 Added

### 3.4.5 Changed

- 作業フォルダ配下のゴミ掃除時にmp4とtsファイルを削除しないように変更
  - 以前に勝手にファイルが消されたと報告があった件に対する対策になるかも?

### 3.4.5 Fixed

- フリーズしたような状態になる問題を解決したつもり #251 #252

## [3.4.4](https://github.com/dongaba/TVerRec/releases/tag/v3.4.4)

### 3.4.4 Added

### 3.4.4 Changed

### 3.4.4 Fixed

- TVerRecのアップデータの不具合を修正 #249
- `common_functions.ps1`のマージミス不具合を修正

## [3.4.3](https://github.com/dongaba/TVerRec/releases/tag/v3.4.3)

### 3.4.3 Added

- yt-dlpのフリーズ対策として、yt-dlpに対するタイムアウトを設定可能に #243
- yt-dlpのフリーズ対策として、yt-dlpに対するタイムアウトを設定するオプションをGUIに追加
- 作業フォルダとダウンロード先フォルダの容量が少ないときに処理を中断する設定オプションをGUIに追加
- Linux/Macでyt-dlpのログをlogフォルダに出力する機能を追加 #240

### 3.4.3 Changed

- 海外からVPNやProxy使ってる方向けのチューニング
- リネームに失敗したファイルを削除を高速化(`for`コマンドと`find`コマンドを使用する方式に変更)
- フォルダ名、ファイル名から`,`を削除しないように変更
- 容量不足の判定時にマウントしていないUNCパスを処理できるように変更
- ランダムIPアドレスを取得する際にホスティングIPを許容するように変更
- ダウンロード履歴ファイルを追記方式に変更(ダウンロード履歴ファイルの破損リスク低減)
- ダウンロード履歴の不整合解消時にNULL文字を含む行を削除するように変更

### 3.4.3 Fixed

- 進捗バー付きトースト(Windows環境)でメッセージが不正だった問題を修正
- 容量不足時のメッセージが表示されなかった問題を修正
- `’`をファイル名やフォルダ名に含む動画のリネーム処理がされない不具合を修正 #242

## [3.4.2](https://github.com/dongaba/TVerRec/releases/tag/v3.4.2)

### 3.4.2 Added

### 3.4.2 Changed

- 作業フォルダとダウンロード先フォルダの容量が少ないときに処理を中断するように変更

### 3.4.2 Fixed

- 使っているPowerShellCoreが古いとエラーが出る問題を修正 #236

## [3.4.1](https://github.com/dongaba/TVerRec/releases/tag/v3.4.1)

### 3.4.1 Added

### 3.4.1 Changed

- Brightcoveからデータが取得できない際のメッセージを抑止
- Brightcoveからのデータ取得を停止
- HTTPタイムアウト処理の追加
- m3u8情報の取得を停止

### 3.4.1 Fixed

- ファイル名が長すぎてダウンロードされないことがある問題を修正 #227
- exFATでフォーマットされているディスクにダウンロードできない不具合を修正 #228
- ダウンロードができない問題を修正 #231

## [3.4.0](https://github.com/dongaba/TVerRec/releases/tag/v3.4.0)

### 3.4.0 Added

### 3.4.0 Changed

- yt-dlpがTVerの仕様変更に対応したので`tver.py`の同梱を廃止

### 3.4.0 Fixed

- 今日のわんこのダウンロードフォルダがおかしくなる問題を修正

## [3.3.9](https://github.com/dongaba/TVerRec/releases/tag/v3.3.9)

### 3.3.9 Added

### 3.3.9 Changed

- `tver.py`をうまく配置できない人が多いようなので`tver.py`を同梱(暫定)
- なので、ffmpegを使ったダウンロード機能を削除
- Brightcoveからデータ取得できない場合のメッセージをWarningからInformationに

### 3.3.9 Fixed

## [3.3.8](https://github.com/dongaba/TVerRec/releases/tag/v3.3.8)

### 3.3.8 Added

- 空フォルダを削除しないオプション`$script:emptyDownloadBaseDir`を追加(既定値は`$true`)

### 3.3.8 Changed

- StreaksのGeoIPチェック対策として、`$script:proxyUrl`が設定されている場合はyoutube-dlでもGeoIPチェック時のみProxyを使うように変更
- Brightcoveの情報が取れなくてもyt-dlpに任せて処理を継続するように変更

### 3.3.8 Fixed

## [3.3.7](https://github.com/dongaba/TVerRec/releases/tag/v3.3.7)

### 3.3.7 Added

### 3.3.7 Changed

### 3.3.7 Fixed

- 3.3.6で追加になった設定項目の初期設定値を`system_setting.ps1`に追加

## [3.3.6](https://github.com/dongaba/TVerRec/releases/tag/v3.3.6)

### 3.3.6 Added

- TVerの仕様変更対策として**暫定で**ffmpegでダウンロードできるように対応
  - ただし、サムネイルやメタデータの埋め込み、帯域制限など、これまでTVerRecが提供していた便利機能の大半は効かない
  - かつ、ダウンロードはyoutube-dlより10倍以上遅い
  - でも、**ダウンロードできないよりはマシ、という人向け**
  - `user_setting.ps1`に`$script:useFfmpegDownload`として`$true`と指定してください。Streaksからのダウンロード時にはffmpegを使用するようになります。(GUIでは設定できません、すみません)

- TVerの仕様変更対策として**暫定で**TVer用のエクストラクタをローカル配置してyoutube-dlでダウンロードできるように対応
  - 配置場所は`bin`ディレクトリ配下の`yt-dlp-plugins/tver/yt_dlp_plugins/extractor/`です
  - トラブル対応したくないため、同梱しませんので自身で`tver.py`を用意できる人向け
  - youtube-dl側でTVerの仕様変更への対応がされたら削除予定
  - でも、**ダウンロードできないよりはマシ、という人向け**
  - カスタムエクストラクタを使いたくない人は`bin`ディレクトリ配下の`yt-dlp-plugins`ディレクトリを削除してください

- Streaks用のm3u8の取得エラーが出る人向けにProxy接続をサポート
  - TVerの仕様変更に伴い、**日本国外からのダウンロードはエラーとなる可能性が非常に高いです**
  - **VPNやProxyなどを使って日本国内経由で利用**することでエラーを回避できる可能性があります
  - `user_setting.ps1`に`$script:proxyUrl`として`http://123.45.67.89:12345`形式で指定してください。Streaksからのマニフェスト取得時にはProxyを使用するようになります

### 3.3.6 Changed

- ForEach-Objectの利用を極力避け、高速化
- ファイルシステムへのアクセスを極力減らし、高速化
- youtube-dlの実行ファイル名を`youtube-dl`から`yt-dlp`に変更

### 3.3.6 Fixed

- 放送局ごとのフォルダを作成している際にファイルの移動に失敗する問題を修正 [Issue #204](https://github.com/dongaba/TVerRec/issues/204)

## [3.3.5](https://github.com/dongaba/TVerRec/releases/tag/v3.3.5)

### 3.3.5 Added

- yt-dlp-nightlyのサポート

### 3.3.5 Changed

- 番組移動時のディレクトリ検出を高速化
- ファイルシステム上のファイル名の最大長を超えるケースがあったため、ファイル名の最大長を変更

### 3.3.5 Fixed

- ダウンロード対象外ファイルがクリアされてしまうことがある問題を修正(できてるといいな) [Issue #187](https://github.com/dongaba/TVerRec/issues/187)
- ダウンロード履歴ファイルにも同様の対策を実施
- スケジュール設定の読み込みに失敗する問題を修正 [Issue #195](https://github.com/dongaba/TVerRec/issues/195)

## [3.3.4](https://github.com/dongaba/TVerRec/releases/tag/v3.3.4)

### 3.3.4 Added

### 3.3.4 Changed

### 3.3.4 Fixed

- mac環境の一部でyoutube-dlのプロセス数を正しくカウントできない問題を修正 [Issue #186](https://github.com/dongaba/TVerRec/issues/186)  [Issue #188](https://github.com/dongaba/TVerRec/issues/188) [Issue #189](https://github.com/dongaba/TVerRec/issues/189)

## [3.3.3](https://github.com/dongaba/TVerRec/releases/tag/v3.3.3)

### 3.3.3 Added

- 番組ディレクトリを作成せずにダウンロードするオプションを追加 [Issue #176](https://github.com/dongaba/TVerRec/issues/176)
- youtube-dlを使ったダウンロード時に、ランダムに生成したIPアドレスを使用するオプションを追加[Issue #180](https://github.com/dongaba/TVerRec/issues/180) [Issue #181](https://github.com/dongaba/TVerRec/issues/181)

### 3.3.3 Changed

- 個別ダウンロード時にダウンロード完了を待つまで処理を終了しないように変更 [Issue #175](https://github.com/dongaba/TVerRec/issues/175)
- DockerコンテナのベースイメージをUbuntu24.10に更新
- Dockerコンテナのフリーズ対策として、コンテナ実行時にはyoutube-dlにタイムアウトを設定
- Dockerコンテナでのダウンロードを高速化
- エピソード抽出処理を高速化

### 3.3.3 Fixed

- 放送年がわからない際に2/29の日付が取得されると処理が停止する問題を修正

## [3.3.2](https://github.com/dongaba/TVerRec/releases/tag/v3.3.2)

### 3.3.2 Added

### 3.3.2 Changed

- 移動先ディレクトリのチェックNGの場合でも処理停止しないように変更 [Issue #167](https://github.com/dongaba/TVerRec/issues/167)

### 3.3.2 Fixed

- リストダウンロード時にエラー表示される問題を修正 [Issue #169](https://github.com/dongaba/TVerRec/issues/169)

## [3.3.1](https://github.com/dongaba/TVerRec/releases/tag/v3.3.1)

### 3.3.1 Added

- 日本語以外の表記ができる機能を追加。とりあえず英語をサポート(その他の言語は言語ファイルの提供があれば追加)
- GUIから言語の切り替えができる機能を追加
- まもなく配信終了をダウンロードするキーワードを追加 [Issue #157](https://github.com/dongaba/TVerRec/issues/157)

### 3.3.1 Changed

- サンプルキーワードファイルのすべてのエントリーをコメントアウト。[Issue #156](https://github.com/dongaba/TVerRec/issues/156) & [Issue #135](https://github.com/dongaba/TVerRec/issues/135)

### 3.3.1 Fixed

## [3.3.0](https://github.com/dongaba/TVerRec/releases/tag/v3.3.0)

### 3.3.0 Added

### 3.3.0 Changed

### 3.3.0 Fixed

- Linuxでトースト通知時にコンソールにエラーメッセージが出る場合がある問題を修正

## [3.2.9](https://github.com/dongaba/TVerRec/releases/tag/v3.2.9)

### 3.2.9 Added

- 番組のエピソードIDが変更になった際に再ダウンロードする機能を追加

### 3.2.9 Changed

- それぞれのキーワードにマッチする番組の中で配信終了までの短いものからダウンロードするように
- 各種Typoを修正

### 3.2.9 Fixed

## [3.2.8](https://github.com/dongaba/TVerRec/releases/tag/v3.2.8)

### 3.2.8 Added

### 3.2.8 Changed

### 3.2.8 Fixed

- GUIからスケジュールベースの動作停止設定の設定値が保存されなかった不具合を修正 [Issue #143](https://github.com/dongaba/TVerRec/issues/143)

## [3.2.7](https://github.com/dongaba/TVerRec/releases/tag/v3.2.7)

### 3.2.7 Added

### 3.2.7 Changed

### 3.2.7 Fixed

- 変数名の命名規則違反を修正

## [3.2.6](https://github.com/dongaba/TVerRec/releases/tag/v3.2.6)

### 3.2.6 Added

- トップページの新しいコンポーネントをパース可能に
- サイトマップの新しいコンポーネントをパース可能に
- 曜日ごとのダウンロード休止時間を指定できるように [Issue #131](https://github.com/dongaba/TVerRec/issues/131)

### 3.2.6 Changed

- シリーズ名、シーズン名がエピソード名と同一の場合に、番組ファイル名にシリーズ名、シーズン名が重複しないように変更 [Issue #130](https://github.com/dongaba/TVerRec/issues/130)
- 個別ダウンロード時に、一度に大量のURLを指定しても同時ダウンロード数制御をするように変更 [Issue #132](https://github.com/dongaba/TVerRec/issues/132)
- メモリ使用量の削減と高速化

### 3.2.6 Fixed

- リスト作成の初回実行時にエラーメッセージが出る不具合を修正 [Issue #134](https://github.com/dongaba/TVerRec/issues/134)

## [3.2.5](https://github.com/dongaba/TVerRec/releases/tag/v3.2.5)

### 3.2.5 Added

- Windows用Arm版ffmpegのダウンロード機能を追加

### 3.2.5 Changed

- 「放送分」だけでなく「配信分」からも日付を取得
- サイトマップとトップページにアクセスできない際のエラーを抑止
- TVerIDを登録している状態でもマイページ以外ではTVerIDの情報を使わないように変更
- 個別ダウンロード時に同時ダウンロード数の制御をするように変更 [Issue #124](https://github.com/dongaba/TVerRec/issues/124)

### 3.2.5 Fixed

- フリーワードサーチが失敗する問題を修正
- Windows GUI版で、個別ダウンロードがエラーとなる問題を修正 [Issue #125](https://github.com/dongaba/TVerRec/issues/125)

## [3.2.4](https://github.com/dongaba/TVerRec/releases/tag/v3.2.4)

### 3.2.4 Added

### 3.2.4 Changed

### 3.2.4 Fixed

- サイトマップとトップページからの動画取得に失敗する問題を修正

## [3.2.3](https://github.com/dongaba/TVerRec/releases/tag/v3.2.3)

### 3.2.3 Added

- キーワード指定ファイルに番組エピソードの指定をできる機能を追加
- TVerIDを使っている人のマイページからの番組取得に対応
  - 設定ファイルに$script:myMemberSIDを追加
  - 本機能により、ダウンロード対象番組の管理をブラウザ上のマイページで管理することができるようになります
- Chrome拡張機能のTVerRec AssistantにMember SIDの取得機能を追加(TVerにログインして使用する場合に必要)
  - [使い方はWikiのこちらのページ参照](https://github.com/dongaba/TVerRec/wiki/platform_uid%E3%80%81platform_token%E3%80%81member_sid%E3%81%AE%E5%8F%96%E5%BE%97)
- GUI版の設定画面からMember SIDを指定できる機能を追加
- 個別ダウンロード時に複数URLを指定できる機能を追加

### 3.2.3 Changed

- GUI版の設定画面の高度な設定のグルーピングを変更
- Windows Sandbox環境の環境構築スクリプトを高速化
- Dockerコンテナにvimを同梱

### 3.2.3 Fixed

- 動画移動時に「Cannot create 'example' because a file or directory with the same name already exists.」が出てファイルの移動が出来ない問題を修正
- Windows SandBox環境でmshtaによるメッセージボックス描画が動作しない問題を修正

## [3.2.2](https://github.com/dongaba/TVerRec/releases/tag/v3.2.2)

### 3.2.2 Added

### 3.2.2 Changed

- シリーズタイトルの取得先を変更 (理由は、Series.Content.Titleだとファイル名が冗長になることがあることと、複数シーズン配信時に最新シーズン名になってしまうことがあるため)
- 番組移動時に、mp4とtsファイルだけでなくすべてのファイルを移動の対象にするように変更

### 3.2.2 Fixed

- ダウンロード先ディレクトリ、作業ディレクトリ、移動先ディレクトリの指定時に、末尾に`\`や`/`が入っていてもエラーとならないように修正
- 番組移動時に特殊文字を含むフォルダの取り扱いができていなかった問題を修正

## [3.2.1](https://github.com/dongaba/TVerRec/releases/tag/v3.2.1)

### 3.2.1 Added

- 動画の移動先ディレクトリがジャンクションとなっていて正常にファイル移動ができない場合の救済オプションを追加
- BS局のタグを追加
- 移動先ディレクトリのWindowsジャンクションのサポート (Thanks to [@seijit](https://github.com/seijit))

### 3.2.1 Changed

- 番組名から「《」と「》」に加え「【」と「】」で挟まれた文字も除去するように変更
- 番組名から「《」と「》」、「【」と「】」で挟まれた文字を削除する際に一定の長さ(10文字)がないと除去しないように変更
- エピソード番号が10の倍数になっている際に正しいエピソード番号を極力類推するように変更

### 3.2.1 Fixed

- GUI実行時にコマンドプロンプトに`True`と出力され続ける不具合を修正
- GUI設定画面表示時にエラーが出る不具合を修正

## [3.2.0](https://github.com/dongaba/TVerRec/releases/tag/v3.2.0)

### 3.2.0 Added

- TVerRecの自動アップデートでアップデートチャネルを選択可能に
- m3u8ファイルの取得、mpdファイルの取得に対応
- TVer番組のtsファイルのダウンロードに対応

### 3.2.0 Changed

- 念の為にGeoIP対策実施
- GUI設定画面にプリセットを呼び出す機能を追加
- 不要ファイル削除時にダウンロードディレクトリと保存ディレクトリのチェックの可否を選択可能に(デフォルトはチェックしない)
- GUI設定画面で、未設定項目について`デフォルト値`または`未設定`を表示するように変更
- エピソード番号が1桁の際に頭0埋めして2桁にするように変更
- GUI設定画面から設定できる項目を追加
- GUI設定画面でテキストボックスの幅が足りない場合に複数行化

### 3.2.0 Fixed

- アップデータがリストファイルのレイアウト変更に失敗するケースがある不具合を修正
- キーワードファイルに`epsodes/epxxxxxxxx`を指定すると`epsodes/epxxxxxxxx`でキーワード検索をしてしまう不具合を修正
- 低解像度ファイルのダウンロードのオプション指定の記載例に誤りがあった問題を修正
- Dockerコンテナで最新のPowerShellに実行権限がつかない問題を修正

## [3.1.0](https://github.com/dongaba/TVerRec/releases/tag/v3.1.0)

### 3.1.0 Added

- マイページからの番組取得に対応
  - 設定ファイルに`$script:myPlatformUID`を追加
  - 設定ファイルに`$script:myPlatformToken`を追加
- 新規キーワードの追加
  - `mypage/fav` = マイページ > お気に入り (TVerが管理する情報を取得)
  - `mypage/favorite` = マイページ > お気に入り (TVerRecがお気に入り番組、出演者、特集から各エピソードに変換)
  - `mypage/later` = マイページ > あとでみる
  - `mypage/resume` = マイページ > 続きから再生
  - `tag/independence` = 独立局
  - `tag/texttrackon` = 字幕あり
  - `tag/short` = 短尺(10分以内)
  - `tag/trailer` = 予告
- Chrome拡張機能のTVerRec Assistantを同梱
  - [使い方はWikiのこちらのページ参照](https://github.com/dongaba/TVerRec/wiki/platform_uid%E3%81%A8platform_token%E3%81%AE%E5%8F%96%E5%BE%97#chrome%E6%8B%A1%E5%BC%B5%E6%A9%9F%E8%83%BD%E3%81%AEtverrec-assistant%E3%82%92%E4%BD%BF%E3%81%86)
- トップページで急上昇バラエティを処理可能に
- ダウンロードリスト作成処理でリストファイルにあるリンクを除外するオプションを追加
  - 設定ファイルに`$script:listGenHistoryCheck`を追加
- Windows環境でGUI版の実行ログ表示について最大行数を設定可能に
  - 設定ファイルに`$script:guiMaxExecLogLines`を追加
- ダウンロードリスト作成処理でマルチスレッド処理を可能に(数倍の高速化)
- WSBの日本語化用スクリプトの追加
  - [使い方はWikiのこちらのページ参照](https://github.com/dongaba/TVerRec/wiki/Windows%E3%82%B5%E3%83%B3%E3%83%89%E3%83%9C%E3%83%83%E3%82%AF%E3%82%B9)

### 3.1.0 Changed

- メッセージ出力フォーマットの変更
- ファイルロックの精度を改善(ファイルロックのメカニズムを変更)
- エラーハンドリングを改善
- TVerからの情報取得処理を正規化・高速化
- トップページのパース精度向上
- マルチスレッド処理のデフォルトスレッド数を10に変更(ダウンロードリスト作成処理のマルチスレッド対応に伴うAPIアクセス集中の抑制)
- 連続稼働時のメモリ使用量の削減
- リストファイル出力時にキーワードファイルのコメントを削除
- DockerコンテナのBaseImageをUbuntu:24.04に変更
- キーワードサンプルファイルで`tag/short`のみを有効化(キーワードファイル未設定でも動作イメージがわかりやすいように)
- Dockerfileを最新のコードに合わせて修正
- GUIから設定をする際の高度な設定を複数タブに分割
- Mac用のffmpegをVersion7に対応
- Mac用のffmpegでApple Silicon対応

### 3.1.0 Fixed

- `&amp;`が正しく置換されない不具合を修正
- Unix時間への変換にタイムゾーンが考慮されていなかった不具合を修正
- トップページの処理でシリーズやシーズンを取得できていなかった不具合を修正
- リストファイルのサンプルファイルのレイアウトが間違っていた問題を修正
- WSB用のスクリプトが壊れていた問題を修正
- GUIからの設定の際に`$script:ytdlNonTVerFileName`の保存が正しくできなかった問題を修正
- GUIから設定の際に設定値に`=`を含む場合に正しく読み込まれたなかった問題を修正

## [3.0.2](https://github.com/dongaba/TVerRec/releases/tag/v3.0.2)

### 3.0.2 Added

### 3.0.2 Changed

- 不要ファイル削除処理の可読性とパフォーマンスを向上

### 3.0.2 Fixed

- MacとWindows/Linux混在環境で移動処理が濁点や半濁点を含むディレクトリを取りこぼす問題を修正

## [3.0.1](https://github.com/dongaba/TVerRec/releases/tag/v3.0.1)

### 3.0.1 Added

### 3.0.1 Changed

### 3.0.1 Fixed

- サイトマップダウンロード時に内部ファイル名が表示される不具合を修正

## [3.0.0](https://github.com/dongaba/TVerRec/releases/tag/v3.0.0)

### 3.0.0 Added

- TVerの提供するエピソード番号が｢1｣のときに、適切なエピソード番号を類推して置換する機能を追加
- ダウンロードリストに番組説明を出力するオプションを追加
- アップデータ自身のアップデート機能を追加
- DockerコンテナにおけるApple Siliconのサポート

### 3.0.0 Changed

- コード最適化によるメモリ使用量の削減
- 動画移動時に子ディレクトリだけでなく配下のディレクトリ全てを移動の対象にするように変更
- dash形式の動画を極力ダウンロードしないように変更
- logディレクトリの新設
- Mac混在環境でダウンロード対象外リストがNFDで記載されてしまった場合にNFCで出力するように変更
- ダウンロード対象外リストとの比較をNFCに変換して実施するように変更
- ダウンロード対象外リストとの比較でワイルドカードを処理可能に変更
- メモリ使用量削減
- トップページからのダウンロードの大幅高速化

### 3.0.0 Fixed

- GUI版の実行ログを取りこぼすことがある不具合を修正
- Windows環境でフォルダ指定にドライブを指定した際にエラーが発生する場合がある不具合を修正

## [2.9.9](https://github.com/dongaba/TVerRec/releases/tag/v2.9.9)

### 2.9.9 Added

### 2.9.9 Changed

### 2.9.9 Fixed

- GUI版で「キーワードファイル」「除外リスト」「リストファイル」のクイックリンクが動作しない不具合の修正
- Tver以外のサイトからダウンロードが出来なくなっていた不具合の修正

## [2.9.8](https://github.com/dongaba/TVerRec/releases/tag/v2.9.8)

### 2.9.8 Added

- 個別ダウンロードでTVer以外のURLも許容する機能を追加(ただし整合性検証等の追加機能には未対応)

### 2.9.8 Changed

- CUI版でループ処理実行時に待機残り時間を表示する機能を改善
- コードリファクタリング
- Windows環境でwingetがない場合にwingetの入手先へのリンクを表示する機能を追加
- 番組の情報を引き回すためにカスタムオブジェクトを作成
- ディレクトリ体系を整理

### 2.9.8 Fixed

- ffmpeg 6.1に対応
- Windows環境でPowerShell 7.4.0のバグにより整合性検証が必ず失敗する問題に対処

## [2.9.7](https://github.com/dongaba/TVerRec/releases/tag/v2.9.7)

### 2.9.7 Added

- 個別ダウンロード時にダウンロード対象外リストや履歴を無視して強制ダウンロードする機能を追加

### 2.9.7 Changed

- tver_functions.ps1を分割

### 2.9.7 Fixed

- 履歴ファイルが0件時にリストダウンロードが失敗する問題を修正

## [2.9.6](https://github.com/dongaba/TVerRec/releases/tag/v2.9.6)

### 2.9.6 Added

### 2.9.6 Changed

### 2.9.6 Fixed

- 1ファイルコミット漏れ

## [2.9.5](https://github.com/dongaba/TVerRec/releases/tag/v2.9.5)

### 2.9.5 Added

- CUI版でループ処理実行時に待機残り時間を表示する機能を追加
- TVerRecの配置ディレクトリをチェックする機能を追加(スペースを含むディレクトリでは動作不可)

### 2.9.5 Changed

- 変数のスコープを調整
- 帯域制限しない設定を追加
- 設定ファイルの項目名を調整
- 一部処理の共通化とリファクタリング
- リストダウンロード処理のリファクタリング
- ダウンロードリスト作成処理のリファクタリング
- ダウンロードリスト作成処理の進捗表示を変更
- ダウンロード作成処理のマルチスレッド処理を廃止
- ダウンロード対象外ファイルとの突合処理の精度を向上
- ダウンロード対象外ファイル更新処理の信頼性を改善
- ダウンロード履歴との突合処理をリファクタリング(不具合があったかも?)

### 2.9.5 Fixed

- ffprobeの簡易検証が失敗する問題を修正
- 検証を無効化している際にループ処理が番組移動処理にいかない問題を修正
- 不要ファイル削除処理で、ダウンロード対象外リストに入っているディレクトリが削除されないことがある問題を修正
- GUI版の設定画面で設定値に`=`を含む値の読み込み不具合を修正
- ダウンロード履歴やダウンロード対象外リストが0件時にエラーが出ることがある不具合を修正
- Linux/Mac環境でホームディレクトリ配下にダウンロード先ディレクトリを設定し`~`で設定ファイルを記載している場合の不具合を修正

## [2.9.4](https://github.com/dongaba/TVerRec/releases/tag/v2.9.4)

### 2.9.4 Added

### 2.9.4 Changed

### 2.9.4 Fixed

- 個別ダウンロードが失敗する不具合を修正

## [2.9.3](https://github.com/dongaba/TVerRec/releases/tag/v2.9.3)

### 2.9.3 Added

### 2.9.3 Changed

- ダウンロード履歴がない場合のエラーメッセージを抑制

### 2.9.3 Fixed

- サイトマップからの全件ダウンロード時のパースエラーを修正
- ダウンロード対象外リストがからの場合の削除処理の不具合を修正

## [2.9.2](https://github.com/dongaba/TVerRec/releases/tag/v2.9.2)

### 2.9.2 Added

### 2.9.2 Changed

- どうやら自動アップデート機能に不具合あるようなので自動アップデートを無効化

### 2.9.2 Fixed

## [2.9.1](https://github.com/dongaba/TVerRec/releases/tag/v2.9.1)

### 2.9.1 Added

### 2.9.1 Changed

### 2.9.1 Fixed

- GUI版もTVerRecの自動アップデートの不具合を修正(できたかな?)

## [2.9.0](https://github.com/dongaba/TVerRec/releases/tag/v2.9.0)

v2.8.2以降で特定条件下でTVerRecの自動アップデートがされない不具合がありました。
自動アップデートがされずに毎回自動アップデートの画面が出ている場合は、win/update_tverrec.cmdまたはunix/update_tverrec.shを実行するか、v2.9.0まで手動でバージョンアップをお願いします。

### 2.9.0 Added

### 2.9.0 Changed

### 2.9.0 Fixed

- GUI版もTVerRecの自動アップデートの不具合を修正(できたかな?)

## [2.8.9](https://github.com/dongaba/TVerRec/releases/tag/v2.8.9)

v2.8.2以降で特定条件下でTVerRecの自動アップデートがされない不具合がありました。
自動アップデートがされずに毎回自動アップデートの画面が出ている場合は、win/update_tverrec.cmdまたはunix/update_tverrec.shを実行するか、v2.8.9まで手動でバージョンアップをお願いします。

### 2.8.9 Added

### 2.8.9 Changed

### 2.8.9 Fixed

## [2.8.8](https://github.com/dongaba/TVerRec/releases/tag/v2.8.8)

### 2.8.8 Added

### 2.8.8 Changed

### 2.8.8 Fixed

- ダウンロードディレクトリがからの場合のエラーハンドリングを追加
- TVerRecの自動アップデートの不具合を修正(できたかな?)

## [2.8.7](https://github.com/dongaba/TVerRec/releases/tag/v2.8.7)

自動アップデートテストのための空アップデート

### 2.8.7 Added

### 2.8.7 Changed

### 2.8.7 Fixed

## [2.8.6](https://github.com/dongaba/TVerRec/releases/tag/v2.8.6)

### 2.8.6 Added

### 2.8.6 Changed

- likeをmatchに置き換えることによる性能改善

### 2.8.6 Fixed

- TVerRecの自動アップデートの不具合を修正(できたかな?)

## [2.8.5](https://github.com/dongaba/TVerRec/releases/tag/v2.8.5)

### 2.8.5 Added

### 2.8.5 Changed

- likeをmatchに置き換えることによる性能改善

### 2.8.5 Fixed

- ダウンロード対象外リストのディレクトリが削除されないことがある不具合を修正

## [2.8.4](https://github.com/dongaba/TVerRec/releases/tag/v2.8.4)

### 2.8.4 Added

### 2.8.4 Changed

### 2.8.4 Fixed

- ダウンロード対象外リストのディレクトリが削除されないことがある不具合を修正

## [2.8.3](https://github.com/dongaba/TVerRec/releases/tag/v2.8.3)

### 2.8.3 Added

### 2.8.3 Changed

### 2.8.3 Fixed

- 空ディレクトリ削除時のメッセージ出力不正を修正

## [2.8.2](https://github.com/dongaba/TVerRec/releases/tag/v2.8.2)

### 2.8.2 Added

- ダウンロード済み番組の番組IDが変更になった際にも履歴ファイルに追記し以後処理しない機能を追加
- ダウンロード速度を制限する機能を追加
- Mac/Linux環境でトースト通知する機能を追加

### 2.8.2 Changed

- Doceker環境で各種設定ファイルをcontainer-dataディレクトリにコピーするように
- linux/386とlinux/arm/v7のDocker作成を廃止
- Windows/Linux環境でのffmpegの取得先をyt-dlpの自動ビルド版に変更
- Mac環境でのffmpegの最新バージョンの取得方法を改善
- Linux/Mac環境でExecutionPolicyの指定を削除
- Docker環境ではTVerRecの自動更新を無効化
- youtube-dlの更新スクリプトを1本化
- Join-Pathの利用を拡大
- GUIの画像データの外出し
- アップデートスクリプト実行時に最新のアップデートスクリプトをダウンロードするように
- コンソール表示の文字色を変更
- ループ処理改善による処理の高速化
- 配列をリストにすることで処理の高速化
- 正規表現のエスケープ･案エスケープ処理を改善
- メモリ開放タイミングの調整による高速化
- メモリ使用量の削減
- トースト通知を無効化するオプションを追加
- 可読性の向上と性能向上
- 無視対象のディレクトリ削除処理を高速化
- ディレクトリ移動処理の高速化
- if文削減による処理の高速化
- 空ディレクトリ削除処理の高速化
- ダウンロード履歴との照合を高速化
- ループ処理時に整合性検証で不整合があった場合には再度ダウンロードからやり直すように
- youtube-dlのオプションを追加で設定できるように
- GUIでエラーメッセージ、警告メッセージを色付きで出力するように

### 2.8.2 Fixed

- Docker環境でxz-utilsが漏れていた問題修正
- Docker環境でsedによる置換が間違っていた問題を修正
- Docker環境でsleepが効いていなかった問題を修正
- Linux環境で自動ダウンロードするffmpegに起因するダウンロードエラーが発生する問題を修正
- ファイル削除時にアクセスできないファイルの存在を無視するように修正
- ダウンロードリスト作成スクリプトの変数未定義不具合を修正
- Windows環境のリストダウンロードスクリプトのファイル名が間違っていた問題を修正
- アップデートスクリプトが自身を更新しないように修正
- ファイルロックの精度を向上
- 半角カタカナの変換不具合を修正
- 整合性検証中にダウンロード履歴が破損する場合がある問題を修正

## [2.8.1](https://github.com/dongaba/TVerRec/releases/tag/v2.8.1)

### 2.8.1 Added

- 番組シリーズ名、番組シーズン名、番組放送日、番組エピソード番号をファイル名に含めるかどうかを個別設定可能に
- ダウンロード履歴の保持日数を変更可能に
- 番組ファイルへの字幕データの埋め込みを選択可能に
- 番組ファイルへのメタタグの埋め込みを選択可能に

### 2.8.1 Changed

- ダウンロードしようとしているファイル名をダウンロード履歴にあるファイル名と比較し、同じ場合には処理をスキップするように

### 2.8.1 Fixed

- Mac環境でffmpegが正常に更新されない問題を修正
- Mac環境/Linux環境でstop_tverrec.shが正しく動作しなかった問題を修正

## [2.8.0](https://github.com/dongaba/TVerRec/releases/tag/v2.8.0)

### 2.8.0 Added

- サイトマップを処理して番組をダウンロードする機能を追加
- トップページ配下の特集ページからの番組取得機能を追加

### 2.8.0 Changed

- GUIの設定画面で設定をしない場合の表示を変更
- 処理の進捗をより詳細に表示するように変更
- GUIでループ処理をする際に定期的にメモリ解放をするように変更(ただし高価は低い模様)

### 2.8.0 Fixed

## [2.7.9](https://github.com/dongaba/TVerRec/releases/tag/v2.7.9)

### 2.7.9 Added

### 2.7.9 Changed

- Windows環境でuser_setting.ps1が存在しない場合に、GUIの設定画面を表示するように変更

### 2.7.9 Fixed

- GUIの設定画面がフリーズする問題を修正

## [2.7.8](https://github.com/dongaba/TVerRec/releases/tag/v2.7.8)

### 2.7.8 Added

### 2.7.8 Changed

### 2.7.8 Fixed

- TVerRecの自動更新時にwinディレクトリ内が消失する問題を修正
- Windows環境でuser_setting.ps1が存在しない際にフリーズする問題を修正

## [2.7.7](https://github.com/dongaba/TVerRec/releases/tag/v2.7.7)

### 2.7.7 Added

### 2.7.7 Changed

### 2.7.7 Fixed

- TVerRecの自動更新機能の不具合を修正(まだ残っているかも。。)
- Alpine LinuxのDockerfileの不具合を修正

## [2.7.6](https://github.com/dongaba/TVerRec/releases/tag/v2.7.6)

### 2.7.6 Added

- Windows環境向けにGUI画面を追加(予定)
- Windows Sandbox環境の設定ファイルを追加

### 2.7.6 Changed

- 移動先ディレクトリを複数指定した際に区切り文字前後にスペースがあっても動作するように
- 文言の微調整
- アプリロゴの変更
- トースト通知のアイコンの切り抜きを丸から四角に変更
- TVerRecの更新処理を改善

### 2.7.6 Fixed

- 個別ダウンロードでTVerの番組URL以外を入力した際に無限ループになっていた問題を修正
- ffmpegとyoutube-dlのバー助演チェックに失敗する場合がある問題を修正

## [2.7.5](https://github.com/dongaba/TVerRec/releases/tag/v2.7.5)

### 2.7.5 Added

### 2.7.5 Changed

### 2.7.5 Fixed

- 整合性チェックに失敗した履歴の削除ができなかった問題を修正

## [2.7.4](https://github.com/dongaba/TVerRec/releases/tag/v2.7.4)

### 2.7.4 Added

### 2.7.4 Changed

### 2.7.4 Fixed

- 整合性チェックに失敗した履歴の削除ができなかった問題を修正

## [2.7.3](https://github.com/dongaba/TVerRec/releases/tag/v2.7.3)

### 2.7.3 Added

### 2.7.3 Changed

- ダウンロードリスト作成時に、すでにダウンロード履歴ファイルにある番組を除外するように変更
- ダウンロードの進行状況がわかるように、Windows環境におけるyoutube-dlやffmpegのウィンドウ表示を「最小化」を初期値に変更
- ダウンロード履歴の重複削除のロジックを変更(videoPageで単一のものを残すように)

### 2.7.3 Fixed

- ファイルの削除処理の並列化でファイルが削除されないことがあるので廃止
- ファイルの移動処理の並列化でファイルが移動されないことがあるので廃止
- 「.」で終わる番組名のダウンロード不具合を修正
- チェック対象に同一のファイル名が複数ある際の整合性チェックを改善

## [2.7.2](https://github.com/dongaba/TVerRec/releases/tag/v2.7.2)

### 2.7.2 Added

- リストファイル0件時のエラー処理追加

### 2.7.2 Changed

- 並列処理時に逐次進捗を表示するように変更
- Google Colab用のテンプレートを複数Cellに分割
- Google Colab用のテンプレートにGoogle Driveをマウントする処理を追加
- Write-Hostの廃止
- TVerの仕様変更に伴いダウンロード履歴の重複削除ロジックを変更
- 動画ファイルの簡易検証実行する際に必ずエラーになってした不具合を修正

### 2.7.2 Fixed

- ytdl-patchedの自動更新でエラーメッセージの間違いを修正
- ffmpegの自動更新でffprobeのダウンロード不具合を修正
- リストダウンロードでダウンロード済判定の不具合を修正

- ## [2.7.1](https://github.com/dongaba/TVerRec/releases/tag/v2.7.1)

### 2.7.1 Added

- Google Colab用のテンプレートを追加

### 2.7.1 Changed

### 2.7.1 Fixed

- Dockerコンテナ版の設定ファイル不備を修正
- ダウンロード対象外リストが0件の際にエラーとなる不具合を修正

## [2.7.0](https://github.com/dongaba/TVerRec/releases/tag/v2.7.0)

### 2.7.0 Added

- Dockerコンテナの作成に対応
- TVerRecの自動アップデート機能を追加
- Mac/Linux環境向けのffmpeg自動更新機能を追加
- Windows環境でZone Identifier削除機能を追加

### 2.7.0 Changed

- ソースコード内のPath表記をUnix形式に統一
- ソースコードの折り返しを極力短く
- batファイルをcmdファイルに変更
- cmdファイル以外をBOMなしUTF-8、LFに統一
- `$script:addEpisodeNumber` のデフォルト値を `$true` に変更
- `$script:removeSpecialNote` のデフォルト値を `$true` に変更
- ダウンロード対象外番組判定を高速化(対象外判定されたキーワードを優先的に判定)
- ファイルの削除処理の並列化(環境によっては高速化)
- ファイルの移動処理の並列化(環境によっては高速化)
- 番組移動先ディレクトリ`$script:saveBaseDir`に複数ディレクトリを指定可能に
- `keyword.sample.conf`の初期状態をすべてコメントアウトに

### 2.7.0 Fixed

- Linux環境でnohupのエラーメッセージが出ないように修正
- Windows環境でWindowsTerminal.exeで実行されたプロセスが終了されない問題を修正
- 特殊文字を含むダンロード対象外判定が正しく実行されていなかった不具合を修正
- 個別ダウンロード処理が終了しない不具合を修正

## [2.6.9](https://github.com/dongaba/TVerRec/releases/tag/v2.6.9)

3件のプルリクを取り込み

### 2.6.9 Added

### 2.6.9 Changed

- youtube-dlにffmpegのPathを渡すように変更

### 2.6.9 Fixed

- TV局毎のディレクトリに保存している際に、番組を最終移動先に正しく移動できるように修正
- youtube-dlの実行監視の不具合を修正

## [2.6.8](https://github.com/dongaba/TVerRec/releases/tag/v2.6.8)

### 2.6.8 Added

### 2.6.8 Changed

### 2.6.8 Fixed

- v2.6.7で追加した2つのBATファイルの改行コードが不正だった問題を修正

## [2.6.7](https://github.com/dongaba/TVerRec/releases/tag/v2.6.7)

### 2.6.7 Added

### 2.6.7 Changed

- シーズン名の取得方法を変更(複数シーズンがある際に現在メインで配信中のシリーズ名が返ってくることがあるため)
- ネット界隈で設定が難しいと指摘があったので`system_settings.ps1`に追加の説明を記載
- シリーズ名がシーズン名を含む場合はシーズン名をクリア

### 2.6.7 Fixed

- ReadmeのWikiへのリンク切れを修正

## [2.6.6](https://github.com/dongaba/TVerRec/releases/tag/v2.6.6)

### 2.6.6 Added

- エピソード番号を取得しファイル名に付加する機能を追加(下位互換性担保のため初期値はオフ)
- 番組名に付く「《」と「》」で挟まれたコメント(補足情報?)を削除する機能を追加(下位互換性担保のため初期値はオフ)
- ダウンロード履歴ファイルの破損レコードを削除する機能を追加
- キーワードから番組リストを出力する機能を追加

### 2.6.6 Changed

- Readmeを修正、更新
- 用語の統一(ビデオ、番組を番組に統一、など)
- シーズン名が「本編」の場合にシーズン名をクリア
- 一部特殊文字の扱いを変更(削除や半角変換をせず全角で出力)
- 機能追加に伴い、変数名やファイル名を変更

### 2.6.6 Fixed

- youtube-dlの仕様により一部特殊文字を含む番組がダウンロードされなかった問題を修正
- 処理済み番組本数のカウントが不正だった問題を修正

## [2.6.5](https://github.com/dongaba/TVerRec/releases/tag/v2.6.5)

### 2.6.5 Added

### 2.6.5 Changed

- Readmeを少し修正

### 2.6.5 Fixed

- v2.6.4で個別ダウンロードの修正を漏らしていた[不具合](https://github.com/dongaba/TVerRec/issues/22)を修正

## [2.6.4](https://github.com/dongaba/TVerRec/releases/tag/v2.6.4)

### 2.6.4 Added

### 2.6.4 Changed

- ファイルI/Oの削減による大幅高速化(条件により最大で数十～数百倍)
- ダウンロード対象外との照合を高速化

### 2.6.4 Fixed

## [2.6.3](https://github.com/dongaba/TVerRec/releases/tag/v2.6.3)

### 2.6.3 Added

### 2.6.3 Changed

### 2.6.3 Fixed

- youtube-dlのプロセス数取得の[不具合](https://github.com/dongaba/TVerRec/issues/21)を修正

## [2.6.2](https://github.com/dongaba/TVerRec/releases/tag/v2.6.2)

### 2.6.2 Added

### 2.6.2 Changed

- ハングアップ対策としてWebアクセスにタイムアウトを設定(system_setting.ps1で秒数を指定可能)
- Linuxでのyoutube-dlの多重度チェックをより正確に
- エラーハンドリングの改善
- TVer側の仕様変更により、番組名検索を廃止
- Windowsでの 処理の高速化

### 2.6.2 Fixed

- ダウンロード先ディレクトリが空の際にエラーとなる問題を修正
- LinuxとMacでファイル名・ディレクトリ名に使えない文字のチェックが不完全だったのを修正

## [2.6.1](https://github.com/dongaba/TVerRec/releases/tag/v2.6.1)

### 2.6.1 Added

### 2.6.1 Changed

### 2.6.1 Fixed

- youtube-dlの多重度チェックが正しく機能せずyoutube-dlを無限に起動していた問題修正

## [2.6.0](https://github.com/dongaba/TVerRec/releases/tag/v2.6.0)

### 2.6.0 Added

### 2.6.0 Changed

### 2.6.0 Fixed

- `system_setting.ps1`にTypoがあったのを修正

## [2.5.9](https://github.com/dongaba/TVerRec/releases/tag/v2.5.9)

### 2.5.9 Added

### 2.5.9 Changed

### 2.5.9 Fixed

- `$script:saveBaseDir`で指定されるディレクトリが空の際にエラーとなる[問題](https://github.com/dongaba/TVerRec/issues/19)を修正

## [2.5.8](https://github.com/dongaba/TVerRec/releases/tag/v2.5.8)

### 2.5.8 Added

### 2.5.8 Changed

### 2.5.8 Fixed

- Linux用の番組移動先先ディレクトリの指定が間違っている[問題](https://github.com/dongaba/TVerRec/issues/18)を修正

## [2.5.7](https://github.com/dongaba/TVerRec/releases/tag/v2.5.7)

### 2.5.7 Added

- PowerShell CoreがインストールされていないWindowsで実行した場合に、PowerShellを自動でインストールするか確認する機能を追加

### 2.5.7 Changed

- Windows PowerShellのサポートを終了(Windows PowerShellに起因する不具合が多いため。ご理解ください)

### 2.5.7 Fixed

## [2.5.6](https://github.com/dongaba/TVerRec/releases/tag/v2.5.6)

### 2.5.6 Added

### 2.5.6 Changed

- 標準のyoutube-dlをyt-dlpに変更
- 番組検証時のデコードオプションが設定されている際のメッセージの色を変更
- ソースコードの可読性を向上
- 番組検証時に検証結果をOK/NGで表示するように変更
- Linuxで一括ダウンロードを即時再実行できるように変更

### 2.5.6 Fixed

- Linuxでyoutube-dlの指定をyt-dlpにした際に、同時多重ダウンロードの上限が効いていなかった問題を修正
- 一部Linux環境でyoutube-dlの実行に失敗する問題の修正
- サンプルファイルの名称設定ミスを修正
- トップページの特集ページの処理のバグを修正

## [2.5.5](https://github.com/dongaba/TVerRec/releases/tag/v2.5.5)

### 2.5.5 Added

### 2.5.5 Changed

- TVerRecのバージョンアップチェック機能を改良
- コンソールウィンドウ内のプログレスバーを廃止
- コンソール表示を簡素化
- PowerShell Coreの存在チェックを改良(Microsoft Store版も判定可能に)
- ソースコードのリファクタリング
- 番組移動時に空ディレクトリを削除しない仕様に変更

### 2.5.5 Fixed

- ゴミファイルの削除が不完全な場合がある問題を修正
- ダウンロード対象外に入っている番組がダウンロードされることがある問題を修正

## [2.5.4](https://github.com/dongaba/TVerRec/releases/tag/v2.5.4)

### 2.5.4 Added

### 2.5.4 Changed

- Powershell Desktopで放送日のパースに失敗する問題を修正

### 2.5.4 Fixed

## [2.5.3](https://github.com/dongaba/TVerRec/releases/tag/v2.5.3)

### 2.5.3 Added

### 2.5.3 Changed

- 関数の引数チェックを厳密するように変更
- PowerShell Coreが使える際には、PowerShell Desktop用のファイルを生成しないように変更 (Windows限定)
- バージョンアップ時に設定ファイルがクリアされないようにする
- リアルタイム配信には対応していないため、ダウンロードを試みないように変更
- 番組説明の取得用URLの動的変化に対応
- ファイル名を生成する際に全角ピリオドも半角に変更するように変更

### 2.5.3 Fixed

- 空白を含むタイトル検索が正しく処理できていなかった問題を修正
- バージョンアップ通知が正しくされていなかった問題を修正

## [2.5.2](https://github.com/dongaba/TVerRec/releases/tag/v2.5.2)

### 2.5.2 Added

### 2.5.2 Changed

### 2.5.2 Fixed

- 一部変数の展開に失敗していたのを修正

## [2.5.1](https://github.com/dongaba/TVerRec/releases/tag/v2.5.1)

### 2.5.1 Added

- バージョンアップ時にリストファイル(Keywordファイル、Ignoreファイル)がクリアされないようにする

### 2.5.1 Changed

- TVerへのAPIコール数を削減し高速化
- ファイルアクセスを削減し高速化
- ソースコードのリファクタリングを実施
- GEO IPのチェックの完全廃止

### 2.5.1 Fixed

- トーストメッセージの誤植を修正
- エラーメッセージの誤植を修正

## [2.5.0](https://github.com/dongaba/TVerRec/releases/tag/v2.5.0)

### 2.5.0 Added

- 新着番組リストからのダウンロード機能を追加
- ランキングからのダウンロード機能を追加

### 2.5.0 Changed

- トップページの解析を最新のトップページレイアウトに合わせて改良
- ジャンルIDなどの指定による検索を変更し、タグ検索として新着番組以外からも対象を検索するように改良
- 指定可能な タグ検索 (旧ID検索) に使用するTagの最新化(Keyword.confを更新しています)
- 指定可能なTV局の最新化(Keyword.confを更新しています)
- 標準のyoutube-dlをytdl-patchedに変更
- ダウンロード対象外リストの判定を番組シリーズ名だけでなく番組名でも判定するように変更

### 2.5.0 Fixed

## [2.4.9](https://github.com/dongaba/TVerRec/releases/tag/v2.4.9)

### 2.4.9 Added

### 2.4.9 Changed

- youtube-dlの取得元を2箇所から選択できるように変更

### 2.4.9 Fixed

- 毎回yt-dlpがダウンロードされる問題を修正

## [2.4.8](https://github.com/dongaba/TVerRec/releases/tag/v2.4.8)

### 2.4.8 Added

### 2.4.8 Changed

- トースト表示時の不要なメッセージを削減
- youtube-dlを別バージョンに差し替え

### 2.4.8 Fixed

## [2.4.7](https://github.com/dongaba/TVerRec/releases/tag/v2.4.7)

### 2.4.7 Added

### 2.4.7 Changed

### 2.4.7 Fixed

- Windows用の起動BATがLOOPに失敗する不具合を修正 (泣)

## [2.4.6](https://github.com/dongaba/TVerRec/releases/tag/v2.4.6)

### 2.4.6 Added

### 2.4.6 Changed

### 2.4.6 Fixed

- Windows用の起動BATがLOOPに失敗する不具合を修正

## [2.4.5](https://github.com/dongaba/TVerRec/releases/tag/v2.4.5)

### 2.4.5 Added

- Windows向けトースト通知機能を追加

### 2.4.5 Changed

- バージョンアップ時にダウンロード履歴ファイルが上書きされないように修正
- Windowsの一括実行BATでキーボード入力による終了処理を追加

### 2.4.5 Fixed

- Windows PowerShell環境でダウンロードファイルの移動に失敗する不具合を修正

## [2.4.4](https://github.com/dongaba/TVerRec/releases/tag/v2.4.4)

### 2.4.4 Added

- ハートビート機能を追加

### 2.4.4 Changed

- ライセンスをApache 2ライセンスからMITライセンスに変更

### 2.4.4 Fixed

- ダウンロード履歴の引き落としがされない問題を修正

## [2.4.3](https://github.com/dongaba/TVerRec/releases/tag/v2.4.3)

### 2.4.3 Added

- ツールの自動アップデートを無効化するオプションを追加(「$true」で無効化。いずれも初期値は$false)
  - youtube-dlの自動アップデートを無効化 $script:disableUpdateYoutubedl = $true
  - ffmpegの自動アップデートを無効化$script:disableUpdateFfmpeg = $true

### 2.4.3 Changed

### 2.4.3 Fixed

## [2.4.2](https://github.com/dongaba/TVerRec/releases/tag/v2.4.2)

### 2.4.2 Added

- 番組検証の高速化オプションを2つ追加(「$true」で高速化。いずれも初期値は$false)
  - ffprobeを使った簡易検証 $script:simplifiedValidation = $true
  - 番組検証を全く行わない $script:disableValidation = $true
- 放送局ごとのディレクトリを作ってからダウンロードするオプションを追加(「$true」で有効化。初期値は$false)

### 2.4.2 Changed

- ダウンロードファイル検証時の冗長なメッセージを削除

### 2.4.2 Fixed

- ステータスバーが表示されない問題を修正

## [2.4.1](https://github.com/dongaba/TVerRec/releases/tag/v2.4.1)

### 2.4.1 Added

### 2.4.1 Changed

- user_setting.ps1にMacやLinux用の指定方法を追加

### 2.4.1 Fixed

- Linux/Macでyoutube-dlがダウンロードされない問題を修正
- Windows Power Shellで不要ファイル削除機能でエラーとなっていた問題を修正

## [2.4.0](https://github.com/dongaba/TVerRec/releases/tag/v2.4.0)

### 2.4.0 Added

- TVerのトップページに表示される番組をダウンロードするキーワード「toppage」を追加

### 2.4.0 Changed

- Invoke-WebRequestのプログレスバーを非表示に変更

### 2.4.0 Fixed

- youtube-dlがダウンロードされない問題を修正
- ffmpegがダウンロードされない問題を修正
- 一部ファイルの読み込みに失敗していた問題を修正

## [2.3.9](https://github.com/dongaba/TVerRec/releases/tag/v2.3.9)

### 2.3.9 Added

- TVerRec自身のバージョンチェック機能を追加

### 2.3.9 Changed

- `src`ディレクトリ内の構成を変更
- 設定ファイルの拡張子を変更
- Windows PowerShell環境用のソースコードの精製方法を変更

### 2.3.9 Fixed

- Invoke-Expressionの使用を中止
- ffmpegErrorLogのゴミが削除されなかった不具合を修正
- ffmpegのMac/Linux向けダウンロード機能が失敗する不具合を修正
- Windows PowerShell環境での複数のバグを修正

## [2.3.8](https://github.com/dongaba/TVerRec/releases/tag/v2.3.8)

### 2.3.8 Added

- TVerのリニューアルによりフリーワード検索の精度が大幅に下がっていますので、できればタレントID指定、番組ID指定でダウンロードしたほうが確実です。
- 同様にジャンル指定の精度も大幅に下がっているようですのでご注意ください。

### 2.3.8 Changed

- `conf/keyword.conf`をテキストエディターで開いてダウンロード対象のタレントの名前や番組名、ジャンル、TV局などを設定します
  - 不要なキーワードは `#` でコメントアウトするか削除してください。
  - 主なジャンルは網羅しているつもりですが、不足があるかもしれませんので、必要に応じて適宜自分で補ってください。
  - ダウンロード対象の指定の方法はいくつかありますが、現在のところaとbが確実にダウンロードする方法です。cとdとeはTVerの検索機能が改善されるまで番組を取りこぼす可能性や不要な番組が山ほどダウンロードされる可能性が高いです。
    1. **タレントID指定**(番組IDはTVerのサイトで確認できます)
    2. **番組ID指定**(番組IDはTVerのサイトで確認できます)
    3. **ジャンル指定**(事前に用意されているもののみ)
    4. **番組タイトル**のみを対象としたフリーワード検索
    5. **フリーワード指定**

### 2.3.8 Fixed
