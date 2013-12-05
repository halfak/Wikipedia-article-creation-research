SELECT
    DATABASE() as wiki,
    page_id,
    page_namespace,
    page_title,
    revisions,
    first_revision,
    last_revision,
    archived,
    IFNULL(rev_creation.rev_id, arc_creation.ar_rev_id) AS creating_rev_id,
    IFNULL(rev_creation.rev_timestamp, arc_creation.ar_timestamp) AS creating_rev_timestamp,
    user_id AS creator_id,
    IFNULL(creator.user_name, IFNULL(rev_creation.rev_user_text, arc_creation.ar_user_text)) AS creator_name,
    IFNULL(direct_create.log_action, indirect_create.log_action) AS creator_creation_action,
    user_registration AS creator_registration
FROM (
    (SELECT
        ar_page_id AS page_id,
        ar_namespace AS page_namespace,
        ar_title AS page_title,
        COUNT(*) AS revisions,
        MIN(ar_timestamp) AS first_revision,
        MAX(ar_timestamp) AS last_revision,
        True AS archived,
        MIN(ar_rev_id) AS first_rev_id
    FROM archive
    WHERE ar_timestamp < "20131105000000"
    GROUP BY 1,2,3)
    UNION
    (SELECT
        page_id,
        page_namespace,
        page_title,
        COUNT(*) AS revisions,
        MIN(rev_timestamp) AS first_edit,
        MAX(rev_timestamp) AS last_edit,
        False AS archived,
        MIN(rev_id) AS first_rev_id
    FROM revision
    INNER JOIN page ON page_id = rev_page
    WHERE rev_timestamp < "20131105000000"
    GROUP BY 1,2,3)
) as page
LEFT JOIN revision rev_creation ON rev_id = first_rev_id
LEFT JOIN archive arc_creation ON ar_rev_id = first_rev_id
LEFT JOIN user creator ON IFNULL(rev_creation.rev_user, arc_creation.ar_user) = user_id
LEFT JOIN logging AS direct_create ON
    direct_create.log_type = "newusers" AND
    creator.user_id = direct_create.log_user AND
    direct_create.log_action IN ("create", "autocreate", "newusers")
LEFT JOIN logging AS indirect_create ON
    indirect_create.log_type = "newusers" AND
    indirect_create.log_action IN ("byemail", "create2") AND
    REPLACE(creator.user_name, " ", "_") = indirect_create.log_title;
