[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
《Prime World》是一款多人在线战术竞技场（MOBA）游戏，于2014年发布。该游戏由[Nival](http://nival.com/)公司开发，主要使用C++编写的自主引擎。

游戏分为两个部分：城堡和战斗部分。玩家扮演领主或女士的角色。在城堡中，玩家需要建造建筑、雇佣英雄并为他们选择天赋。在战斗部分，玩家控制英雄并利用天赋与其他玩家进行团队对战。

在2024年，游戏的战斗部分源代码在一项[特殊许可证](LICENSE.md)下发布，该许可证禁止商业用途，但完全对游戏社区的学习和研究目的开放使用。在使用前请仔细阅读[许可协议](LICENSE.md)的条款。

## 此存储库中的内容
- `pw` — 战斗部分的主要代码
- `pw_publish` — 带有作弊码和客户端编辑器的已编译战斗部分客户端
- `pw/branches/r1117/Bin/PF_Editor.exe` — 游戏数据编辑器

## 准备工作
您需要下载此存储库中的数据，并将`Bin`文件夹与游戏主数据合并。操作如下：

1. 将文件夹`pw_publish/branch/Client/PvP/Bin`拷贝到`pw/branches/r1117`中，替换现有文件。
2. 使用作弊码运行客户端`pw/branches/r1117/Bin/PW_Game.exe`。
3. 如果正确，您将看到加载窗口，但没有图片并且是黑屏。
4. 在文件夹`Profiles -> game.cfg`中，将`local_game 0`更改为`local_game 1`。
5. 再次使用作弊码运行客户端。现在您应该可以看到选择地图、英雄并开始战斗的大厅。
6. 在游戏中按下键盘上的波浪号键（~），您将看到输入作弊码的控制台。

如果出现任何错误，请检查`pw/branches/r1117/Bin/logs`中的日志文件。

## 游戏数据
数据可以通过编辑器编辑，位于`pw/branches/r1117/Data`中

通过编辑数据，您可以：
1. 更改英雄天赋和能力的描述。
2. 修改英雄的天赋和能力。
3. 更改小兵和塔的逻辑。
4. 添加新英雄和能力。
5. 添加新天赋。
6. 修改和添加效果。
7. 变更和添加模型和动画。

无需从代码重新构建客户端，只需按下`File -> Save`，所有更改将立即在`PW_Game`游戏客户端中显示。您可以尝试更改特定天赋或英雄能力的描述。

## 游戏数据编辑器
游戏数据编辑器位于`pw/branches/r1117/Bin/PF_Editor.exe`

首次打开编辑器时，需要配置`Data`路径：
1. 选择`Tools -> File System Configuration`。
2. 选择`Add -> WinFileSystem`。
3. 将Data文件夹设置为system root：`pw/branches/r1117/Data`。
4. 关闭窗口。
5. 在编辑器中：选择`Views -> Object Browser`和`Views -> Properties Editor`。这是编辑数据的两个主要面板。

编辑器选项卡可以移动和停靠。

## 带有作弊码的游戏客户端
在此存储库中，您可以找到已编译的带有作弊码的游戏客户端`pw_publish/branch/Client/PvP/Bin/PW_Game.exe`

`Bin`文件夹旁边必须有`Localization`、`Profiles`和`Data`文件夹。因此，在准备期间，需要将其移动到`pw`文件夹中。如果更改代码，则需要重建客户端。

## 如何启动PvP
1. 在`Profiles -> game.cfg`中更改`local_game 0`。
2. 添加`login_adress <服务器地址>`。
3. 使用参数`-dev_login MyNickname`运行游戏。

## 如何启动带有机器人的游戏
1. 将文件`Profiles -> private.cfg_example`重命名为`private.cfg`。
2. 使用记事本打开文件。
3. 找到`AT BEGINNING GAME`。
4. 插入新行：`add_ai bots` — 这将为游戏中的每个英雄分配AI机器人。

## 潜在错误排除
1. 将文件`Profiles -> private.cfg_example`重命名为`private.cfg`。
2. 使用记事本打开文件。
3. 找到`performance section`。
4. 找到行`setvar gfx_fullscreen = 0` — 这将以窗口模式启动游戏，可能会更稳定。
5. 在`performance section`中还能更改其他优化设置。

## 致谢
感谢**Prime World: Nova**社区对文档编写和错误修正的贡献。
