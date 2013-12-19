SELECT
    DATE(CONCAT(LEFT(page.first_revision, 6), "01")) AS month_created,
    "enwiki" AS wiki,
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
    afc.page_id IS NOT NULL AS draft,
    COUNT(*) AS pages,
    COUNT(DISTINCT creator.user_name) AS page_creators,
    SUM(
        (
            (page.archived OR afc.should_be_archived) AND 
            (
                UNIX_TIMESTAMP(last_revision) - 
                UNIX_TIMESTAMP(first_revision)
            ) < 60*60*24*30
        ) OR afc.declined_submission
    ) AS archived_quickly
FROM halfak.nov13_page AS page
INNER JOIN halfak.nov13_creation AS creation USING (page_id)
LEFT JOIN halfak.nov13_user_stats AS creator USING (user_id)
LEFT JOIN halfak.nov13_afc_draft_status AS afc USING (page_id, page_title, page_namespace)
WHERE page_namespace = 0 OR afc.page_id IS NOT NULL
GROUP BY 1,2,3,4,5;
