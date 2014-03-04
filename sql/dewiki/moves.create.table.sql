DROP TABLE IF EXISTS staging.nov13_dewiki_move;
CREATE TABLE staging.nov13_dewiki_move (
    page_id INT,
    page_namespace INT, 
    page_title VARBINARY(255),
    rev_id INT,
    timestamp VARBINARY(14),
    from_namespace INT,
    from_title VARBINARY(255),
    to_namespace INT,
    to_title VARBINARY(255),
    move_comment VARBINARY(255)
);
CREATE INDEX page_name_title ON staging.nov13_dewiki_move (page_id, page_namespace, page_title);
CREATE UNIQUE INDEX rev_idx ON staging.nov13_dewiki_move (rev_id);
SELECT NOW() as generated, COUNT(*) FROM staging.nov13_dewiki_move;
