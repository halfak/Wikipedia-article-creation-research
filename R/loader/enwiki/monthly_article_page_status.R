source("env.R")
source("util.R")

load_monthly_article_page_status.enwiki = tsv_loader(
	paste(DATA_DIR, "enwiki/monthly_article_page_status.tsv", sep="/"),
	"ENWIKI_MONTHLY_ARTICLE_PAGE_STATUS"
)
