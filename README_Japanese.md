[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World)は、2014年にリリースされたマルチプレイヤーオンラインバトルアリーナ（MOBA）ゲームです。このゲームは[Nival](http://nival.com/)社によって、主にC++で書かれた独自のゲームエンジン上で開発されました。

ゲームは「キャッスル」と「バトル」の2つのパートで構成されています。プレイヤーはロードまたはレディとしての役割を担います。キャッスルでは、プレイヤーは建物を建設し、ヒーローを雇用し、彼らのためにタレントを選びます。バトルでは、プレイヤーはヒーローを操作し、タレントを駆使して他のプレイヤーとチームバトルを行います。

2024年に、ゲームのバトル部分のソースコードが[特別なライセンス](LICENSE.md)の下で公開されました。商業利用は禁止されていますが、ゲームコミュニティや研究目的には完全にオープンです。使用前に[ライセンス契約](LICENSE.md)の条件を注意深くお読みください。

## このリポジトリに含まれるもの
- `pw` — バトル部分のメインコード
- `pw_publish` — チートコードとクライアントエディターが組み込まれたバトル部分のコンパイル済みクライアント
- `pw/branches/r1117/Bin/PF_Editor.exe` — ゲームデータエディター

## 準備
このリポジトリからデータをダウンロードし、`Bin`フォルダをメインのゲームデータと統合する必要があります。手順は以下の通りです。

1. フォルダ`pw_publish/branch/Client/PvP/Bin`を`pw/branches/r1117`にコピーし、既存のファイルを置き換えます。
2. チートコード付きのクライアント`pw/branches/r1117/Bin/PW_Game.exe`を実行します。
3. 正しく行われれば、画像がない黒い画面のローディングウィンドウが表示されます。
4. フォルダ`Profiles -> game.cfg`で、`local_game 0`を`local_game 1`に変更します。
5. チートコード付きのクライアントを実行します。これで、マップやヒーローを選択し、戦闘を開始できるロビーが表示されるはずです。
6. ゲーム中にキーボードのチルダ(~)キーを押すと、チートコード入力用のコンソールが表示されます。

エラーが発生した場合は、`pw/branches/r1117/Bin/logs`にあるログファイルを確認してください。

## ゲームデータ
データはエディターを通して編集でき、`pw/branches/r1117/Data`に保存されています。

データを編集することで次のことが可能です。
1. ヒーロータレントとアビリティの説明を変更
2. ヒーロータレントとアビリティの修正
3. クリープとタワーのロジックを変更
4. 新ヒーローとアビリティの追加
5. 新タレントの追加
6. 効果を変更および追加
7. モデルとアニメーションを変更および追加

データを変更した場合、新たにクライアントをコードからビルドする必要はありません。`File -> Save`を押すだけで、`PW_Game`クライアントにすべての変更が即座に反映されます。例として、特定のタレントまたはヒーローアビリティの説明を変更してみてください。

## ゲームデータエディター
ゲームデータエディターは`pw/branches/r1117/Bin/PF_Editor.exe`にあります。

エディターを初めて開いたときは、`Data`へのパスを設定する必要があります。
1. `Tools -> File System Configuration`を開きます。
2. `Add -> WinFileSystem`を選択します。
3. `system root`としてDataフォルダを設定します: `pw/branches/r1117/Data`。
4. ウィンドウを閉じます。
5. エディターでは、`Views -> Object Browser`と`Views -> Properties Editor`を有効にします。これらがデータ編集の基本的なパネルです。

エディターのタブは移動および固定できます。

## チートコード付きのゲームクライアント
このリポジトリには、チートコード付きのコンパイルされたゲームクライアント`pw_publish/branch/Client/PvP/Bin/PW_Game.exe`が含まれています。

`Bin`フォルダの隣に`Localization`、`Profiles`、`Data`フォルダが必要です。そのため、準備中にそれらを`pw`フォルダに移動する必要があります。コードを変更した場合は、クライアントの再構築が必要です。

## PvPの起動方法
1. `Profiles -> game.cfg`で`local_game 0`を変更します。
2. `login_adress <サーバーアドレス>`を追加します。
3. ゲームを`-dev_login MyNickname`のパラメータで実行します。

## ボットとのゲームの起動方法
1. `Profiles -> private.cfg_example`ファイルを`private.cfg`に名前変更します。
2. メモ帳でファイルを開きます。
3. `AT BEGINNING GAME`を見つけます。
4. 新しい行に`add_ai bots`と挿入します - これにより、ゲームの各ヒーローにAIボットが割り当てられます。

## 潜在的なエラーのトラブルシューティング
1. `Profiles -> private.cfg_example`ファイルを`private.cfg`に名前変更します。
2. メモ帳でファイルを開きます。
3. `performance section`を見つけます。
4. `setvar gfx_fullscreen = 0`の行を見つけます - これにより、ゲームがウィンドウモードで起動し、より安定して動作する可能性があります。
5. `performance section`では他の最適化設定も変更可能です。

## 謝辞
ドキュメント作成とエラー修正に貢献した**Prime World: Nova**コミュニティに感謝します。
