source("env.R")
source("util.R")

load_monthly_article_page_status.dewiki = tsv_loader(
	paste(DATA_DIR, "dewiki/monthly_article_page_status.tsv", sep="/"),
	"DEWIKI_MONTHLY_ARTICLE_PAGE_STATUS"
)
