[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World) is a multiplayer online battle arena (MOBA) game released in 2014. The game was developed on an in-house game engine by the company [Nival](http://nival.com/), primarily written in C++.

The game consists of two parts: Castle and Battle part. The player takes on the role of a Lord or Lady. In the Castle, the player constructs buildings, hires Heroes, and chooses Talents for them. In the Battle part, the player controls a Hero and uses Talents to fight against other players in team battles.

In 2024, the source code of the Battle part of the game was released under a [special license](LICENSE.md), prohibiting commercial use but fully open for the gaming community, study, and research purposes.
Please read the terms of the [license agreement](LICENSE.md) carefully before use.

## What's in this repository
- `pw` — the main code of the battle part
- `pw_publish` — compiled client of the battle part with cheat codes and a client editor
- `pw/branches/r1117/Bin/PF_Editor.exe` — game data editor

## Preparation
You need to download the data from this repository and merge the `Bin` folder with the main game data. Here's how to do it:

1. Copy the folder `pw_publish/branch/Client/PvP/Bin` to `pw/branches/r1117`, replacing existing files.
2. Run the client with cheat codes `pw/branches/r1117/Bin/PW_Game.exe`.
3. If done correctly, you will see the loading window, but without a picture and with a black screen.
4. In the folder `Profiles -> game.cfg`, change the value `local_game 0` to `local_game 1`.
5. Run the client with cheat codes. Now you should see the lobby where you can select a map, hero, and start a battle.
6. In the game, press the Tilde (~) key on the keyboard, and you will see the console for entering cheat codes.

If any errors occur, check the log files in `pw/branches/r1117/Bin/logs`.

## Game Data
Data can be edited via the editor and is located in `pw/branches/r1117/Data`

By editing the data, you can:
1. Change descriptions of hero talents and abilities.
2. Modify hero talents and abilities.
3. Change the logic of creeps and towers.
4. Add new heroes and abilities.
5. Add new talents.
6. Modify and add effects.
7. Change and add models and animations.

When altering data, there's no need to build a new client from the code. Just press `File -> Save`, and all changes will instantly appear in the `PW_Game` game client. As an example, you might try altering the description of a specific talent or hero ability.

## Game Data Editor
The game data editor is located at `pw/branches/r1117/Bin/PF_Editor.exe`

Upon first opening the editor, you need to configure the path to `Data`:
1. `Tools -> File System Configuration`.
2. `Add -> WinFileSystem`.
3. Set the Data folder as the system root: `pw/branches/r1117/Data`.
4. Close the windows.
5. In the editor: `Views -> Object Browser` and `Views -> Properties Editor`. These are the two main panels for editing data.

Editor tabs can be moved and docked.

## Game Client with Cheat Codes
In the repository, you can find the already compiled game client with cheat codes `pw_publish/branch/Client/PvP/Bin/PW_Game.exe`

It's necessary to have folders `Localization`, `Profiles`, and `Data` next to the `Bin` folder. Therefore, during preparation, it needs to be moved to the `pw` folder. If the code is changed, a client rebuild will be required.

## How to Launch PvP
1. In `Profiles -> game.cfg`, change `local_game 0`.
2. Add `login_adress <server address>`.
3. Run the game with the parameter `-dev_login MyNickname`.

## How to Launch the Game with Bots
1. Rename the file `Profiles -> private.cfg_example` to `private.cfg`.
2. Open the file with Notepad.
3. Find `AT BEGINNING GAME`.
4. Insert a new line: `add_ai bots` — this will assign AI bots for each hero in the game.

## Troubleshooting Potential Errors
1. Rename the file `Profiles -> private.cfg_example` to `private.cfg`.
2. Open the file with Notepad.
3. Find the `performance section`.
4. Find the line `setvar gfx_fullscreen = 0` — this will launch the game in windowed mode, which may work more stable.
5. Other optimization settings can also be changed in the `performance section`.

## Acknowledgements
To the **Prime World: Nova** community for their contribution to documentation and error fixing.
