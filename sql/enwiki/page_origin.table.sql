DROP TABLE IF EXISTS halfak.nov13_page_origin;
CREATE TABLE halfak.nov13_page_origin
SELECT
	page.page_id,
	page.page_namespace,
	page.page_title,
	IFNULL(first_move.from_namespace, page.page_namespace) AS original_namespace,
	IFNULL(first_move.from_title, page.page_title) AS original_title
FROM halfak.nov13_page AS page
LEFT JOIN (
    SELECT
        page_id,
        page_namespace,
        page_title,
        MIN(rev_id) AS rev_id
    FROM halfak.nov13_move
    GROUP BY 1,2,3) AS first_move_id USING (page_id, page_namespace, page_title)
LEFT JOIN halfak.nov13_move first_move USING (rev_id);
CREATE UNIQUE INDEX page_name_title ON halfak.nov13_page_origin (page_id, page_namespace, page_title);
SELECT NOW() AS generated, COUNT(*) FROM halfak.nov13_page_origin;
