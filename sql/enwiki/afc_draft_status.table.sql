DROP TABLE IF EXISTS halfak.nov13_afc_draft_status;
CREATE TABLE halfak.nov13_afc_draft_status
SELECT
    page_id,
    page_namespace,
    page_title,
    archived,
    DATEDIFF("20131113010101", last_revision) >= 6*30 AS should_be_archived,
    declined.cl_from IS NOT NULL AS declined_submission
FROM (
    SELECT * FROM halfak.nov13_page 
    WHERE page_namespace = 5 AND 
    page_title LIKE "Articles_for_creation/%"
) AS afc_page
LEFT JOIN categorylinks declined ON
    cl_from = page_id AND
    cl_to LIKE "AfC_submissions_declined%";
CREATE INDEX page_name_title ON halfak.nov13_afc_draft_status (page_id, page_namespace, page_title);
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_afc_draft_status;
