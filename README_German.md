[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World) ist ein Multiplayer-Online-Battle-Arena (MOBA) Spiel, das 2014 veröffentlicht wurde. Das Spiel wurde von der Firma [Nival](http://nival.com/) auf einer firmeneigenen Spiel-Engine entwickelt, hauptsächlich in C++ geschrieben.

Das Spiel besteht aus zwei Teilen: Schloss und Kampfteil. Der Spieler übernimmt die Rolle eines Lords oder einer Lady. Im Schloss baut der Spieler Gebäude, rekrutiert Helden und wählt Talente für sie aus. Im Kampfteil steuert der Spieler einen Helden und nutzt Talente, um in Teamkämpfen gegen andere Spieler anzutreten.

2024 wurde der Quellcode des Kampfteils des Spiels unter einer [Speziallizenz](LICENSE.md) veröffentlicht, die kommerzielle Nutzung untersagt, aber vollständig für die Gaming-Community, Studium und Forschungszwecke offen ist. Bitte lesen Sie die Bedingungen des [Lizenzvertrags](LICENSE.md) vor der Verwendung sorgfältig durch.

## Was in diesem Repository enthalten ist
- `pw` — der Hauptcode des Kampfbereichs
- `pw_publish` — kompilierter Client des Kampfbereichs mit Cheat-Codes und Client-Editor
- `pw/branches/r1117/Bin/PF_Editor.exe` — Spieldaten-Editor

## Vorbereitung
Sie müssen die Daten aus diesem Repository herunterladen und den Ordner `Bin` mit den Hauptspieldaten zusammenführen. So geht's:

1. Kopieren Sie den Ordner `pw_publish/branch/Client/PvP/Bin` nach `pw/branches/r1117` und ersetzen Sie vorhandene Dateien.
2. Starten Sie den Client mit Cheat-Codes `pw/branches/r1117/Bin/PW_Game.exe`.
3. Bei korrekter Durchführung sehen Sie das Ladefenster, jedoch ohne Bild und mit schwarzem Bildschirm.
4. Ändern Sie im Ordner `Profiles -> game.cfg` den Wert `local_game 0` zu `local_game 1`.
5. Starten Sie den Client mit Cheat-Codes. Nun sollten Sie die Lobby sehen, in der Sie eine Karte, einen Helden auswählen und eine Schlacht beginnen können.
6. Drücken Sie im Spiel die Tilde (~) auf der Tastatur, und Sie sehen die Konsole zur Eingabe von Cheat-Codes.

Falls Fehler auftreten, überprüfen Sie die Logdateien in `pw/branches/r1117/Bin/logs`.

## Spieldaten
Daten können über den Editor bearbeitet werden und befinden sich in `pw/branches/r1117/Data`.

Durch das Bearbeiten der Daten können Sie:
1. Beschreibungen von Heldenfähigkeiten und Talenten ändern.
2. Talente und Fähigkeiten der Helden modifizieren.
3. Die Logik von Kriechern und Türmen ändern.
4. Neue Helden und Fähigkeiten hinzufügen.
5. Neue Talente hinzufügen.
6. Effekte ändern und hinzufügen.
7. Modelle und Animationen ändern und hinzufügen.

Beim Ändern der Daten müssen Sie keinen neuen Client aus dem Code erstellen. Drücken Sie einfach `File -> Save`, und alle Änderungen erscheinen sofort im Spielclient `PW_Game`. Beispielsweise könnten Sie versuchen, die Beschreibung eines spezifischen Talents oder einer Heldenfähigkeit zu ändern.

## Spiel-Daten-Editor
Der Spiel-Daten-Editor befindet sich unter `pw/branches/r1117/Bin/PF_Editor.exe`.

Beim erstmaligen Öffnen des Editors müssen Sie den Pfad zu `Data` konfigurieren:
1. `Tools -> File System Configuration`.
2. `Add -> WinFileSystem`.
3. Stellen Sie den Ordner Data als Systemroot ein: `pw/branches/r1117/Data`.
4. Schließen Sie die Fenster.
5. Im Editor: `Views -> Object Browser` und `Views -> Properties Editor`. Dies sind die beiden Hauptbedienfelder zur Datenbearbeitung.

Editor-Registerkarten können verschoben und angedockt werden.

## Spielclient mit Cheat-Codes
Im Repository finden Sie den bereits kompilierten Spielclient mit Cheat-Codes `pw_publish/branch/Client/PvP/Bin/PW_Game.exe`.

Es ist notwendig, dass sich die Ordner `Localization`, `Profiles`, und `Data` neben dem `Bin`-Ordner befinden. Daher muss er während der Vorbereitung in den `pw`-Ordner verschoben werden. Wenn der Code geändert wird, ist ein Neukompilieren des Clients erforderlich.

## Wie man PvP startet
1. Ändern Sie in `Profiles -> game.cfg` `local_game 0`.
2. Fügen Sie `login_adress <Serveradresse>` hinzu.
3. Starten Sie das Spiel mit dem Parameter `-dev_login MeinSpitzname`.

## Wie man das Spiel mit Bots startet
1. Benennen Sie die Datei `Profiles -> private.cfg_example` in `private.cfg` um.
2. Öffnen Sie die Datei mit Notepad.
3. Finden Sie `AT BEGINNING GAME`.
4. Fügen Sie eine neue Zeile ein: `add_ai bots` — dies weist jedem Helden im Spiel einen KI-Bot zu.

## Fehlerbehebung
1. Benennen Sie die Datei `Profiles -> private.cfg_example` in `private.cfg` um.
2. Öffnen Sie die Datei mit Notepad.
3. Finden Sie den Abschnitt `performance section`.
4. Finden Sie die Zeile `setvar gfx_fullscreen = 0` — dies startet das Spiel im Fenstermodus, was stabiler arbeiten kann.
5. Andere Optimierungseinstellungen können ebenfalls im Abschnitt `performance section` geändert werden.

## Danksagungen
Ein Dank an die **Prime World: Nova**-Gemeinschaft für ihren Beitrag zur Dokumentation und Fehlerbehebung.
