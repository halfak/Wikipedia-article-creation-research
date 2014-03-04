dbs1 = mysql -h db1047.eqiad.wmnet
dbs5 = mysql --defaults-file=~/.my.research.cnf -h s5-analytics-slave.eqiad.wmnet -u research
dbs5import = mysqlimport --defaults-file=~/.my.research.cnf -h s5-analytics-slave.eqiad.wmnet -u research


################################################################################
#                      English Wikipedia
################################################################################
#datasets/enwiki/pages.table: sql/enwiki/pages.table.sql
#	cat sql/enwiki/pages.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/enwiki/pages.table
	
#datasets/enwiki/creations.table: datasets/enwiki/pages.table \
#                                        sql/enwiki/creations.table.sql
#	cat sql/enwiki/creations.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/creations.table
	
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
	
############################### Moves ##########################################
#datasets/enwiki/moves.no_header.tsv: datasets/enwiki/move_revisions.table \
#                                     ac/extract_moves.py \
#                                     ac/namespaces.py
#	mysql -h db1047.eqiad.wmnet enwiki -e "SELECT * FROM halfak.nov13_move_revision" | \
#	./extract_moves ".*moved .*\\[\\[(?P<from>[^\\]]+)\\]\\] to \\[\\[(?P<to>[^\]]+)\\]\\].*:(?P<comment>.*)" > \
#	datasets/enwiki/moves.no_header.tsv

#datasets/enwiki/moves.create.table: sql/enwiki/moves.create.table.sql
#	cat sql/enwiki/moves.create.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/enwiki/moves.create.table

#datasets/enwiki/moves.table: datasets/enwiki/moves.create.table \
#                             datasets/enwiki/moves.no_header.tsv
#	ln -s -f moves.no_header.tsv datasets/enwiki/nov13_move.enwiki && \
#	mysql -h db1047.eqiad.wmnet halfak -e "TRUNCATE TABLE halfak.nov13_move" && \
#	mysqlimport -h db1047.eqiad.wmnet --local halfak datasets/enwiki/nov13_move.enwiki && \
#	rm datasets/enwiki/nov13_move.enwiki && \
#	mysql -h db1047.eqiad.wmnet halfak -e "SELECT NOW() as generated, COUNT(*) FROM halfak.nov13_move" > \
#	datasets/enwiki/moves.table

#datasets/enwiki/page_origin.table: datasets/enwiki/moves.table
#	cat sql/enwiki/page_origin.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/enwiki/page_origin.table

#datasets/enwiki/article_pages.table: datasets/enwiki/moves.table \
#                                    datasets/enwiki/page_origin.table \
#                                    sql/enwiki/article_pages.table.sql \
#	cat sql/enwiki/article_pages.table.sql | \
#	mysql -h db1047.eqiad.wmnet enwiki > \
#	datasets/enwiki/article_pages.table

################################ Monthly stats #################################
	
datasets/enwiki/monthly_page_status.tsv: sql/enwiki/monthly_page_status.sql \
                                         datasets/enwiki/pages.table \
                                         datasets/enwiki/creations.table
	cat sql/enwiki/monthly_page_status.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/monthly_page_status.tsv

datasets/enwiki/monthly_article_or_draft_status.tsv: \
       datasets/enwiki/pages.table \
       datasets/enwiki/creations.table \
       datasets/enwiki/user_stats.table \
       datasets/enwiki/afc_draft_status.table
	cat sql/enwiki/monthly_article_or_draft_status.sql | \
	mysql -h db1047.eqiad.wmnet halfak > \
	datasets/enwiki/monthly_article_or_draft_status.tsv

datasets/enwiki/monthly_article_page_status.tsv: datasets/enwiki/article_pages.table
	cat sql/enwiki/monthly_article_page_status.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/monthly_article_page_status.tsv

datasets/enwiki/monthly_new_editor_article_creators.tsv: sql/enwiki/monthly_new_editor_article_creators.sql \
                                                         datasets/enwiki/article_pages.table \
                                                         datasets/enwiki/creations.table
	cat sql/enwiki/monthly_new_editor_article_creators.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/monthly_new_editor_article_creators.tsv

datasets/enwiki/monthly_afc_draft_count.tsv: sql/enwiki/monthly_afc_draft_count.sql \
                                                         datasets/enwiki/page_origin.table \
                                                         datasets/enwiki/creations.table \
                                                         datasets/enwiki/user_stats.table
	cat sql/enwiki/monthly_afc_draft_count.sql | \
	mysql -h db1047.eqiad.wmnet enwiki > \
	datasets/enwiki/monthly_afc_draft_count.tsv
	



################################################################################
#                            German Wikipedia
################################################################################

#datasets/dewiki/pages.table: sql/dewiki/pages.table.sql
#	cat sql/dewiki/pages.table.sql | \
#	$(dbs5) dewiki > \
#	datasets/dewiki/pages.table

