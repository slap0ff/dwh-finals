Проектная работа по модулю
		“DWH”

Используется локальное развертывание базы bookings

Используемые таблицы:
 - Fact_Flights - содержит совершенные перелеты. Если в рамках билета был сложный маршрут с пересадками - каждый сегмент учитываем независимо
		-Пассажир
		-Дата и время вылета (факт)
		-Дата и время прилета (факт)
		-Задержка вылета (разница между фактической и запланированной датой в секундах)
		-Задержка прилета (разница между фактической и запланированной датой в секундах)
		-Самолет
		-Аэропорт вылета
		-Аэропорт прилета
		-Класс обслуживания
		-Стоимость
 - Dim_Calendar - справочник дат
 - Dim_Passengers - справочник пассажиров
 - Dim_Aircrafts - справочник самолетов
 - Dim_Airports - справочник аэропортов
 - Dim_Tariff - справочник тарифов (Эконом/бизнес и тд)

Состав работы:
 - SQL-скрипт создания необходимых табллиц и справочников
 - Трансформации реализованные на базе Pentaho
 
Описание ETL-процедуры:
 - Dim_Aircraft.ktr - заполнение справочника Dim_Aircraft. Проверки: дубликаты, на null  (model, aircraft_code, range), regexp-проверка поля range([1-9]{1}\d*). Ошибочные записи отправляются в таблицу rejected_Dim_Aircraft.
 - Dim_Airports.ktr - заполнение справочника Dim_Airports. Проверки: дубликаты, на null, проверка допуска в полях координат (-180<=x<=180). Ошибочные записи отправляются в таблицу rejected_Dim_Airports.
 - Dim_Passengers.ktr - заполнение справочника Dim_Passengers. Проверки: дубликаты, на null, regexp-проверка поля passenger_name([a-zA-Z]* [a-zA-Z]*). Ошибочные записи отправляются в таблицу rejected_Dim_Passengers.
 - Dim_Tariff.ktr - заполнение справочника Dim_Tariff. Проверки: на null. Ошибочные записи отправляются в таблицу rejected_Dim_Tariff.
 - Fact_Flights.ktr - заполнение справочника Fact_Flights. Проверки: дубликаты, на null, проверка на "дату из будущего" путём сравнения actual_departure и now(), проверка на невалидные данные дат вылета и прилёта (actual_arrival>actual_departure). Ошибочные записи отправляются в таблицу rejected_Fact_Flights.