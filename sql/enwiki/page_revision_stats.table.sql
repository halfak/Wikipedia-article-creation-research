DROP TABLE IF EXISTS halfak.nov13_page_revision_stats;
CREATE TABLE halfak.nov13_page_revision_stats
SELECT
    rev_page AS page_id,
    MIN(rev_id) AS first_rev_id,
    COUNT(*) AS revisions,
    MIN(rev_timestamp) AS first_edit,
    MAX(rev_timestamp) AS last_edit
FROM revision
WHERE rev_timestamp < "20131105000000"
GROUP BY 1;
