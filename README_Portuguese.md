[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World) é um jogo multiplayer online de arena de batalha (MOBA) lançado em 2014. O jogo foi desenvolvido em um motor de jogo proprietário pela empresa [Nival](http://nival.com/), escrito principalmente em C++.

O jogo consiste em duas partes: Castelo e Parte de Batalha. O jogador assume o papel de um Lorde ou Dama. No Castelo, o jogador constrói edifícios, contrata Heróis e escolhe Talentos para eles. Na parte de Batalha, o jogador controla um Herói e usa Talentos para lutar contra outros jogadores em batalhas de equipe.

Em 2024, o código fonte da parte de Batalha do jogo foi liberado sob uma [licença especial](LICENSE.md), proibindo o uso comercial, mas totalmente acessível para a comunidade de jogos, estudo e fins de pesquisa.
Leia atentamente os termos do [acordo de licença](LICENSE.md) antes de usar.

## O que há neste repositório
- `pw` — o código principal da parte de batalha
- `pw_publish` — cliente compilado da parte de batalha com códigos de trapaça e editor de cliente
- `pw/branches/r1117/Bin/PF_Editor.exe` — editor de dados do jogo

## Preparação
Você precisa baixar os dados deste repositório e mesclar a pasta `Bin` com os dados principais do jogo. Veja como fazer isso:

1. Copie a pasta `pw_publish/branch/Client/PvP/Bin` para `pw/branches/r1117`, substituindo arquivos existentes.
2. Execute o cliente com códigos de trapaça `pw/branches/r1117/Bin/PW_Game.exe`.
3. Se tudo estiver correto, você verá a janela de carregamento, mas sem imagem e com uma tela preta.
4. Na pasta `Profiles -> game.cfg`, altere o valor `local_game 0` para `local_game 1`.
5. Execute o cliente com códigos de trapaça. Agora você deve ver o lobby onde pode selecionar um mapa, herói e iniciar uma batalha.
6. No jogo, pressione a tecla Tilde (~) no teclado e você verá o console para inserir códigos de trapaça.

Se ocorrer algum erro, verifique os arquivos de log em `pw/branches/r1117/Bin/logs`.

## Dados do Jogo
Os dados podem ser editados através do editor localizado em `pw/branches/r1117/Data`.

Ao editar os dados, você pode:
1. Alterar descrições de talentos e habilidades de heróis.
2. Modificar talentos e habilidades de heróis.
3. Alterar a lógica de tropas e torres.
4. Adicionar novos heróis e habilidades.
5. Adicionar novos talentos.
6. Modificar e adicionar efeitos.
7. Alterar e adicionar modelos e animações.

Quando alterar dados, não há necessidade de construir um novo cliente a partir do código. Apenas pressione `File -> Save`, e todas as alterações aparecerão instantaneamente no cliente de jogo `PW_Game`. Como exemplo, você pode tentar alterar a descrição de um talento ou habilidade específica de um herói.

## Editor de Dados do Jogo
O editor de dados do jogo está localizado em `pw/branches/r1117/Bin/PF_Editor.exe`.

Ao abrir o editor pela primeira vez, você precisa configurar o caminho para `Data`:
1. `Tools -> File System Configuration`.
2. `Add -> WinFileSystem`.
3. Defina a pasta Data como raiz do sistema: `pw/branches/r1117/Data`.
4. Feche as janelas.
5. No editor: `Views -> Object Browser` e `Views -> Properties Editor`. Estes são os dois painéis principais para edição de dados.

As abas do editor podem ser movidas e encaixadas.

## Cliente do Jogo com Códigos de Trapaça
No repositório, você pode encontrar o cliente de jogo já compilado com códigos de trapaça `pw_publish/branch/Client/PvP/Bin/PW_Game.exe`.

É necessário ter as pastas `Localization`, `Profiles` e `Data` próximas à pasta `Bin`. Portanto, durante a preparação, é preciso movê-lo para a pasta `pw`. Se o código for alterado, uma reconstrução do cliente será necessária.

## Como Lançar PvP
1. Em `Profiles -> game.cfg`, altere `local_game 0`.
2. Adicione `login_adress <endereço do servidor>`.
3. Execute o jogo com o parâmetro `-dev_login MeuApelido`.

## Como Lançar o Jogo com Bots
1. Renomeie o arquivo `Profiles -> private.cfg_example` para `private.cfg`.
2. Abra o arquivo com o Bloco de Notas.
3. Encontre `AT BEGINNING GAME`.
4. Insira uma nova linha: `add_ai bots` — isso atribuirá bots de IA para cada herói no jogo.

## Solução de Possíveis Erros
1. Renomeie o arquivo `Profiles -> private.cfg_example` para `private.cfg`.
2. Abra o arquivo com o Bloco de Notas.
3. Encontre a seção `performance section`.
4. Encontre a linha `setvar gfx_fullscreen = 0` — isso executará o jogo em modo janela, o que pode funcionar de maneira mais estável.
5. Outras configurações de otimização também podem ser alteradas na `performance section`.

## Agradecimentos
À comunidade **Prime World: Nova** por sua contribuição na documentação e na correção de erros.
