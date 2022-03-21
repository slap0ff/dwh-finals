CREATE SCHEMA finals_dwh;


--таблица дат под конкретный случай ограничена 2016 годом +- год
CREATE TABLE finals_dwh.Dim_Calendar 
AS
WITH dates AS (
    SELECT dd::date AS dt
    FROM generate_series
            ('2010-01-01'::timestamp
            , '2030-01-01'::timestamp
            , '1 day'::interval) dd
)
SELECT
    to_char(dt, 'YYYYMMDD')::int AS id,
    dt AS date,
    to_char(dt, 'YYYY-MM-DD') AS ansi_date,
    date_part('isodow', dt)::int AS day,
    date_part('week', dt)::int AS week_number,
    date_part('month', dt)::int AS month,
    date_part('isoyear', dt)::int AS year,
    (date_part('isodow', dt)::smallint BETWEEN 1 AND 5)::int AS week_day,
    (to_char(dt, 'YYYYMMDD')::int IN (
        20150101, 20150102, 20150103, 20150104, 20150105, 20150106,
        20150107, 20150108, 20150109, 20150223, 20150308, 20150309,
        20150501, 20150504, 20150509, 20150511, 20150612, 20151104,
        20160101, 20160102, 20160103, 20160104, 20160105, 20160106,
        20160107, 20160108, 20160222, 20160223, 20160307, 20160308,
        20160501, 20160502, 20160503, 20160509, 20160612, 20160613,
        20161104, 20170101, 20170102, 20170103, 20170104, 20170105,
        20170106, 20170107, 20170108, 20170223, 20170224, 20170308,
        20170501, 20170508, 20170509, 20170612, 20171104, 20171106
     ))::int AS holiday
FROM dates
ORDER BY dt;
ALTER TABLE finals_dwh.dim_calendar ADD PRIMARY KEY (id);


--таблица ВС
CREATE TABLE finals_dwh.Dim_Aircrafts(
	id serial NOT NULL,		
	aircraft_code varchar(3) PRIMARY KEY,	
	model varchar(100),	
	"range" smallint
);
--таблица аэропортов
CREATE TABLE finals_dwh.Dim_Airports(
	id serial NOT NULL,
	airport_code varchar(3) PRIMARY KEY,
	airport_name varchar(100),	
	city varchar(100),	
	longitude float8,
	latitude float8,
	timezone text
);
--таблица пассажиров
CREATE TABLE finals_dwh.Dim_Passengers(
	id serial NOT NULL,
	passenger_id varchar(20) PRIMARY KEY,	
	passenger_name text,	
	contact_data varchar(100)
);
--таблица тарифов
CREATE TABLE finals_dwh.Dim_Tariff(
	id serial NOT NULL,
	fare_conditions varchar(20) PRIMARY KEY
);
--таблица совершенных полетов
CREATE TABLE finals_dwh.Fact_Flights (
	id serial PRIMARY KEY,
	passenger_id varchar(100) REFERENCES finals_dwh.Dim_Passengers(passenger_id),
	actual_departure timestamp,
	actual_arrival timestamp,
	delayed_departure bigint,
	delayed_arrival bigint,
	aircraft_type varchar(5) REFERENCES finals_dwh.Dim_Aircrafts(aircraft_code),
	airport_departure varchar(5) REFERENCES finals_dwh.Dim_Airports(airport_code),
	airport_arrival varchar(5) REFERENCES finals_dwh.Dim_Airports(airport_code),
	fare_conditions varchar(20) REFERENCES finals_dwh.Dim_Tariff(fare_conditions),
	total_amount int
);



--таблицы для слива ошибочных записей
CREATE TABLE finals_dwh.rejected_Dim_Aircrafts(
	id serial NOT NULL,		
	aircraft_code varchar(3) PRIMARY KEY,	
	model varchar(100),	
	"range" smallint
);
CREATE TABLE finals_dwh.rejected_Dim_Passengers(
	id serial,
	passenger_id varchar(20) PRIMARY KEY,	
	passenger_name text,	
	contact_data varchar(100)
);
CREATE TABLE finals_dwh.rejected_Dim_Airports(
	id serial NOT NULL,
	airport_code varchar(3) PRIMARY KEY,
	airport_name varchar(100),	
	city varchar(100),	
	longitude float8,
	latitude float8,
	timezone text
);
CREATE TABLE finals_dwh.rejected_Dim_Tariff(
	id serial NOT NULL,
	fare_conditions varchar(20) PRIMARY KEY
);
CREATE TABLE finals_dwh.rejected_Fact_Flights (
	id serial PRIMARY KEY,
	passenger_id varchar(20),
	actual_departure timestamp,
	actual_arrival timestamp,
	delayed_departure bigint,
	delayed_arrival bigint,
	aircraft_type varchar(5) ,
	airport_departure varchar(5),
	airport_arrival varchar(5),
	fare_conditions varchar(20),
	total_amount int
);
