----- B-Tree Index -----
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE order_id > 999999;

CREATE INDEX idx_bench_customer
ON orders (customer_id);

DROP INDEX idx_bench_customer;

------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE status = 'cancelled';

CREATE INDEX idx_bench_status
ON orders (status);

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE status = 'delivered';

DROP INDEX idx_bench_status;

----------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE total_amount BETWEEN 4500 AND 4700;

CREATE INDEX idx_bench_amount
ON orders (total_amount);

DROP INDEX idx_bench_amount;


----------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 5;

CREATE INDEX idx_bench_amount_desc
ON orders (total_amount DESC);

DROP INDEX idx_bench_amount_desc;

----------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE created_at >= '2026-04-01'
  AND created_at < '2026-04-02';

CREATE INDEX idx_bench_created
ON orders (created_at);

DROP INDEX idx_bench_created;

----- Hash Index -----

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE customer_id = 777;

CREATE INDEX idx_hash_customer
ON orders USING hash (customer_id);

DROP INDEX idx_hash_customer;

--------------------------------------

SELECT
    delivery_city,
    COUNT(*) AS orders_count
FROM orders
GROUP BY delivery_city
ORDER BY orders_count DESC;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE delivery_city = 'Москва';

CREATE INDEX idx_hash_city
ON orders USING hash (delivery_city);

DROP INDEX idx_hash_city;

-------------------------------------
SELECT
    status,
    COUNT(*) AS count_orders
FROM orders
GROUP BY status
ORDER BY count_orders DESC;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE status = 'cancelled';

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE status = 'delivered';

CREATE INDEX idx_hash_status
ON orders USING hash (status);

DROP INDEX idx_hash_status;

-------------------------------
SELECT
    total_amount,
    COUNT(*) AS count_orders
FROM orders
GROUP BY total_amount
ORDER BY count_orders DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE total_amount = 6530;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE total_amount BETWEEN 5000 AND 7000;

CREATE INDEX idx_hash_amount
ON orders USING hash (total_amount);

DROP INDEX idx_hash_amount;

------------------------------------------
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    o.order_id,
    o.customer_id,
    o.order_number,
    o.total_amount
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IN (101, 202, 303, 404, 505);

CREATE INDEX idx_hash_customer_join
ON orders USING hash (customer_id);

DROP INDEX idx_hash_customer_join;