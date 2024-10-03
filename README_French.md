[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World) est un jeu d'arène de bataille en ligne multijoueur (MOBA) sorti en 2014. Le jeu a été développé sur un moteur de jeu interne par la société [Nival](http://nival.com/), principalement écrit en C++.

Le jeu se compose de deux parties : le Château et la Bataille. Le joueur incarne un Seigneur ou une Dame. Dans le Château, le joueur construit des bâtiments, engage des Héros et choisit des Talents pour eux. Dans la partie Bataille, le joueur contrôle un Héros et utilise des Talents pour combattre d'autres joueurs lors de batailles en équipe.

En 2024, le code source de la partie Bataille du jeu a été publié sous une [licence spéciale](LICENSE.md), interdisant l'utilisation commerciale mais totalement ouverte à la communauté de joueurs, pour l'étude et la recherche. Veuillez lire attentivement les termes de l'[accord de licence](LICENSE.md) avant utilisation.

## Contenu de ce dépôt
- `pw` — le code principal de la partie bataille
- `pw_publish` — client compilé de la partie bataille avec des codes de triche et un éditeur client
- `pw/branches/r1117/Bin/PF_Editor.exe` — éditeur de données du jeu

## Préparation
Vous devez télécharger les données de ce dépôt et fusionner le dossier `Bin` avec les données principales du jeu. Voici comment procéder :

1. Copiez le dossier `pw_publish/branch/Client/PvP/Bin` dans `pw/branches/r1117`, en remplaçant les fichiers existants.
2. Lancez le client avec les codes de triche `pw/branches/r1117/Bin/PW_Game.exe`.
3. Si tout est correct, vous verrez la fenêtre de chargement, mais sans image et avec un écran noir.
4. Dans le dossier `Profiles -> game.cfg`, changez la valeur `local_game 0` en `local_game 1`.
5. Relancez le client avec les codes de triche. Vous devriez maintenant voir le lobby où vous pouvez sélectionner une carte, un héros et commencer une bataille.
6. Dans le jeu, appuyez sur la touche Tilde (~) du clavier pour faire apparaître la console pour entrer les codes de triche.

En cas d'erreurs, consultez les fichiers journaux dans `pw/branches/r1117/Bin/logs`.

## Données du jeu
Les données peuvent être modifiées via l'éditeur et se trouvent dans `pw/branches/r1117/Data`

En modifiant les données, vous pouvez :
1. Changer les descriptions des talents et capacités des héros.
2. Modifier les talents et capacités des héros.
3. Changer la logique des créatures et des tours.
4. Ajouter de nouveaux héros et capacités.
5. Ajouter de nouveaux talents.
6. Modifier et ajouter des effets.
7. Modifier et ajouter des modèles et des animations.

Lorsque vous modifiez les données, il n'est pas nécessaire de reconstruire un nouveau client à partir du code. Appuyez sur `File -> Save`, et tous les changements apparaîtront immédiatement dans le client du jeu `PW_Game`. Par exemple, vous pouvez essayer de modifier la description d'un talent ou d'une capacité spécifique d'un héros.

## Éditeur de données du jeu
L'éditeur de données du jeu se trouve à `pw/branches/r1117/Bin/PF_Editor.exe`

Lors de la première ouverture de l'éditeur, vous devez configurer le chemin vers `Data` :
1. `Tools -> File System Configuration`.
2. `Add -> WinFileSystem`.
3. Définissez le dossier Data en tant que racine du système : `pw/branches/r1117/Data`.
4. Fermez les fenêtres.
5. Dans l'éditeur : `Views -> Object Browser` et `Views -> Properties Editor`. Ce sont les deux principaux panneaux pour l'édition des données.

Les onglets de l'éditeur peuvent être déplacés et ancrés.

## Client du jeu avec codes de triche
Dans le dépôt, vous pouvez trouver le client de jeu déjà compilé avec les codes de triche `pw_publish/branch/Client/PvP/Bin/PW_Game.exe`

Il est nécessaire d'avoir les dossiers `Localization`, `Profiles`, et `Data` à côté du dossier `Bin`. Ainsi, lors de la préparation, il doit être déplacé dans le dossier `pw`. Si le code est modifié, une reconstruction du client sera nécessaire.

## Comment lancer le PvP
1. Dans `Profiles -> game.cfg`, changez `local_game 0`.
2. Ajoutez `login_adress <adresse serveur>`.
3. Lancez le jeu avec le paramètre `-dev_login MonPseudo`.

## Comment lancer le jeu avec des bots
1. Renommez le fichier `Profiles -> private.cfg_example` en `private.cfg`.
2. Ouvrez le fichier avec le Bloc-notes.
3. Trouvez `AT BEGINNING GAME`.
4. Insérez une nouvelle ligne : `add_ai bots` — cela attribuera des bots IA à chaque héros du jeu.

## Résolution d'erreurs potentielles
1. Renommez le fichier `Profiles -> private.cfg_example` en `private.cfg`.
2. Ouvrez le fichier avec le Bloc-notes.
3. Trouvez la section `performance section`.
4. Trouvez la ligne `setvar gfx_fullscreen = 0` — cela lancera le jeu en mode fenêtré, qui peut fonctionner plus stablement.
5. Les autres paramètres d'optimisation peuvent également être modifiés dans la `performance section`.

## Remerciements
À la communauté **Prime World: Nova** pour leur contribution à la documentation et à la correction d'erreurs.
