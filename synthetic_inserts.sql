--CREATE INITIAL DATASETS (warehouses,districts, customer and items)

INSERT INTO warehouse(w_name, w_street, w_city, w_zip)
SELECT md5(RANDOM()::TEXT), md5(RANDOM()::TEXT), md5(RANDOM()::TEXT), FLOOR(RANDOM()* 8999 + 1000 ::INT)
FROM GENERATE_SERIES(1, 2);

INSERT INTO district(d_w_id, d_name, d_street, d_city, d_zip)
WITH expanded AS (
  SELECT RANDOM(), seq, w_id AS w_id
  FROM GENERATE_SERIES(1, 10) seq, warehouse w
), shuffled AS (
  SELECT e.*
  FROM expanded e
  INNER JOIN (
    SELECT ei.seq, MIN(ei.random) FROM expanded ei GROUP BY ei.seq
  ) em ON (e.seq = em.seq AND e.random = em.min)
  ORDER BY e.seq
)
SELECT
    s.w_id,
    md5(RANDOM()::TEXT),
    md5(RANDOM()::TEXT), 
    md5(RANDOM()::TEXT), 
    FLOOR(RANDOM()* 8999 + 1000 ::INT)
FROM shuffled s;

INSERT INTO customer(c_w_id, c_d_id, c_first_name, c_last_name, c_street, c_city, c_zip, c_phone, c_since)
WITH expanded AS (
  SELECT RANDOM(), seq,  w_id AS w_id, d_id AS d_id
  FROM GENERATE_SERIES(1, 200) seq, warehouse w, district d
), shuffled AS (
  SELECT e.*
  FROM expanded e
  INNER JOIN (
    SELECT ei.seq, MIN(ei.random) FROM expanded ei GROUP BY ei.seq
  ) em ON (e.seq = em.seq AND e.random = em.min)
  ORDER BY e.seq
)
SELECT
  s.w_id,
  s.d_id,
  md5(RANDOM()::TEXT),
    md5(RANDOM()::TEXT), 
    md5(RANDOM()::TEXT), 
    md5(RANDOM()::TEXT),
    FLOOR(RANDOM()* 8999 + 1000 ::INT),
    md5(RANDOM()::TEXT),
    NOW() - (random() * (NOW()+'800 days' - NOW()))
FROM shuffled s;

INSERT INTO item(i_name, i_price, i_data)
SELECT md5(RANDOM()::TEXT), RANDOM()::NUMERIC(5,2), md5(RANDOM()::TEXT)
FROM GENERATE_SERIES(1, 4000);

/*In table stock a constraint is missing, tupel w_id and i_id should be unique
it is done with a simple update statement for simplicity reasons*/

INSERT INTO stock (s_i_id)
SELECT i_id FROM item; -- all 4000 items are inserted
UPDATE stock SET s_w_id = 4, s_quantity = 50 WHERE s_w_id ISNULL; --first warehouse id is assigend
INSERT INTO stock (s_i_id)
SELECT i_id FROM item; -- another 4000 items are inserted
UPDATE stock SET s_w_id = 3, s_quantity = 50 WHERE s_w_id ISNULL; --second warehouse id is assigned


-- CREATE A SET OF ALREADY EXISTING ORDERS

INSERT INTO orders (o_d_id, o_w_id, o_c_id, o_i_id, o_quantity, o_entry_d)
VALUES ((SELECT * FROM(SELECT d_id FROM district ORDER BY RANDOM()) AS a LIMIT 1), 
(SELECT * FROM(SELECT w_id FROM warehouse ORDER BY RANDOM()) AS b LIMIT 1), 
(SELECT * FROM(SELECT c_id FROM customer ORDER BY RANDOM()) AS c LIMIT 1), 
(SELECT * FROM(SELECT i_id FROM item ORDER BY RANDOM()) AS d LIMIT 1),
(FLOOR(RANDOM()* 20 + 1 ::INT)),
(NOW()));