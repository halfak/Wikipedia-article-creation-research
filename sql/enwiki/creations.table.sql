/*DROP TABLE IF EXISTS halfak.nov13_creation;
CREATE TABLE halfak.nov13_creation
SELECT
    IFNULL(rev_id, ar_rev_id) AS rev_id,
    IFNULL(rev_page, ar_page_id) AS page_id,
    IFNULL(rev_comment, ar_comment) AS rev_comment,
    IFNULL(rev_user, ar_user) AS user_id,
    IFNULL(rev_user_text, ar_user_text) AS user_text,
    IFNULL(rev_timestamp, ar_timestamp) AS rev_timestamp,
    IFNULL(rev_deleted, ar_deleted) AS rev_deleted,
    IFNULL(rev_len, ar_len) AS rev_len
FROM halfak.nov13_page
LEFT JOIN revision ON first_rev_id = rev_id
LEFT JOIN archive ON first_rev_id = ar_rev_id;
CREATE INDEX page_idx ON halfak.nov13_creation (page_id);
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_creation;*/
