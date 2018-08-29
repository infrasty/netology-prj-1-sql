## Описание данных ##
 
![Схема данных](DBSchema.png)
 
### Описание таблиц и полей ###

Таблица **country** - справочник с названиями стран, аббревиатурами и географическим расположением столиц ( latitude / longitude )  
`id integer PRIMARY KEY,     - Уникальный код страны`<br/>  	
`code char(3) NOT NULL,      - Трехбуквенная аббревиатура названия страны`<br/>
`name varchar(96) NOT NULL,  - Полное название страны`<br/>
`latitude float,             - Долгота`<br/>
`longitude float             - Широта`<br/>


Таблица **goods** - справочник с перечнем производимой продуктовой продукции  
`id integer PRIMARY KEY,    - Уникальный код наименования`<br/>
`name varchar(96) NOT NULL  - Описание наименования`<br/>


Таблица **foodfeed** - справочник с перечнем типа продукции по потреблению (корма\потребление)  
`id integer PRIMARY KEY,    - Уникальный код наименования`<br/>
`name char(4) NOT NULL      - Описание типа продукции`<br/>


Таблица **ffhistory** - данные по производству различной продукции по странам и годам  
`cid integer references country(id),    - Код страны производителя`<br/>
`gid integer references goods(id),      - Код наименования товара производителя`<br/>
`ffid integer references foodfeed(id),  - Код типа товара по потреблению производителя`<br/>
`year integer NOT NULL,                 - Год производтства`<br/>
`qty integer DEFAULT 0                  - Количество произведеннего в 1000 тонн`<br/>
