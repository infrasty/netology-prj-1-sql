#!/usr/bin/python
# -*- coding: cp1251 -*-
import os
import psycopg2
import psycopg2.extensions
import pandas as pd

#os.environ['APP_POSTGRES_HOST']='0.0.0.0'
#os.environ['APP_POSTGRES_PORT']='5432'
os.environ['APP_PANDAS_DIR']='.'

params = {
    "host": os.environ['APP_POSTGRES_HOST'],
    "port": os.environ['APP_POSTGRES_PORT'],
    "user": 'postgres'
}
conn = psycopg2.connect(**params)

psycopg2.extensions.register_type(
    psycopg2.extensions.UNICODE,
    conn
)
conn.set_isolation_level(
    psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT
)
cursor = conn.cursor()

user_item_query_config = {
    "MIN_USERS_FOR_ITEM": 10,
    "MIN_ITEMS_FOR_USER": 3,
    "MAX_ITEMS_FOR_USER": 50,
    "MAX_ROW_NUMBER": 100000
}

req2_pd = """-- Запрос 2: Общее количество произведенных продуктов питания и кормов ( в 1000 тонн ) за все время
select sum(qty) as total_goods from ffhistory;"""

req3_pd = """-- Запрос 3: Общее количество перечня продуктов питания и кормов 
select count(distinct goods.name) as dict_num from goods;"""

req4_pd = """-- Запрос 4: Статистика по производству за сколько лет
select count(distinct ffhistory.year) as years_total from ffhistory;"""

req5_pd = """-- Запрос 5: Подсчитать количество произведенного молока за 2013 год
select sum(ff.qty) as Milk_2013
    from ffhistory ff
        join goods g on ff.gid=g.id
    where 
        g.name like 'Milk%' and
        ff.year=2013;"""

req7_pd = """-- Запрос 7: Вывести топ-5 производителей продуктов питания за все время
select c.name, sum(ff.qty) as total_food
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Food'
    group by ff.cid,c.name
    order by total_food desc limit 5;"""

cursor.execute(req2_pd)
df_req2 = pd.DataFrame(
    [i for i in cursor.fetchall()], columns=['total_goods'])

cursor.execute(req3_pd)
df_req3 = pd.DataFrame(
    [i for i in cursor.fetchall()], columns=['dict_num'])

cursor.execute(req4_pd)
df_req4 = pd.DataFrame(
    [i for i in cursor.fetchall()], columns=['years_total'])

cursor.execute(req5_pd)
df_req5 = pd.DataFrame(
    [i for i in cursor.fetchall()], columns=['milk_2013'])

cursor.execute(req7_pd)
df_req7 = pd.DataFrame(
    [i for i in cursor.fetchall()], columns=['name', 'total_food'])

df_req7.to_csv(os.environ['APP_PANDAS_DIR'] + '/' + 'req7pd.csv')