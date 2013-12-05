SELECT
    LEFT(creation.rev_timestamp, 8) AS date,
    page_namespace,
    log_action,
    COUNT(*) AS actions
FROM halfak.nov13_page AS page 
INNER JOIN halfak.nov13_creation AS creation USING (page_id)
LEFT JOIN halfak.nov13_curation_action AS curation_action USING (page_id)
GROUP BY 1,2,3;
