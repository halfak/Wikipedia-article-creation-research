source("loader/otherwiki/monthly_page_status.R")
source("loader/enwiki/monthly_page_status.R")

load_allwiki_monthly_page_status = data_loader(
	function(verbose=T, reload=F){
		otherwiki = load_otherwiki_monthly_page_status(reload=T)
		enwiki = load_enwiki_monthly_page_status(reload=T)
		enwiki$wiki = "enwiki"
		if(verbose){cat("Binding enwiki to other wikis...")}
		dt = rbind(otherwiki, enwiki)
		dt$experience_type = factor(
			dt$experience_type,
			c("day", "week", "month", "oldtimer", "anon", "autocreate")
		)
		if(verbose){cat("DONE!\n")}
		dt
	},
	"ALLWIKI_MONTHLY_PAGE_STATUS"
)





