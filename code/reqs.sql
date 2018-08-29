-- Запрос 1: Количество стран-производителей продуктов питания
select count(*) as countries from country;

-- Запрос 2: Общее количество произведенных продуктов питания и кормов ( в 1000 тонн ) за все время
select sum(qty) as total_goods from ffhistory;

-- Запрос 3: Общее количество перечня продуктов питания и кормов 
select count(distinct goods.name) as dict_num from goods;

-- Запрос 4: Статистика по производству за сколько лет
select count(distinct ffhistory.year) as years_total from ffhistory;

-- Запрос 5: Подсчитать количество произведенного молока за 2013 год
select sum(ff.qty) as Milk_2013
    from ffhistory ff
        join goods g on ff.gid=g.id
    where 
        g.name like 'Milk%' and
        ff.year=2013;

-- Запрос 6: Вывести топ-5 стран, не производящих корма
select c.name as country_no_feed
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where 
        f.name = 'Feed'
    group by ff.cid, c.name
        having sum(ff.qty) = 0
    limit 5;

-- Запрос 7: Вывести топ-5 производителей продуктов питания за все время
select c.name, sum(ff.qty) as total_food
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Food'
    group by ff.cid,c.name
    order by total_food desc limit 5;
    
-- Запрос 8: Вывести топ-15 производителей масла по годам
select c.name, sum(ff.qty) as total_food, ff.year 
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Food' and
        g.name like 'Butter%'
    group by ff.cid,c.name,ff.year
    order by total_food desc limit 15;

-- Запрос 9: Для стран экватора вывести топ-3 производителей банановых кормов
select c.name, sum(ff.qty) as total_food
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Feed' and
        g.name like 'Bananas%' and
        c.latitude between -25.0 and 25.0
    group by ff.cid,c.name
    order by total_food desc limit 3;

-- Запрос 10: Что больше всего производят в странах латинской америки
select g.name, sum(ff.qty) as total_food
    from 
	(select * from ffhistory join country on ffhistory.cid=country.id 
             where country.longitude between -150.0 and -45.0 and
                   country.latitude < 30.0 ) as ff
        join goods g on ff.gid=g.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Food'
    group by g.name
    order by total_food desc limit 5;

-- Представление на основе запроса 2
create or replace view total_goods as
select sum(qty) as total_goods from ffhistory;

-- Представление на основе запроса 7
create or replace view top_5_prod as
select c.name, sum(ff.qty) as total_food
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Food'
    group by ff.cid,c.name
    order by total_food desc limit 5;