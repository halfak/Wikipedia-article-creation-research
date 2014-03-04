source("loader/enwiki/monthly_new_editor_article_creators.R")
source("loader/dewiki/monthly_new_editor_article_creators.R")

load_monthly_new_editor_article_creators = data_loader(
	function(verbose=T, reload=F){
		enwiki = load_monthly_new_editor_article_creators.enwiki(reload=reload)
		enwiki$wiki = "enwiki"
		dewiki = load_monthly_new_editor_article_creators.dewiki(reload=reload)
		dewiki$wiki = "dewiki"
		
		rbind(
			enwiki,
			dewiki
		)
	},
	"MONTHLY_NEW_EDITOR_ARTICLE_CREATORS"
)