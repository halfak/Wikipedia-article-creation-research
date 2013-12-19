

################################################################################
#                      English Wikipedia
################################################################################
#datasets/enwiki/pages.table: sql/enwiki/pages.table.sql
#	cat sql/enwiki/pages.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/enwiki/pages.table
	
datasets/enwiki/sample_deleted_pages.table: sql/enwiki/sample_deleted_pages.table.sql
	cat sql/enwiki/sample_deleted_pages.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/sample_deleted_pages.table
	
#datasets/enwiki/enwiki/creations.table: datasets/enwiki/pages.table \
#                                        sql/enwiki/creations.table.sql
#	cat sql/creations.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/creations.table

datasets/enwiki/curation_actions.table: sql/enwiki/curation_actions.table.sql
	cat sql/enwiki/curation_actions.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/curation_actions.table
	
datasets/enwiki/deletions.table: sql/enwiki/deletions.table.sql
	cat sql/enwiki/deletions.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/deletions.table
	
datasets/enwiki/restorations.table: sql/enwiki/restorations.table.sql
	cat sql/enwiki/restorations.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/restorations.table
	
#datasets/enwiki/user_stats.table: sql/enwiki/user_stats.table.sql \
#                                  datasets/enwiki/creations.table
#	cat sql/enwiki/user_stats.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/enwiki/user_stats.table
	
datasets/enwiki/move_revisions.table: sql/enwiki/move_revisions.table.sql
	cat sql/enwiki/move_revisions.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/move_revisions.table
	
datasets/enwiki/afc_draft_status.table: sql/enwiki/afc_draft_status.table.sql \
                                        datasets/enwiki/pages.table
	cat sql/enwiki/afc_draft_status.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/afc_draft_status.table
	
datasets/enwiki/daily_page_status.tsv: sql/enwiki/daily_page_status.sql \
                                       datasets/enwiki/pages.table \
                                       datasets/enwiki/creations.table
	cat sql/enwiki/daily_page_status.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/daily_page_status.tsv
	
datasets/enwiki/monthly_page_status.tsv: sql/enwiki/monthly_page_status.sql \
                                         datasets/enwiki/pages.table \
                                         datasets/enwiki/creations.table
	cat sql/enwiki/monthly_page_status.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/monthly_page_status.tsv
	
datasets/enwiki/daily_page_actions.tsv: sql/enwiki/daily_page_actions.sql \
                                        datasets/enwiki/creations.table \
                                        datasets/enwiki/deletions.table \
                                        datasets/enwiki/restorations.table
	cat sql/enwiki/daily_page_actions.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/daily_page_actions.tsv
	
datasets/enwiki/daily_curation_stats.tsv: sql/enwiki/daily_curation_stats.sql \
                                   datasets/enwiki/creations.table \
                                   datasets/enwiki/curation_actions.table
	cat sql/enwiki/daily_curation_stats.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/daily_curation_stats.tsv

datasets/enwiki/sample_deleted_pages.tsv: datasets/enwiki/sample_deleted_pages.table
	cat sql/enwiki/sample_deleted_pages.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/sample_deleted_pages.tsv

datasets/enwiki/monthly_article_or_draft_status.tsv: \
       datasets/enwiki/pages.table \
       datasets/enwiki/creations.table \
       datasets/enwiki/user_stats.table \
       datasets/enwiki/afc_draft_status.table
	cat sql/enwiki/monthly_article_or_draft_status.sql | \
	mysql -h db1047.eqiad.wmnet halfak > \
	datasets/enwiki/monthly_article_or_draft_status.tsv

datasets/enwiki/moves.no_header.tsv: datasets/enwiki/move_revisions.table \
                                     ac/extract_moves.py \
                                     ac/namespaces.py
	mysql -h db1047.eqiad.wmnet halfak -e "SELECT * FROM nov13_move_revision" | \
	./extract_moves > \
	datasets/enwiki/moves.no_header.tsv

datasets/enwiki/moves.create.table: sql/enwiki/moves.create.table.sql
	cat sql/enwiki/moves.create.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/moves.create.table

datasets/enwiki/moves.table: datasets/enwiki/moves.create.table \
                             datasets/enwiki/moves.no_header.tsv
	ln -s -f moves.no_header.tsv datasets/enwiki/nov13_move.enwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e "TRUNCATE TABLE halfak.nov13_move" && \
	mysqlimport -h db1047.eqiad.wmnet --local halfak datasets/enwiki/nov13_move.enwiki && \
	rm datasets/enwiki/nov13_move.enwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e "SELECT NOW() as generated, COUNT(*) FROM halfak.nov13_move" > \
	datasets/enwiki/moves.table

datasets/enwiki/page_origin.table: datasets/enwiki/moves.table
	cat sql/enwiki/page_origin.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/page_origin.table

