DROP TABLE IF EXISTS staging.nov13_dewiki_creation;
CREATE TABLE staging.nov13_dewiki_creation
SELECT
    IFNULL(page_id, ar_page_id) AS page_id,
    IFNULL(page_namespace, ar_namespace) AS page_namespace,
    IFNULL(page_title, ar_title) AS page_title,
    IFNULL(rev_id, ar_rev_id) AS rev_id,
    IFNULL(rev_comment, ar_comment) AS rev_comment,
    IFNULL(rev_user, ar_user) AS user_id,
    IFNULL(rev_user_text, ar_user_text) AS user_text,
    IFNULL(rev_timestamp, ar_timestamp) AS rev_timestamp,
    IFNULL(rev_deleted, ar_deleted) AS rev_deleted,
    IFNULL(rev_len, ar_len) AS rev_len
FROM staging.nov13_dewiki_page
LEFT JOIN revision ON first_rev_id = rev_id
LEFT JOIN archive ON first_rev_id = ar_rev_id
WHERE first_rev_id IS NOT NULL
GROUP BY 1,2,3;
INSERT INTO staging.nov13_dewiki_creation
SELECT
    ar_page_id AS page_id,
    ar_namespace AS page_namespace,
    ar_title AS page_title,
    ar_rev_id AS rev_id,
    ar_comment AS rev_comment,
    ar_user AS user_id,
    ar_user_text AS user_text,
    ar_timestamp AS rev_timestamp,
    ar_deleted AS rev_deleted,
    ar_len AS rev_len
FROM staging.nov13_dewiki_page
LEFT JOIN archive ON 
    ar_page_id = page_id AND
    ar_namespace = page_namespace AND
    ar_title = page_title AND
    ar_timestamp = first_revision
WHERE first_rev_id IS NULL
GROUP BY 1,2,3;
CREATE UNIQUE INDEX page_name_title ON staging.nov13_dewiki_creation (page_id, page_namespace, page_title);
SELECT NOW() AS "generated", COUNT(*) FROM staging.nov13_dewiki_creation;
