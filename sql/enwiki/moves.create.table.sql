DROP TABLE IF EXISTS halfak.nov13_move;
CREATE TABLE halfak.nov13_move (
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
CREATE INDEX page_name_title ON halfak.nov13_move (page_id, page_namespace, page_title);
CREATE UNIQUE INDEX rev_idx ON halfak.nov13_move (rev_id);
SELECT NOW() as generated, COUNT(*) FROM halfak.nov13_move;
