-- Найти модели самолётов, в английском названии которых встречается строка "A35".
SELECT model ->> 'en' 
FROM airplanes_data ad
WHERE model ->> 'en' LIKE '%A35%';


-- Вывести код и английское название аэропортов, название которых состоит ровно из 3 символов.
SELECT ad.airport_code, airport_name ->> 'en' 
FROM airports_data ad 
WHERE airport_name ->> 'en' LIKE '___';


-- Вывести самолёты, название модели которых не начинается с "Aerobus" и не начинается с "Boeing".
SELECT * 
FROM airplanes_data ad 
WHERE model ->> 'en' NOT LIKE 'Aerobus%' 
  AND model ->> 'en' NOT LIKE 'Boeing%';


-- Вывести самолёты, название модели которых начинается с "A" или "Boe".
SELECT * 
FROM airplanes_data ad 
WHERE model ->> 'en' ~ '^(A|Boe)';


-- Вывести самолёты, в названии модели которых отсутствует последовательность символов "300".
SELECT * 
FROM airplanes_data ad 
WHERE model ->> 'en' !~ '300';


-- Вывести самолёты с дальностью полёта от 3000 до 6000 включительно.
SELECT * 
FROM airplanes_data ad 
WHERE range BETWEEN 3000 AND 6000;


-- Вывести модель самолёта, дальность в километрах и приблизительную дальность в милях.
SELECT model ->> 'en', range, range / 1.609 AS miles
FROM airplanes_data ad;


-- Вывести модель, дальность в километрах и дальность в милях, округлённую до 2 знаков.
SELECT model ->> 'en', range, round(range / 1.609, 2) AS miles
FROM airplanes_data ad;


-- Вывести модели самолётов и их дальность, отсортировав от самой большой дальности к самой маленькой.
SELECT model ->> 'en', range
FROM airplanes_data ad 
ORDER BY range DESC;


-- Получить список уникальных часовых поясов аэропортов в отсортированном порядке.
SELECT DISTINCT timezone 
FROM airports_data 
ORDER BY 1;


-- Вывести 3 аэропорта с наибольшей долготой.
SELECT
    airport_code,
    airport_name ->> 'ru' AS airport_name,
    city ->> 'en' AS city,
    coordinates,
    coordinates[0] AS longitude
FROM airports_data
ORDER BY coordinates[0] DESC
LIMIT 3;


-- Пропустить первые 3 аэропорта по убыванию долготы и вывести следующие 3.
SELECT
    airport_code,
    airport_name ->> 'ru' AS airport_name,
    city ->> 'en' AS city,
    coordinates,
    coordinates[0] AS longitude
FROM airports_data
ORDER BY coordinates[0] DESC
LIMIT 3
OFFSET 3;


-- Выполнить запрос и показать фактический план выполнения:
-- для каждого самолёта определить тип по дальности и отсортировать модели по названию.
EXPLAIN ANALYZE
SELECT model ->> 'en', range,
    CASE 
        WHEN range < 5000 THEN 'Среднемагистральный'
        ELSE 'Дальнемагистральный'
    END AS type
FROM airplanes_data
ORDER BY model ->> 'en';


-- Вывести маршруты вместе с моделью, дальностью и скоростью самолёта,
-- который используется на каждом маршруте.
SELECT
    r.route_no,
    r.airplane_code,
    a.model ->> 'en' AS model,
    a.range,
    a.speed
FROM routes AS r
JOIN airplanes_data AS a
    ON r.airplane_code = a.airplane_code;


-- Вывести места и классы обслуживания для самолётов,
-- название модели которых начинается с "Aerobus".
SELECT
    a.airplane_code,
    a.model ->> 'en',
    s.seat_no,
    s.fare_conditions
FROM seats s 
JOIN airplanes_data a  
    ON s.airplane_code = a.airplane_code 
WHERE a.model ->> 'en' ~ '^Aerobus'
ORDER BY s.seat_no;


-- Разрешить планировщику PostgreSQL использовать алгоритм Hash Join.
SET enable_hashjoin = on;

-- Разрешить планировщику PostgreSQL использовать алгоритм Nested Loop Join.
SET enable_nestloop = on;


-- Посчитать количество всех пар аэропортов, находящихся в разных городах.
SELECT count(*)
FROM airports_data a1, airports_data a2
WHERE a1.city <> a2.city;


