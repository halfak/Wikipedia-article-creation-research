SELECT
    LEFT(timestamp, 8) AS date,
    page_namespace,
    action,
    COUNT(*) AS n
FROM (
SELECT log_timestamp as timestamp, page_namespace, "deletion" AS action FROM halfak.nov13_deletion
UNION
SELECT log_timestamp as timestamp, page_namespace, "restoration" AS action FROM halfak.nov13_restoration
UNION
SELECT first_revision as timestamp, page_namespace, "creation" AS action FROM halfak.nov13_page
) AS foo
GROUP BY 1,2,3;
