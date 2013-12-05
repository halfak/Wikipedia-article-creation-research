DROP TABLE IF EXISTS halfak.nov13_sample_deleted_page;
CREATE TABLE halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2013%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2012%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2011%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2010%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2009%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2008%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2007%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2006%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2005%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2004%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2003%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2002%"
AND archived
ORDER BY RAND()
LIMIT 1000;

INSERT INTO halfak.nov13_sample_deleted_page
SELECT *
FROM halfak.nov13_page
WHERE first_revision LIKE "2001%"
AND archived
ORDER BY RAND()
LIMIT 1000;

SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_sample_deleted_page