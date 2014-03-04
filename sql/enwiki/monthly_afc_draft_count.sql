SELECT
    DATE(CONCAT(LEFT(rev_timestamp, 6), "01")) AS month_created,
    IF(
        creator.user_id IS NULL OR creator.user_id = 0,
        "anon",
        IF(
            creator.account_creation_action = "create" OR
            creator.account_creation_action = "byemail",
            "self-created",
            IF(
                 creator.account_creation_action = "autocreate",
                 "autocreate",
                 NULL
            )
        )
    ) AS creator_type,
    IF(
        UNIX_TIMESTAMP(creation.rev_timestamp) - 
        UNIX_TIMESTAMP(creator.user_registration) < 60*60*24,
        "-day",
        IF(
            UNIX_TIMESTAMP(creation.rev_timestamp) - 
            UNIX_TIMESTAMP(creator.user_registration) < 60*60*24*7,
            "day-week",
            IF(
                UNIX_TIMESTAMP(creation.rev_timestamp) - 
                UNIX_TIMESTAMP(creator.user_registration) < 60*60*24*30,
                "week-month",
                IF(
                    UNIX_TIMESTAMP(creation.rev_timestamp) - 
                    UNIX_TIMESTAMP(creator.user_registration) >= 60*60*24*30,
                    "month-",
                    NULL
                )
            )
        )
    ) AS creator_tenure,
    COUNT(DISTINCT creation.user_text) AS unique_authors,
    COUNT(*) AS pages_created
FROM halfak.nov13_page_origin 
INNER JOIN halfak.nov13_creation AS creation USING (page_id)
LEFT JOIN halfak.nov13_user_stats AS creator USING (user_id)
WHERE
    original_namespace = 5 AND
    original_title LIKE "Articles_for_creation/%"
GROUP BY 1,2,3;
