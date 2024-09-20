## Prime World
Исходный код боевой части игры Prime World.
Внимательно ознакомтесь с условиями лицензионного соглашения.

## Содержимое
- pw - основной код боевой части
- pw_publish - собранный клиент боевой части с читами и редактор для клиента

## Подготовка
Нужно выкачать ветку pw и объеденить Bin папку с основными данными игры.
1. Переключитесь на ветку `pw`
2. Скопируйте папку `Prime-World\pw_publish\branch\Client\PvP\Bin в PW-Battle\pw\branches\r1117` с заменой файлов
3. Запустите клиент с читами `Prime-World\pw\branches\r1117\Bin\PW_Game.exe`
4. Если все ок - на этом этапе откроется окно загрузки, но без картинки и с черным экраном
5. В папке Profiles -> game.cfg поменяйте значение `local_game 0` на `local_game 1`
6. Запустите клиент с читами. Теперь вы должны увидеть лобби, где можете выбрать картку, героя и уйти в бой
7. В бою нажимте тильду - откроется консоль для ввода читов

В случе возникновения ошибок - смотрите в логи `Prime-World\pw\branches\r1117\Bin\logs`.

## Данные игры
Данные редактируются через редактор.
Расположены в:
`Prime-World\pw\branches\r1117\Data`
Через данные можно:
1. Менять описания талантов и способностей героев
2. Менять таланты и способности героев
3. Менять логику крипов, башен
4. Добавлять героев и способности
5. Добавлять таланты
6. Менять и добавлять эффекты
7. Менять и добавлять модели и анимации

При изменении данных - новый клиент собирать из кода не надо. Нажмите File -> Save и все изменения сразу подтянутся в PW_Game клиент. Для примера, можете попробовать поменять описание какого-нибудь таланта или способности героя.

## Редактор
Находится в:
`Prime-World\pw\branches\r1117\Bin\PF_Editor.exe`

При первом открытии редактора, нужно настроить путь к `Data`:
1. Tools -> File System Configuration
2. Add -> WinFileSystem
3. В качестве system root устанавливаем папку Data `Prime-World\pw\branches\r1117\Data`
4. Закрываем окна
5. В редакторе Views -> Object Browser и Views -> Properties Editor. Это две основные панели для редактирования данных.

Вкладки редактора можно перемещеать и закреплять.

## Клиент с читами
В репозитории собран и лежит клиент с читами:
`PW-Battle\pw_publish\branch\Client\PvP\Bin\PW_Game.exe`
Ему нужно, чтобы рядом с Bin папкой лежали Localization, Profiles и Data. Поэтому при подготовке мы его переносим в папку `pw`. При изменении кода, клиент нужно собирать.
