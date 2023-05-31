DROP DATABASE IF EXISTS hw4;
CREATE DATABASE hw4;
USE hw4;

-- 0. Creating new table 'auto' and filling them
CREATE TABLE AUTO
(
    REGNUM    VARCHAR(10) PRIMARY KEY,
    MARK      VARCHAR(10),
    COLOR     VARCHAR(15),
    RELEASEDT DATE,
    PHONENUM  VARCHAR(15)
);

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111114, 'LADA', 'КРАСНЫЙ', date'2008-01-01', '9152222221');

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111115, 'VOLVO', 'КРАСНЫЙ', date'2013-01-01', '9173333334');

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111116, 'BMW', 'СИНИЙ', date'2015-01-01', '9173333334');

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111121, 'AUDI', 'СИНИЙ', date'2009-01-01', '9173333332');

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111122, 'AUDI', 'СИНИЙ', date'2011-01-01', '9213333336');

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111113, 'BMW', 'ЗЕЛЕНЫЙ', date'2007-01-01', '9214444444');

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111126, 'LADA', 'ЗЕЛЕНЫЙ', date'2005-01-01', null);

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111117, 'BMW', 'СИНИЙ', date'2005-01-01', null);

INSERT INTO AUTO (REGNUM, MARK, COLOR, RELEASEDT, PHONENUM)
VALUES (111119, 'LADA', 'СИНИЙ', date'2017-01-01', 9213333331);


-- 1. Вывести на экран, сколько машин каждого цвета для машин марок BMW и LADA
SELECT
    COLOR,
    MARK,
    COUNT(REGNUM)
FROM
    (SELECT MARK, COLOR, REGNUM
       FROM AUTO
      WHERE MARK = 'BMW'
            OR MARK = 'LADA') AS bwm_lada_group
GROUP BY COLOR, MARK
ORDER BY MARK;

-- 2. Вывести на экран марку авто(количество) и количество авто не этой марки.
SELECT CONCAT(SUM(qty) OVER (), ' машин, их них ', qty, ' - ', MARK, ' и ', SUM(qty) OVER () - qty,
              ' машин другой марки') AS result
FROM (SELECT MARK, COUNT(REGNUM) AS qty
        FROM AUTO
       GROUP BY MARK) AS mark_group;

-- 3. Даны 2 таблицы. Напишите запрос, который вернет строки из таблицы test_a, id которых нет в таблице test_b, НЕ используя ключевого слова NOT.

CREATE TABLE test_a
(
    id   INT,
    test varchar(10)
);

CREATE TABLE test_b
(
    id INT
);

INSERT INTO test_a(id, test)
VALUES (10, 'A'),
       (20, 'A'),
       (30, 'F'),
       (40, 'D'),
       (50, 'C');

INSERT INTO test_b(id)
VALUES (10),
       (30),
       (50);

SELECT test_a.*
FROM test_a
LEFT JOIN test_b
ON test_a.id = test_b.id
WHERE test_b.id IS NULL;


-- 4. Дополнительное задание
 /*Вернёмся к домашней работе #3 и заметим, что таблица orders была неудачно спроектирована. 
 Записи odate были заданы типом VARCHAR и в них долгое время помещались значения в формате '10/03/1990'. 
 Необходимо преобразовать поля таблицы к типу DATETIME, сохранив введеные ранее значения. */
CREATE TABLE IF NOT EXISTS orders
(
    onum  INT           NOT NULL,
    amt   DECIMAL(7, 2) NOT NULL,
    odate VARCHAR(10)   NOT NULL,
    cnum  INT,
    snum  INT,
    PRIMARY KEY (onum)
);

INSERT INTO orders(onum, amt, odate, cnum, snum)
VALUES (3001, 18.69, '10/03/1990', 2008, 1007),
       (3003, 767.19, '10/03/1990', 2001, 1001),
       (3002, 1900.10, '10/03/1990', 2007, 1004),
       (3005, 5160.45, '10/03/1990', 2003, 1002),
       (3006, 1098.16, '10/03/1990', 2008, 1007),
       (3009, 1713.23, '10/04/1990', 2002, 1003),
       (3007, 75.75, '10/04/1990', 2004, 1002),
       (3008, 4723.00, '10/05/1990', 2006, 1001),
       (3010, 1309.95, '10/06/1990', 2004, 1002),
       (3011, 9891.88, '10/06/1990', 2006, 1001);

ALTER TABLE orders
    ADD COLUMN odate_correct DATE;
    
UPDATE orders
    SET odate_correct = str_to_date(odate, '%d/%m/%Y');