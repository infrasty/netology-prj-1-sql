# Проектная работа по модулю "SQL и получение данных"
## Исходные данные
Данные в проектной работе взяты с Kaggle [world-foodfeed-production](https://www.kaggle.com/dorbicycle/world-foodfeed-production)

Описание данных представлены в разделе "[Данные](DB.md)"

## Каталоги и описание

* **code** - python- и sql- скрипты с заданием проектной работы
* **data** - CSV-файлы с исходными данными
* **docker** - контейнер для создания postgresql-базы и python-контейнера для работы с данными
* **jupyter** - ipython-реализация задания в части python-взаимодействия

## Команды для запуска

`docker\src\load_data.sh` - создание таблиц и загрузка данных из CSV

`code\reqs.sql` - выполнение SQL-скриптов задания в оболочке psql

`code\reqs.py` - выполнение Python-скриптов задания в docker-контейнере
