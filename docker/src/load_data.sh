#/bin/sh

echo "Очистка старых данных..."
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "DROP TABLE IF EXISTS ffhistory"
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "DROP TABLE IF EXISTS country"
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "DROP TABLE IF EXISTS goods"
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "DROP TABLE IF EXISTS foodfeed"

echo "Загружаем country.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
CREATE TABLE country (
	id integer PRIMARY KEY,
	code char(3) NOT NULL,
	name varchar(96) NOT NULL,
	latitude float,
	longitude float
);'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy country(id,name,code,latitude,longitude) FROM '/data/country.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем goods.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
CREATE TABLE goods (
	id integer PRIMARY KEY,
	name varchar(96) NOT NULL
);'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy goods FROM '/data/goods.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем foodfeed.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
CREATE TABLE foodfeed (
	id integer PRIMARY KEY,
	name char(4) NOT NULL
);'
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy foodfeed FROM '/data/foodfeed.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем food history..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
CREATE TABLE ffhistory (
	cid integer references country(id),
	gid integer references goods(id),
	ffid integer references foodfeed(id),
	year integer NOT NULL,
	qty integer DEFAULT 0
);'

echo "Загружаем 2011..."
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy ffhistory FROM '/data/ff2011.csv' DELIMITER ';' CSV HEADER"
echo "Загружаем 2012..."
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy ffhistory FROM '/data/ff2012.csv' DELIMITER ';' CSV HEADER"
echo "Загружаем 2013..."
psql --host $APP_POSTGRES_HOST -U postgres -c \
    "\\copy ffhistory FROM '/data/ff2013.csv' DELIMITER ';' CSV HEADER"