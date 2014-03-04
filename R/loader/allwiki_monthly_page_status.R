source("loader/otherwiki/monthly_page_status.R")
source("loader/enwiki/monthly_page_status.R")
source("loader/dewiki/monthly_page_status.R")

load_allwiki_monthly_page_status = data_loader(
	function(verbose=T, reload=F){
		otherwiki = load_otherwiki_monthly_page_status(reload=reload)
		enwiki = load_enwiki_monthly_page_status(reload=reload)
		enwiki$wiki = "enwiki"
		dewiki = load_dewiki_monthly_page_status(reload=reload)
		dewiki$wiki = "dewiki"
		if(verbose){cat("Binding enwiki & dewiki to other wikis...")}
		dt = rbind(
			otherwiki, 
			enwiki, 
			dewiki
		)
		dt$experience_type = factor(
			sapply(
				dt$experience_type,
				function(et){
					if(et == "autocreate"){
						"autocreate"
					}else if(et == "anon"){
						"anon"
					}else if(et == "day"){
						"-day"
					}else if(et == "week"){
						"day-week"
					}else if(et == "month"){
						"week-month"
					}else if(et == "oldtimer"){
						"month-"
					}
				}
			),
			c("anon", "-day", "day-week", "week-month", "month-", "autocreate")
		)
		if(verbose){cat("DONE!\n")}
		dt
	},
	"ALLWIKI_MONTHLY_PAGE_STATUS"
)





