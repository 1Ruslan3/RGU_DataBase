SELECT SUM(price) AS total_price
FROM segments;


SELECT COUNT(*) AS booking_count
FROM bookings.bookings;


SELECT
    COUNT(*) AS booking_count,
    SUM(total_amount) AS total_booking_amount,
    ROUND(AVG(total_amount), 2) AS average_booking_amount,
    MIN(total_amount) AS cheapest_booking,
    MAX(total_amount) AS most_expensive_booking
FROM bookings.bookings;

SELECT COUNT(*) AS cancelled_flight_count
FROM bookings.flights
WHERE status = 'Cancelled';

SELECT
    COUNT(*) AS all_flights,
    COUNT(actual_departure) AS flights_with_departure_time,
    COUNT(*) - COUNT(actual_departure)
        AS flights_without_departure_time
FROM bookings.flights;

SELECT
    COUNT(*) AS segment_count,
    COUNT(DISTINCT ticket_no) AS ticket_count
FROM bookings.segments;

SELECT
    COUNT(*) AS ticket_count,
    COUNT(DISTINCT passenger_id) AS passenger_identifier_count
FROM bookings.tickets; 


SELECT SUM(price) AS business_segment_price
FROM bookings.segments
WHERE fare_conditions = 'Business';

SELECT
    SUM(price) AS original_total,
    SUM(price * 0.90) AS hypothetical_discounted_total
FROM bookings.segments;


SELECT AVG(price) AS average_segment_price
FROM bookings.segments;

select sum(price) / count(ticket_no) 
from segments as s ;


SELECT
    COUNT(*) AS row_count,
    SUM(price) AS total_price,
    AVG(price) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM bookings.segments
WHERE FALSE;

SELECT COALESCE(SUM(price), 1) AS total_price
FROM bookings.segments
WHERE FALSE;

SELECT
    book_ref,
    book_date,
    total_amount
FROM bookings.bookings
WHERE total_amount = (
    SELECT MAX(total_amount)
    FROM bookings.bookings
);

SELECT
    fare_conditions,
    COUNT(*) AS segment_count,
    SUM(price) AS total_price,
    ROUND(AVG(price), 2) AS average_price
FROM bookings.segments
GROUP BY fare_conditions
ORDER BY fare_conditions DESC;


SELECT
    fare_conditions,
    ticket_no,
    AVG(price)
FROM bookings.segments
GROUP BY fare_conditions, bookings.segments.ticket_no ;

SELECT
    fare_conditions,
    COUNT(DISTINCT ticket_no) AS ticket_count,
    AVG(price) AS average_price
FROM bookings.segments
GROUP BY fare_conditions;



SELECT
    fare_conditions,
    COUNT(*) AS segment_count
FROM bookings.segments
WHERE price >= 10000
GROUP BY fare_conditions;


SELECT
    fare_conditions,
    sum(price)
FROM bookings.segments
GROUP BY fare_conditions
HAVING sum(price) > 2000000000;


SELECT
    fare_conditions,
    COUNT(*) AS segment_count,
    ROUND(AVG(price), 2) AS average_price
FROM bookings.segments
WHERE price >= 10000
GROUP BY fare_conditions
HAVING COUNT(*) >= 100000
ORDER BY average_price DESC;


SELECT
    fare_conditions,
    AVG(price) AS average_price
FROM bookings.segments
WHERE price >= 20000
GROUP BY fare_conditions;


a
SELECT
    fare_conditions,
    AVG(price) AS average_price
FROM bookings.segments
GROUP BY fare_conditions
HAVING AVG(price) >= 2000;



SELECT
    fare_conditions,
    COUNT(*) AS segment_count,
    ROUND(AVG(price), 2) AS average_price
FROM bookings.segments
WHERE price >= 10000
GROUP BY fare_conditions
HAVING COUNT(*) >= 100
ORDER BY average_price DESC
LIMIT 2;

