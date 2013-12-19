source("env.R")
source("util.R")

load_enwiki_monthly_page_status = tsv_loader(
	paste(DATA_DIR, "enwiki/monthly_page_status.tsv", sep="/"),
	"ENWIKI_MONTHLY_PAGE_STATUS",
	clean.monthly_creations
)
