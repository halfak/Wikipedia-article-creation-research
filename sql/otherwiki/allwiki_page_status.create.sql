DROP TABLE IF EXISTS halfak.nov13_allwiki_page_status;
CREATE TABLE halfak.nov13_allwiki_page_status (
    wiki VARCHAR(255),
    page_id INT, /* Page identifier (if not archived) */
    page_namespace INT,
    page_title VARBINARY(255),
    revisions INT, /* Number of revisions saved */ 
    first_revision VARBINARY(14), /* Date of the first revision */
    last_revision  VARBINARY(14), /* Date of the last revision */
    archived TINYINT, /* True if in archive table, false otherwise */
    creating_rev_id INT, /* rev_id of the creating revision */
    creating_rev_timestamp VARBINARY(14),
    creator_id INT, /* user_id of the creator (or NULL for anons) */
    creator_name VARBINARY(255), /* user_name of the creator (or IP for anons) */
    creator_action VARBINARY(255), /* log_action for relevant account creations */
    creator_registration VARBINARY(14) /* registration date of creator (or NULL for anons) */
);
CREATE INDEX wiki_idx ON halfak.nov13_allwiki_page_status (wiki);
SELECT NOW() AS generated, COUNT(*) FROM halfak.nov13_allwiki_page_status;
