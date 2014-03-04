SELECT
    DATE(CONCAT(LEFT(user_registration, 6), "01")) AS registration_month,
    COUNT(*) AS registered_users, /* registered users */
    SUM(revision_stats.day_revisions > 0) AS new_editors,
    SUM(page_stats.pages > 0) AS new_page_creators, /* users who started a any page in first 30 days */
    SUM(page_stats.article_pages > 0) AS new_article_creators, /* users who started an article page in first 30 days  */
    SUM(page_stats.draft_pages > 0) AS new_draft_creators /* users who started a draft article page in first 30 days  */
FROM (
    SELECT
        user_id,
        user_registration,
        SUM(day_revisions) AS day_revisions
    FROM (
        (
            SELECT
                user_id,
                user_registration,
                SUM(rev_id IS NOT NULL)  AS day_revisions
            FROM user
            LEFT JOIN revision ON 
                rev_user = user_id AND
                rev_timestamp < DATE_FORMAT(DATE_ADD(user_registration, INTERVAL 1 DAY), "%Y%m%d%H%i%S")
            WHERE
                user_registration > "2008"
            GROUP BY 1
        )
        UNION
        (
            SELECT
                user_id,
                user_registration,
                SUM(ar_id IS NOT NULL) AS day_revisions
            FROM user
            LEFT JOIN archive ON 
                ar_user_text = user_name AND
                ar_timestamp < DATE_FORMAT(DATE_ADD(user_registration, INTERVAL 1 DAY), "%Y%m%d%H%i%S")
            WHERE
                user_registration > "2008"
            GROUP BY 1,2
        )
    ) AS revision_archive_stats
    GROUP BY 1,2
) AS revision_stats
LEFT JOIN (
    SELECT 
        user_id, 
        SUM(c.user_id IS NOT NULL) AS pages, 
        SUM(ap.page_title IS NOT NULL) AS article_pages,
        SUM(ap.original_namespace != 0) AS draft_pages
    FROM user
    LEFT JOIN halfak.nov13_creation c USING (user_id)
    LEFT JOIN halfak.nov13_article_page ap USING (page_id)
    WHERE
        user_registration > "2008" AND 
        c.rev_timestamp < DATE_FORMAT(DATE_ADD(user_registration, INTERVAL 30 DAY), "%Y%m%d%H%i%S")
    GROUP BY 1
) AS page_stats USING (user_id)
GROUP BY 1
