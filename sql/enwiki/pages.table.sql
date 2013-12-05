/*DROP TABLE IF EXISTS halfak.nov13_page;
CREATE TABLE halfak.nov13_page
SELECT
    ar_page_id AS page_id,
    ar_namespace AS page_namespace,
    ar_title AS page_title,
    COUNT(*) AS revisions,
    MIN(ar_timestamp) AS first_revision,
    MAX(ar_timestamp) AS last_revision,
    TRUE AS archived,
    MIN(ar_rev_id) AS first_rev_id
FROM archive
WHERE ar_timestamp < "20131105000000"
GROUP BY 1,2,3;
INSERT INTO halfak.nov13_page
SELECT
    page_id,
    page_namespace,
    page_title,
    COUNT(*) AS revisions,
    MIN(rev_timestamp) AS first_edit,
    MAX(rev_timestamp) AS last_edit,
    False AS archived,
    MIN(rev_id) AS first_rev_id
FROM revision
INNER JOIN page ON page_id = rev_page
WHERE rev_timestamp < "20131105000000"
GROUP BY 1,2,3;
SELECT NOW() AS "generated", COUNT(*) FROM halfak.nov13_page;*/




