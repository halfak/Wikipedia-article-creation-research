source("env.R")
source("util.R")

load_dewiki_monthly_page_status = tsv_loader(
	paste(DATA_DIR, "dewiki/monthly_page_status.tsv", sep="/"),
	"DEWIKI_MONTHLY_PAGE_STATUS",
	clean.monthly_creations
)
