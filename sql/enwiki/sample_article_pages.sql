(SELECT
    page_id,
    original_namespace,
    published,
    unpublished
FROM halfak.nov13_article_page
WHERE unpublished IS NOT NULL
AND published <= "20130101"
AND original_namespace = 0
ORDER BY RAND()
LIMIT 10000)
UNION
(SELECT
    page_id,
    original_namespace,
    published,
    unpublished
FROM halfak.nov13_article_page
WHERE unpublished IS NOT NULL
AND published <= "20130101"
AND original_namespace = 5
ORDER BY RAND()
LIMIT 10000)
UNION
(SELECT
    page_id,
    original_namespace,
    published,
    unpublished
FROM halfak.nov13_article_page
WHERE unpublished IS NOT NULL
AND published <= "20130101"
AND original_namespace = 2
ORDER BY RAND()
LIMIT 10000);
