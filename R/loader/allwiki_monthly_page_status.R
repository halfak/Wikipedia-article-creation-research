source("loader/otherwiki_monthly_page_status.R")
source("loader/enwiki_monthly_page_status.R")

load_allwiki_monthly_page_status = data_loader(
	function(){
		otherwiki = load_otherwiki_monthly_page_status(reload=T)
		enwiki = load_monthly_page_status(reload=T)
		enwiki$wiki = "enwiki"
		rbind(otherwiki, enwiki)
	},
	"ALLWIKI_MONTHLY_PAGE_STATUS"





