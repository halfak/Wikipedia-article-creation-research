source("env.R")
source("util.R")

load_monthly_article_page_status = tsv_loader(
	paste(DATA_DIR, "enwiki/monthly_article_page_status.tsv", sep="/"),
	"monthly_article_page_status"
)
