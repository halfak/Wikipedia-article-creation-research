DROP TABLE IF EXISTS staging.nov13_dewiki_page_origin;
CREATE TABLE staging.nov13_dewiki_page_origin
SELECT
	page.page_id,
	page.page_namespace,
	page.page_title,
	IFNULL(first_move.from_namespace, page.page_namespace) AS original_namespace,
	IFNULL(first_move.from_title, page.page_title) AS original_title
FROM staging.nov13_dewiki_page AS page
LEFT JOIN (
    SELECT
        page_id,
        page_namespace,
        page_title,
        MIN(rev_id) AS rev_id
    FROM staging.nov13_dewiki_move
    GROUP BY 1,2,3) AS first_move_id USING (page_id, page_namespace, page_title)
LEFT JOIN staging.nov13_dewiki_move first_move USING (rev_id);
CREATE UNIQUE INDEX page_name_title ON staging.nov13_dewiki_page_origin (page_id, page_namespace, page_title);
SELECT NOW() AS generated, COUNT(*) FROM staging.nov13_dewiki_page_origin;
