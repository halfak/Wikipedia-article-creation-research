/* Deletion */
DROP TABLE IF EXISTS halfak.nov13_restoration;
CREATE TABLE halfak.nov13_restoration
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
    log_action = 'restore' AND 
    log_type = 'delete' AND 
    log_timestamp < "20131105000000";
CREATE INDEX page_idx ON halfak.nov13_restoration (page_id);
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_restoration;
