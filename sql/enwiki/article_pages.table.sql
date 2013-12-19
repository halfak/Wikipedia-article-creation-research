CREATE TEMPORARY TABLE halfak.publish
SELECT
    origin.page_id,
    origin.page_namespace,
    origin.page_title,
    MIN(main_move.timestamp) AS timestamp
FROM halfak.nov13_page_origin origin
INNER JOIN halfak.nov13_move main_move ON 
    origin.page_id = main_move.page_id AND
    origin.page_namespace = main_move.page_namespace AND
    origin.page_title = main_move.page_title AND
    main_move.from_namespace != 0 AND
    main_move.to_namespace = 0
WHERE origin.original_namespace != 0
GROUP BY 1,2,3;
CREATE UNIQUE INDEX page_name_title ON halfak.publish (page_id, page_namespace, page_title);

CREATE TEMPORARY TABLE halfak.unpublish
SELECT
    origin.page_id,
    origin.page_namespace,
    origin.page_title,
    MIN(out_move.timestamp) AS timestamp
FROM halfak.nov13_page_origin origin
INNER JOIN halfak.nov13_move out_move ON
    origin.page_id = out_move.page_id AND
    origin.page_namespace = out_move.page_namespace AND
    origin.page_title = out_move.page_title AND
    out_move.from_namespace = 0 AND
    out_move.to_namespace != 0
GROUP BY 1,2,3;
CREATE UNIQUE INDEX page_name_title ON halfak.unpublish (page_id, page_namespace, page_title);

DROP TABLE IF EXISTS halfak.nov13_article_page;
CREATE TABLE halfak.nov13_article_page
SELECT
    page_id,
    page_namespace,
    page_title,
    original_namespace,
    original_title,
    first_revision as created,
    IF(original_namespace = 0, first_revision, publish.timestamp) AS published,
    IF(archived OR unpublish.page_id IS NOT NULL, 
        IF(
            archived, 
            IF(unpublish.timestamp < last_revision, unpublish.timestamp, last_revision),
            unpublish.timestamp
        ),
        NULL
    ) AS unpublished
FROM halfak.nov13_page
INNER JOIN halfak.nov13_page_origin origin USING (page_id, page_namespace, page_title)
LEFT JOIN halfak.publish USING (page_id, page_namespace, page_title)
LEFT JOIN halfak.unpublish USING (page_id, page_namespace, page_title)
WHERE
    original_namespace = 0 OR
    publish.page_id IS NOT NULL;
SELECT NOW() AS generated, COUNT(*) FROM halfak.nov13_article_page;
