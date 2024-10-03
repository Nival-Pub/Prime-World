[English](README_English.md)        [Русский](README.md)        [中文](README_Chinese.md)        [हिन्दी](README_Hindi.md)        [Español](README_Spanish.md)        [Français](README_French.md)        [Deutsch](README_German.md)        [Português](README_Portuguese.md)        [日本語](README_Japanese.md)        [Bahasa Indonesia](README_Indonesian.md)

[![Prime World Trailer](PW_trailer.png)](https://youtu.be/Fkd-zva4npI)
[Prime World](https://wikipedia.org/wiki/Prime_World) es un juego de arena de batalla en línea multijugador (MOBA) lanzado en 2014. El juego fue desarrollado sobre un motor propio por la compañía [Nival](http://nival.com/), escrito principalmente en C++.

El juego consta de dos partes: Castillo y Parte de Batalla. El jugador asume el papel de un Lord o una Dama. En el Castillo, el jugador construye edificios, contrata Héroes y elige Talentos para ellos. En la Parte de Batalla, el jugador controla a un Héroe y utiliza los Talentos para luchar contra otros jugadores en combates en equipo.

En 2024, el código fuente de la Parte de Batalla del juego se lanzó bajo una [licencia especial](LICENSE.md), que prohíbe el uso comercial pero está completamente abierta para la comunidad de jugadores, el estudio y la investigación.
Lea atentamente los términos del [acuerdo de licencia](LICENSE.md) antes de su uso.

## ¿Qué hay en este repositorio?
- `pw` — el código principal de la parte de batalla
- `pw_publish` — cliente compilado de la parte de batalla con códigos de trucos y un editor de cliente
- `pw/branches/r1117/Bin/PF_Editor.exe` — editor de datos del juego

## Preparación
Debe descargar los datos de este repositorio y fusionar la carpeta `Bin` con los datos principales del juego. Aquí se indica cómo hacerlo:

1. Copie la carpeta `pw_publish/branch/Client/PvP/Bin` en `pw/branches/r1117`, reemplazando los archivos existentes.
2. Ejecute el cliente con códigos de trucos `pw/branches/r1117/Bin/PW_Game.exe`.
3. Si todo está correcto, verá la ventana de carga, pero sin imagen y con una pantalla negra.
4. En la carpeta `Profiles -> game.cfg`, cambie el valor `local_game 0` a `local_game 1`.
5. Ejecute el cliente con códigos de trucos. Ahora debería ver el lobby donde puede seleccionar un mapa, un héroe y comenzar una batalla.
6. En el juego, presione la tecla Tilde (~) en el teclado, y verá la consola para ingresar códigos de trucos.

Si ocurren errores, verifique los archivos de registro en `pw/branches/r1117/Bin/logs`.

## Datos del juego
Los datos se pueden editar a través del editor y se encuentran en `pw/branches/r1117/Data`

Al editar los datos, puede:
1. Cambiar descripciones de talentos y habilidades de los héroes.
2. Modificar talentos y habilidades de los héroes.
3. Cambiar la lógica de los creeps y las torres.
4. Agregar nuevos héroes y habilidades.
5. Agregar nuevos talentos.
6. Modificar y agregar efectos.
7. Cambiar y agregar modelos y animaciones.

Al alterar los datos, no es necesario compilar un nuevo cliente a partir del código. Simplemente presione `Archivo -> Guardar`, y todos los cambios aparecerán instantáneamente en el cliente de juego `PW_Game`. Como ejemplo, podría intentar cambiar la descripción de un determinado talento o habilidad de héroe.

## Editor de Datos del Juego
El editor de datos del juego se encuentra en `pw/branches/r1117/Bin/PF_Editor.exe`

Al abrir el editor por primera vez, debe configurar la ruta a `Data`:
1. `Herramientas -> Configuración del Sistema de Archivos`.
2. `Agregar -> WinFileSystem`.
3. Establezca la carpeta Data como la raíz del sistema: `pw/branches/r1117/Data`.
4. Cierre las ventanas.
5. En el editor: `Vistas -> Navegador de Objetos` y `Vistas -> Editor de Propiedades`. Estos son los dos paneles principales para editar datos.

Las pestañas del editor pueden moverse y acoplarse.

## Cliente de Juego con Códigos de Trucos
En el repositorio, puede encontrar el cliente de juego ya compilado con códigos de trucos `pw_publish/branch/Client/PvP/Bin/PW_Game.exe`

Es necesario que las carpetas `Localization`, `Profiles` y `Data` estén junto a la carpeta `Bin`. Por lo tanto, durante la preparación, debe moverse a la carpeta `pw`. Si el código se modifica, se requerirá reconstruir el cliente.

## Cómo Lanzar PvP
1. En `Profiles -> game.cfg`, cambie `local_game 0`.
2. Agregue `login_adress <dirección del servidor>`.
3. Ejecute el juego con el parámetro `-dev_login MiApodo`.

## Cómo Lanzar el Juego con Bots
1. Renombre el archivo `Profiles -> private.cfg_example` a `private.cfg`.
2. Abra el archivo con el Bloc de notas.
3. Encuentre `AL COMIENZO DEL JUEGO`.
4. Inserte una nueva línea: `add_ai bots` — esto asignará un bot IA para cada héroe en el juego.

## Solución de Problemas Potenciales
1. Renombre el archivo `Profiles -> private.cfg_example` a `private.cfg`.
2. Abra el archivo con el Bloc de notas.
3. Encuentre la sección `sección de rendimiento`.
4. Encuentre la línea `setvar gfx_fullscreen = 0` — esto lanzará el juego en modo ventana, lo cual puede hacerlo más estable.
5. Otras configuraciones de optimización también pueden cambiarse en la `sección de rendimiento`.

## Agradecimientos
A la comunidad de **Prime World: Nova** por su contribución a la documentación y corrección de errores.
