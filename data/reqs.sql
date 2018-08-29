-- ������ 1: ���������� �����-�������������� ��������� �������
select count(*) as countries from country;

-- ������ 2: ����� ���������� ������������� ��������� ������� � ������ ( � 1000 ���� ) �� ��� �����
select sum(qty) as total_goods from ffhistory;

-- ������ 3: ����� ���������� ������� ��������� ������� � ������ 
select count(distinct goods.name) as dict_num from goods;

-- ������ 4: ���������� �� ������������ �� ������� ���
select count(distinct ffhistory.year) as years_total from ffhistory;

-- ������ 5: ���������� ���������� �������������� ������ �� 2013 ���
select sum(ff.qty) as Milk_2013
    from ffhistory ff
        join goods g on ff.gid=g.id
    where 
        g.name like 'Milk%' and
        ff.year=2013;

-- ������ 6: ������� ���-5 �����, �� ������������ �����
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

-- ������ 7: ������� ���-5 �������������� ��������� ������� �� ��� �����
select c.name, sum(ff.qty) as total_food
    from ffhistory ff
        join goods g on ff.gid=g.id
        join country c on ff.cid=c.id
        join foodfeed f on ff.ffid=f.id
    where
        f.name = 'Food'
    group by ff.cid,c.name
    order by total_food desc limit 5;
    
-- ������ 8: ������� ���-15 �������������� ����� �� �����
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

-- ������ 9: ��� ����� �������� ������� ���-3 �������������� ��������� ������
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

-- ������ 10: ��� ������ ����� ���������� � ������� ��������� �������
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

-- ������������� �� ������ ������� 2
create or replace view total_goods as
select sum(qty) as total_goods from ffhistory;

-- ������������� �� ������ ������� 7
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