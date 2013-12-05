DROP TABLE IF EXISTS halfak.nov13_curation_action;
CREATE TABLE halfak.nov13_curation_action
SELECT
    log_id,
    log_action,
    log_user AS user_id,
    log_user_text AS user_text,
    log_page AS page_id,
    log_comment
FROM logging
WHERE 
    log_type = 'pagetriage-curation' AND
    log_timestamp < "20131105000000";
CREATE INDEX page_idx ON halfak.nov13_curation_action (page_id);
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_curation_action;
