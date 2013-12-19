DROP TABLE IF EXISTS halfak.nov13_move_revision;
CREATE TABLE halfak.nov13_move_revision
SELECT 
    rev_id,
    page_id,
    page_namespace,
    page_title,
    rev_user AS user_id,
    rev_user_text AS user_text,
    rev_timestamp,
    rev_comment
FROM revision
INNER JOIN page ON rev_page = page_id
WHERE rev_comment RLIKE '.*moved .*\\[\\[([^\]]+)\\]\\] to \\[\\[([^\]]+)\\]\\].*:.*'
UNION
SELECT
    ar_rev_id AS rev_id,
    ar_page_id AS page_id,
    ar_namespace AS page_namespace,
    ar_title AS page_title,
    ar_user AS user_id,
    ar_user_text AS user_text,
    ar_timestamp AS rev_timestamp,
    ar_comment AS rev_comment
FROM archive
WHERE ar_comment RLIKE '.*moved .*\\[\\[([^\]]+)\\]\\] to \\[\\[([^\]]+)\\]\\].*:.*';
CREATE INDEX page_idx ON halfak.nov13_move_revision (page_id, page_namespace, page_title);
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_move_revision;
