SELECT
    DATE(CONCAT(LEFT(published, 6), "01")) AS month_published,
    original_namespace,
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
        UNIX_TIMESTAMP(page.created) - 
        UNIX_TIMESTAMP(creator.user_registration) < 60*60*24,
        "-day",
        IF(
            UNIX_TIMESTAMP(page.created) - 
            UNIX_TIMESTAMP(creator.user_registration) < 60*60*24*7,
            "day-week",
            IF(
                UNIX_TIMESTAMP(page.created) - 
                UNIX_TIMESTAMP(creator.user_registration) < 60*60*24*30,
                "week-month",
                IF(
                    UNIX_TIMESTAMP(page.created) - 
                    UNIX_TIMESTAMP(creator.user_registration) >= 60*60*24*30,
                    "month-",
                    NULL
                )
            )
        )
    ) AS creator_tenure,
    COUNT(DISTINCT creation.user_text) AS unique_authors,
    COUNT(*) AS articles_published,
    SUM(
        (
            UNIX_TIMESTAMP(published) - 
            UNIX_TIMESTAMP(unpublished)
        ) < 60*60*24*30
    ) AS articles_unpublished_quickly
FROM staging.nov13_dewiki_article_page page
INNER JOIN staging.nov13_dewiki_creation AS creation USING (page_id)
LEFT JOIN staging.nov13_dewiki_user_stats AS creator USING (user_id)
GROUP BY 1,2,3,4;
