SELECT
    DATE(CONCAT(LEFT(creating_rev_timestamp, 6), "01")) AS month_created,
    wiki,
    IF(
        creator_id = 0,
        "anon",
        IF(
            creator_action IS NULL,
            "unknown",
            creator_action
        )
    ) AS account_type,
    IF(
        creator_id = 0,
        NULL,
        IF(
            UNIX_TIMESTAMP(first_revision) - 
            UNIX_TIMESTAMP(creator_registration) < 60*60*24,
            "day",
            IF(
                UNIX_TIMESTAMP(first_revision) - 
                UNIX_TIMESTAMP(creator_registration) < 60*60*24*7,
                "week",
                IF(
                    UNIX_TIMESTAMP(first_revision) - 
                    UNIX_TIMESTAMP(creator_registration) < 60*60*24*30,
                    "month",
                    "oldtimer"
                )
            )
        )
    ) AS experience,
    COUNT(*) AS pages,
    COUNT(DISTINCT creator_name) AS page_creators,
    SUM(
        archived AND 
        (
            UNIX_TIMESTAMP(last_revision) - 
            UNIX_TIMESTAMP(first_revision)
        ) < 60*60*24*30
    ) AS archived_quickly
FROM halfak.nov13_allwiki_page_status
WHERE page_namespace = 0
GROUP BY 1, 2, 3, 4;
