/* Deletion */
DROP TABLE IF EXISTS halfak.nov13_deletion;
CREATE TABLE halfak.nov13_deletion
SELECT
    log_id, 
    log_type,
    log_user AS user_id,
    log_user_text AS user_text,
    log_page AS page_id,
    log_namespace AS page_namespace,
    log_title AS page_title,
    log_timestamp,
    log_comment
FROM logging
WHERE
    log_action = 'delete' AND 
    log_type = 'delete' AND 
    log_timestamp < "20131105000000";
CREATE INDEX namespace_title_idx ON halfak.nov13_deletion (page_namespace, page_title);
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_deletion;
