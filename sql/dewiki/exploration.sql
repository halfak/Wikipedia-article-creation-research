SELECT
    page_id,
    page_namespace,
    page_title,
    original_namespace,
    original_title,
    first_revision as created,
    IF(original_namespace = 0, first_revision, publish.timestamp) AS published,
    IF(archived OR unpublish.page_id IS NOT NULL, 
        IF(
            archived, 
            IF(unpublish.timestamp < last_revision, unpublish.timestamp, last_revision),
            unpublish.timestamp
        ),
        NULL
    ) AS unpublished
FROM halfak.nov13_page page
INNER JOIN halfak.nov13_page_origin origin USING (page_id, page_namespace, page_title)
LEFT JOIN halfak.publish USING (page_id, page_namespace, page_title)
LEFT JOIN halfak.unpublish USING (page_id, page_namespace, page_title)
WHERE
    (original_namespace = 0 OR
    publish.page_id IS NOT NULL) AND
    page.page_id IS NULL AND 
    page.page_title = "!!!!" AND
    page.page_namespace = 0;

SELECT
    o.page_id, 
    o.page_namespace, 
    o.page_title 
FROM nov13_page_origin o
LEFT JOIN nov13_article_page ap USING (page_id, page_namespace, page_title)
WHERE ap.page_id IS NULL
AND o.original_namespace = 0
LIMIT 10;
/*
+---------+----------------+--------------------------------------------------------------------------------------------------------------
---------------------------+
| page_id | page_namespace | page_title                                                                                                   
                           |
+---------+----------------+--------------------------------------------------------------------------------------------------------------
---------------------------+
|    NULL |              0 | !!!!                                                                                                         
                           |
|    NULL |              0 | !!!!!                                                                                                        
                           |
|    NULL |              0 | !!!!!!!!!!!!!!!!!!!                                                                                          
                           |
|    NULL |              0 | !!!!!!!!!!!!&&&&&&&&&&&********((_)))))F/W///CHRYSLER/FUCKING/FUCKING/FUCKING/I_HATE_THE_QUEEN!!!/I_AM_HORRID
_HENRY/Chrysler_Cirrus/php |
|    NULL |              0 | !!!!!Hephaestos_IS_A_FUCKING_WHINY_GUY!!!!!!                                                                 
                           |
|    NULL |              0 | !!!!1111oneoneone                                                                                            
                           |
|    NULL |              0 | !!!!???????                                                                                                  
                           |
|    NULL |              0 | !!!!YOU_ARE_A_COCKSUCKING_WHINY_GREASER!!!!                                                                  
                           |
|    NULL |              0 | !!!1                                                                                                         
                           |
|    NULL |              0 | !!!BESQUERKAN!!!                                                                                             
                           |
+---------+----------------+--------------------------------------------------------------------------------------------------------------
---------------------------+
10 rows in set (1 hour 23 min 28.23 sec)
*/