#datasets/dewiki/creations.table: datasets/dewiki/pages.table \
#                                 sql/dewiki/creations.table.sql
#	cat sql/dewiki/creations.table.sql | \
#	$(dbs5) dewiki > \
#	datasets/dewiki/creations.table

#datasets/dewiki/user_stats.table: sql/dewiki/user_stats.table.sql \
#                                  datasets/dewiki/creations.table
#	cat sql/dewiki/user_stats.table.sql | \
#	$(dbs5) dewiki > \
#	datasets/dewiki/user_stats.table
	
############################### Moves ##########################################

datasets/dewiki/move_revisions.table: sql/dewiki/move_revisions.table.sql
	cat sql/dewiki/move_revisions.table.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/move_revisions.table

datasets/dewiki/moves.no_header.tsv: datasets/dewiki/move_revisions.table \
                                     ac/extract_moves.py \
                                     ac/namespaces.py
	$(dbs5) dewiki -e "SELECT * FROM staging.nov13_dewiki_move_revision" | \
	./extract_moves ".*(hat „|verschob „|verschob Seite |verschob die Seite )\\[\\[(?P<from>[^\]]+)\\]\\](“)? nach („)?\\[\\[(?P<to>[^\]]+)\\]\\](“)?(?P<comment>.*)" --lang=de > \
	datasets/dewiki/moves.no_header.tsv

datasets/dewiki/moves.create.table: sql/dewiki/moves.create.table.sql
	cat sql/dewiki/moves.create.table.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/moves.create.table

datasets/dewiki/moves.table: datasets/dewiki/moves.create.table \
                             datasets/dewiki/moves.no_header.tsv
	ln -s -f moves.no_header.tsv datasets/dewiki/nov13_dewiki_move && \
	$(dbs5) dewiki -e "TRUNCATE TABLE staging.nov13_dewiki_move" && \
	$(dbs5import) --local staging datasets/dewiki/nov13_dewiki_move && \
	rm datasets/dewiki/nov13_dewiki_move && \
	$(dbs5) dewiki -e "SELECT NOW() as generated, COUNT(*) FROM staging.nov13_dewiki_move" > \
	datasets/dewiki/moves.table

datasets/dewiki/page_origin.table: datasets/dewiki/moves.table \
                                   datasets/dewiki/pages.table
	cat sql/dewiki/page_origin.table.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/page_origin.table

datasets/dewiki/article_pages.table: datasets/dewiki/moves.table \
                                    datasets/dewiki/page_origin.table \
                                    sql/dewiki/article_pages.table.sql
	cat sql/dewiki/article_pages.table.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/article_pages.table


################################ Monthly stats #################################	
datasets/dewiki/monthly_page_status.tsv: sql/dewiki/monthly_page_status.sql \
                                         datasets/dewiki/pages.table \
                                         datasets/dewiki/creations.table
	cat sql/dewiki/monthly_page_status.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/monthly_page_status.tsv

datasets/dewiki/monthly_article_page_status.tsv: datasets/dewiki/creations.table \
                                                 datasets/dewiki/user_stats.table \
                                                 datasets/dewiki/article_pages.table
	cat sql/dewiki/monthly_article_page_status.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/monthly_article_page_status.tsv

datasets/dewiki/monthly_new_editor_article_creators.tsv: sql/dewiki/monthly_new_editor_article_creators.sql \
                                                         datasets/dewiki/article_pages.table \
                                                         datasets/dewiki/creations.table
	cat sql/dewiki/monthly_new_editor_article_creators.sql | \
	$(dbs5) dewiki > \
	datasets/dewiki/monthly_new_editor_article_creators.tsv



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

################################################################################ jawiki
datasets/otherwiki/jawiki.page_status.table: datasets/otherwiki/page_status.table \
                                                     datasets/otherwiki/jawiki.page_status.no_headers.tsv
	ln -s -f jawiki.page_status.no_headers.tsv datasets/otherwiki/nov13_otherwiki_page_status.jawiki && \
	mysql -h db1047.eqiad.wmnet halfak -e 'DELETE FROM nov13_otherwiki_page_status WHERE wiki="jawiki";' && \
	mysqlimport --local -h db1047.eqiad.wmnet halfak datasets/otherwiki/nov13_otherwiki_page_status.jawiki > \
	datasets/otherwiki/jawiki.page_status.table && \
	rm datasets/otherwiki/nov13_otherwiki_page_status.jawiki
	
datasets/otherwiki/jawiki.page_status.no_headers.tsv: sql/otherwiki/page_status.sql
	cat sql/otherwiki/page_status.sql | \
	mysql --defaults-file=${HOME}/.my.research.cnf -u research -h s6-analytics-slave.eqiad.wmnet --skip-column-names jawiki > \
	datasets/otherwiki/jawiki.page_status.no_headers.tsv
