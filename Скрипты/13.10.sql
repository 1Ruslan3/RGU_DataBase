select count(*) from airplanes_data;
select count(*) from airports_data;

select count(*) from airplanes_data
cross join airports_data;

--FROM left_table
--[INNER] JOIN [L | R] right_table 
-- ON l.id = r.id

SELECT
    a1.airport_code,
    a1.city ->> 'en' AS city1,
    a2.airport_code,
    a2.city ->> 'en' AS city2
FROM airports_data  a1
JOIN airports_data  a2
    ON a1.city <> a2.city; -- Тета-соединение
    
select * 
from airplanes_data, airports_data;

SELECT status
FROM flights;

SELECT DISTINCT status
FROM flights;

SELECT distinct 
    b.book_ref,
    b.total_amount
FROM bookings AS b
JOIN tickets AS t
    ON t.book_ref = b.book_ref
order by b.total_amount;

SELECT SUM(b.total_amount)
FROM bookings AS b
JOIN tickets AS t
    ON t.book_ref = b.book_ref;

SELECT departure_airport
FROM routes
UNION
SELECT arrival_airport
FROM routes;

SELECT departure_airport
FROM routes
UNION ALL
SELECT arrival_airport
FROM routes;

SELECT
    s.ticket_no,
    s.flight_id,
    s.fare_conditions,
    s.price,
    f.status,
    f.scheduled_departure
FROM segments AS s
JOIN flights AS f
ON s.flight_id  = f.flight_id;
--using (flight_id);

SELECT *
FROM airplanes_data AS a1
JOIN airplanes_data AS a2
    ON a1.airplane_code < a2.airplane_code;

select airplane_code from airplanes_data ad;
    
--5
select model, airplanes_data.range
from airplanes_data
where range > (
	select avg(range) from airplanes_data 
)
order by range DESC;


select 
	count(*) as bookings_count,
	min(total_amount) as min_amount,
	max(total_amount) as max_amount,
	round(avg(total_amount),2) as avg_amount,
	sum(total_amount) as total_amount
from bookings;


select 
	status,
	count(flight_id) as flight_count
from flights f 
group by status
order by flight_count desc;
 
-- 9
select
	airplane_code,
	fare_conditions,
	count(seat_no) AS seats_count
from seats AS s
group by airplane_code, fare_conditions
order by seats_count asc;

-- 11
select 
 	flight_id,
 	COUNT(*) as segments_count
 from segments
 group by flight_id 
 having count(*) > 100
 order by segments_count desc;

select
	passenger_id,
	passenger_name,
	count(*) as seg_count,
	count(distinct fare_conditions) as cond_count
from tickets as t
join segments as s on t.ticket_no = s.ticket_no
group by passenger_id, passenger_name having count(distinct fare_conditions) > 1; -- 12