-- Выполнить декартово произведение аэропортов и посчитать пары аэропортов,
-- которые находятся в разных городах.
SELECT count(*)
FROM airports a1 
CROSS JOIN airports a2
WHERE a1.city <> a2.city;


-- Посчитать пассажирские сегменты на уже вылетевших рейсах,
-- для которых отсутствует посадочный талон.
SELECT COUNT(*)
FROM segments AS s
JOIN flights AS f
    ON s.flight_id = f.flight_id
LEFT JOIN boarding_passes AS b
    ON s.ticket_no = b.ticket_no
   AND s.flight_id = b.flight_id
WHERE f.actual_departure IS NOT NULL
  AND b.flight_id IS NULL;


-- Найти пассажиров, у которых класс обслуживания в билете
-- не совпадает с классом фактически назначенного им места.
SELECT 
    r.route_no,
    f.scheduled_departure,
    f.flight_id,
    r.departure_airport,
    r.arrival_airport,
    r.airplane_code,
    t.passenger_name,
    sg.fare_conditions AS fc_to_be,
    s.fare_conditions AS fc_fact,
    b.seat_no
FROM boarding_passes AS b
JOIN segments AS sg
    ON b.ticket_no = sg.ticket_no
   AND b.flight_id = sg.flight_id
JOIN tickets AS t
    ON sg.ticket_no = t.ticket_no
JOIN flights AS f
    ON sg.flight_id = f.flight_id
JOIN routes AS r
    ON f.route_no = r.route_no
JOIN seats AS s
    ON b.seat_no = s.seat_no
   AND r.airplane_code = s.airplane_code
WHERE sg.fare_conditions <> s.fare_conditions
ORDER BY
    r.route_no,
    f.scheduled_departure;


-- Получить общую статистику по бронированиям:
-- количество, минимальную, максимальную, среднюю и суммарную стоимость.
SELECT
    COUNT(*) AS bookings_count,
    MIN(total_amount) AS min_amount,
    MAX(total_amount) AS max_amount,
    AVG(total_amount) AS avg_amount,
    SUM(total_amount) AS total_amount
FROM bookings;


-- Посчитать количество выполнений каждого маршрута в таблице flights.
SELECT
    route_no,
    COUNT(*) AS flights_count
FROM flights
GROUP BY route_no;


-- Посчитать количество рейсов каждого статуса и вывести самые распространённые статусы первыми.
SELECT
    status,
    COUNT(*) AS flights_count
FROM flights
GROUP BY status
ORDER BY flights_count DESC;


-- Посчитать количество мест каждого класса обслуживания
-- для каждой модели самолёта по её коду.
SELECT
    airplane_code,
    fare_conditions,
    COUNT(*) AS seats_count
FROM seats
GROUP BY
    airplane_code,
    fare_conditions
ORDER BY
    airplane_code,
    fare_conditions;


-- Посчитать количество мест каждого класса обслуживания для каждой модели самолёта,
-- выводя английское название модели вместо одного только кода.
SELECT
    a.model ->> 'en' AS airplane_model,
    s.fare_conditions,
    COUNT(*) AS seats_count
FROM seats AS s
JOIN airplanes_data AS a
    ON a.airplane_code = s.airplane_code
GROUP BY
    a.airplane_code,
    a.model,
    s.fare_conditions
ORDER BY
    airplane_model,
    s.fare_conditions;


-- Для каждого класса обслуживания посчитать количество сегментов
-- и среднюю стоимость одного сегмента.
SELECT
    fare_conditions,
    COUNT(*) AS segments_count,
    AVG(price) AS avg_price
FROM segments
GROUP BY fare_conditions;


-- Вывести рейсы, на которые оформлено более 100 пассажирских сегментов,
-- и показать количество таких сегментов для каждого рейса.
SELECT
    flight_id,
    COUNT(*) AS passengers_count
FROM segments
GROUP BY flight_id
HAVING COUNT(*) > 100;


-- Для уже фактически вылетевших рейсов вывести только те,
-- на которые было оформлено более 100 пассажирских сегментов,
-- отсортировав их по количеству пассажиров по убыванию.
SELECT
    f.flight_id,
    COUNT(s.ticket_no) AS passengers_count
FROM flights AS f
JOIN segments AS s
    ON s.flight_id = f.flight_id
WHERE f.actual_departure IS NOT NULL
GROUP BY f.flight_id
HAVING COUNT(s.ticket_no) > 100
ORDER BY passengers_count DESC;