datasets/enwiki/article_pages.table: datasets/enwiki/moves.table \
                                    datasets/enwiki/page_origin.table \
                                    sql/enwiki/article_pages.table.sql
	cat sql/enwiki/article_pages.table.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/article_pages.table

datasets/enwiki/monthly_article_page_status.tsv: datasets/enwiki/article_pages.table
	cat sql/enwiki/monthly_article_page_status.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/monthly_article_page_status.tsv

################################################################################
#                       Other Wikipedias
################################################################################

datasets/otherwiki/page_status.table: sql/otherwiki/page_status.create.sql
	cat sql/otherwiki/page_status.create.sql | \
	mysql -h db1047.eqiad.wmnet halfak > \
	datasets/otherwiki/page_status.table

datasets/otherwiki/monthly_page_status.tsv: datasets/otherwiki/page_status.table \
                                                    sql/otherwiki/monthly_page_status.sql
	cat sql/otherwiki/monthly_page_status.sql | \
	mysql -h db1047.eqiad.wmnet halfak > \
	datasets/otherwiki/monthly_page_status.tsv

datasets/otherwiki/monthly_article_status.tsv: datasets/otherwiki/page_status.table \
                                                    sql/otherwiki/monthly_article_status.sql
	cat sql/otherwiki/monthly_article_status.sql | \
	mysql -h db1047.eqiad.wmnet halfak > \
	datasets/otherwiki/monthly_article_status.tsv

################################################################################ eswiki
datasets/otherwiki/eswiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/eswiki.page_status.no_headers.tsv
	ln -s -f eswiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.eswiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="eswiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.eswiki > \
	datasets/otherwiki/eswiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.eswiki
	
datasets/otherwiki/eswiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s7-analytics-slave.eqiad.wmnet --skip-column-names eswiki > \
	datasets/otherwiki/eswiki.page_status.no_headers.tsv

################################################################################ ptwiki
datasets/otherwiki/ptwiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/ptwiki.page_status.no_headers.tsv
	ln -s -f ptwiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.ptwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="ptwiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.ptwiki > \
	datasets/otherwiki/ptwiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.ptwiki
	
datasets/otherwiki/ptwiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s2-analytics-slave.eqiad.wmnet --skip-column-names ptwiki > \
	datasets/otherwiki/ptwiki.page_status.no_headers.tsv

################################################################################ dewiki
datasets/otherwiki/dewiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/dewiki.page_status.no_headers.tsv
	ln -s -f dewiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.dewiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="dewiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.dewiki > \
	datasets/otherwiki/dewiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.dewiki
	
datasets/otherwiki/dewiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s5-analytics-slave.eqiad.wmnet --skip-column-names dewiki > \
	datasets/otherwiki/dewiki.page_status.no_headers.tsv

################################################################################ ruwiki
datasets/otherwiki/ruwiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/ruwiki.page_status.no_headers.tsv
	ln -s -f ruwiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.ruwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="ruwiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.ruwiki > \
	datasets/otherwiki/ruwiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.ruwiki
	
datasets/otherwiki/ruwiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s6-analytics-slave.eqiad.wmnet --skip-column-names ruwiki > \
	datasets/otherwiki/ruwiki.page_status.no_headers.tsv

################################################################################ plwiki
datasets/otherwiki/plwiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/plwiki.page_status.no_headers.tsv
	ln -s -f plwiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.plwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="plwiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.plwiki > \
	datasets/otherwiki/plwiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.plwiki
	
datasets/otherwiki/plwiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s2-analytics-slave.eqiad.wmnet --skip-column-names plwiki > \
	datasets/otherwiki/plwiki.page_status.no_headers.tsv

################################################################################ itwiki
datasets/otherwiki/itwiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/itwiki.page_status.no_headers.tsv
	ln -s -f itwiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.itwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="itwiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.itwiki > \
	datasets/otherwiki/itwiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.itwiki
	
datasets/otherwiki/itwiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s2-analytics-slave.eqiad.wmnet --skip-column-names itwiki > \
	datasets/otherwiki/itwiki.page_status.no_headers.tsv

################################################################################ frwiki
datasets/otherwiki/frwiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/frwiki.page_status.no_headers.tsv
	ln -s -f frwiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.frwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="frwiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.frwiki > \
	datasets/otherwiki/frwiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.frwiki
	
datasets/otherwiki/frwiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s6-analytics-slave.eqiad.wmnet --skip-column-names frwiki > \
	datasets/otherwiki/frwiki.page_status.no_headers.tsv

################################################################################ zhwiki
datasets/otherwiki/zhwiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/zhwiki.page_status.no_headers.tsv
	ln -s -f zhwiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.zhwiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="zhwiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.zhwiki > \
	datasets/otherwiki/zhwiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.zhwiki
	
datasets/otherwiki/zhwiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s2-analytics-slave.eqiad.wmnet --skip-column-names zhwiki > \
	datasets/otherwiki/zhwiki.page_status.no_headers.tsv
