DROP TABLE IF EXISTS staging.nov13_dewiki_user_stats;
CREATE TABLE staging.nov13_dewiki_user_stats
SELECT
    user.user_id,
    user.user_name,
    user_registration,
    IFNULL(direct_create.log_action, indirect_create.log_action) AS account_creation_action
FROM (SELECT DISTINCT user_id FROM staging.nov13_dewiki_creation) AS creator
INNER JOIN user AS user USING (user_id)
LEFT JOIN logging AS direct_create ON
    direct_create.log_type = "newusers" AND
    creator.user_id = direct_create.log_user AND
    direct_create.log_action IN ("create", "autocreate", "newusers")
LEFT JOIN logging AS indirect_create ON
    indirect_create.log_type = "newusers" AND
    indirect_create.log_action IN ("byemail", "create2") AND
    REPLACE(user.user_name, " ", "_") = indirect_create.log_title
GROUP BY 1,2,3;
CREATE UNIQUE INDEX user_idx ON staging.nov13_dewiki_user_stats (user_id);
SELECT NOW() AS "generated", COUNT(*) FROM staging.nov13_dewiki_user_stats;
