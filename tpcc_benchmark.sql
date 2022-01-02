\set quantity random(1, 10 * :scale)
\set tid random(1, 200 * :scale)
\set delta random(-5000, 5000)

BEGIN;
UPDATE customer SET c_limit = c_limit + :delta WHERE c_id = :tid;
UPDATE customer SET c_discount = c_balance * 0.01 WHERE c_id = :tid;
SELECT orders.o_id, orders.o_quantity, (item.i_price * orders.o_quantity) AS total_price FROM orders INNER JOIN item ON orders.o_i_id = item.i_id ORDER BY orders.o_id LIMIT 1;;
INSERT INTO customer (c_w_id, c_d_id, c_first_name, c_last_name, c_street, c_city, c_zip, c_since)
VALUES ((SELECT * FROM(SELECT w_id FROM warehouse ORDER BY RANDOM()) AS b LIMIT 1),
        (SELECT * FROM(SELECT d_id FROM district ORDER BY RANDOM()) AS a LIMIT 1),
        (md5(RANDOM()::TEXT)),(md5(RANDOM()::TEXT)),(md5(RANDOM()::TEXT)),(md5(RANDOM()::TEXT)),(FLOOR(RANDOM()* 8999 + 1000 ::INT)),(NOW()));
END;