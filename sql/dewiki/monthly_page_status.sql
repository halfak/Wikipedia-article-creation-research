SELECT
    DATE(CONCAT(LEFT(page.first_revision, 6), "01")) AS month_created,
    page.page_namespace,
    IF(
        creator.user_id IS NULL OR creator.user_id = 0,
        "anon",
        IF(
            creator.account_creation_action IS NULL,
            "unknown",
            creator.account_creation_action
        )
    ) AS account_type,
    IF(
        UNIX_TIMESTAMP(page.first_revision) - 
        UNIX_TIMESTAMP(creator.user_registration) < 60*60*24,
        "day",
        IF(
            UNIX_TIMESTAMP(page.first_revision) - 
            UNIX_TIMESTAMP(creator.user_registration) < 60*60*24*7,
            "week",
            IF(
                UNIX_TIMESTAMP(page.first_revision) - 
                UNIX_TIMESTAMP(creator.user_registration) < 60*60*24*30,
                "month",
                "oldtimer"
            )
        )
    ) AS experience,
    COUNT(*) AS pages,
    SUM(archived) AS archived,
    COUNT(DISTINCT creation.user_text) AS page_creators,
    SUM(
        archived AND 
        (
            UNIX_TIMESTAMP(last_revision) - 
            UNIX_TIMESTAMP(first_revision)
        ) < 60*60*24*30
    ) AS archived_quickly
FROM staging.nov13_dewiki_page AS page
INNER JOIN staging.nov13_dewiki_creation AS creation USING (page_id)
LEFT JOIN staging.nov13_dewiki_user_stats AS creator USING (user_id)
GROUP BY 1,2,3,4;
