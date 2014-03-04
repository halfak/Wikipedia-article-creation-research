/*
Example comments:
2005 - 2012
hat „[[Benutzer Diskussion:Amberg]]“ nach „[[Benutzer Diskussion:Amberg/Archiv 2009]]“ verschoben: Jahresarchiv
2012 -
NoviSadGrad verschob die Seite [[Autoput M1]] nach [[Autoput A1]]
Rax verschob die Seite [[Benutzer:Schlesinger/Mitteldeutsche Eisenbahn]] nach [[Benutzer:Wahldresdner/Mitteldeutsche Eisenbahn]], ohne dabei eine Weiterleitung anzulegen: ..
*/
DROP TABLE IF EXISTS staging.nov13_dewiki_move_revision;
CREATE TABLE staging.nov13_dewiki_move_revision
SELECT 
    rev_id,
    page_id,
    page_namespace,
    page_title,
    rev_user AS user_id,
    rev_user_text AS user_text,
    rev_timestamp,
    rev_comment
FROM revision
INNER JOIN page ON rev_page = page_id
WHERE rev_comment RLIKE ".*(hat „|verschob „|verschob Seite |verschob die Seite )\\[\\[([^\]]+)\\]\\](“)? nach („)?\\[\\[([^\]]+)\\]\\](“)?(.*)"
UNION
SELECT
    ar_rev_id AS rev_id,
    ar_page_id AS page_id,
    ar_namespace AS page_namespace,
    ar_title AS page_title,
    ar_user AS user_id,
    ar_user_text AS user_text,
    ar_timestamp AS rev_timestamp,
    ar_comment AS rev_comment
FROM archive
WHERE ar_comment RLIKE ".*(hat „|verschob „|verschob Seite |verschob die Seite )\\[\\[([^\]]+)\\]\\](“)? nach („)?\\[\\[([^\]]+)\\]\\](“)?(.*)";
CREATE INDEX page_idx ON staging.nov13_dewiki_move_revision (page_id, page_namespace, page_title);
SELECT NOW() AS "generated", COUNT(*) FROM staging.nov13_dewiki_move_revision;

/*
import re
pattern = re.compile('.*(hat „|verschob „|verschob Seite |verschob die Seite )\\[\\[(?P<from>[^\]]+)\\]\\]“? nach „?\\[\\[(?P<to>[^\]]+)\\]\\]“?(.*)')
match = pattern.match("Rax verschob die Seite [[Benutzer:Schlesinger/Mitteldeutsche Eisenbahn]] nach [[Benutzer:Wahldresdner/Mitteldeutsche Eisenbahn]], ohne dabei eine Weiterleitung anzulegen: ..")
match.group("from")
match.group("to")
match = pattern.match("Ingochina verschob Seite [[Jiaxin Cheng]] nach [[Cheng Jiaxin]] und überschrieb dabei eine Weiterleitung: Bitte chinesische Namenskonvention beachten. Diese Frau heißt Cheng Jiaxin und nicht Jiaxin Cheng, jedenfalls nicht so lange sie nicht in UK ode…")
match.group("from")
match.group("to")
*/

/* test!

SELECT
    rev_id,
    rev_comment,
    rev_comment RLIKE ".*(hat „|verschob „|verschob Seite |verschob die Seite )\\[\\[([^\]]+)\\]\\](“)? nach („)?\\[\\[([^\]]+)\\]\\](“)?(.*)"
FROM revision
WHERE rev_id IN (
    33114056,
    83493170,
    98610923,
    112372819,
    125603078,
    123925438
)
*/
