source("env.R")
source("util.R")

load_daily_page_status = tsv_loader(
	paste(DATA_DIR, "daily_page_status.tsv", sep="/"),
	"DAILY_PAGE_STATUS"
)