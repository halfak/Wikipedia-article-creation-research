source("env.R")
source("util.R")

load_otherwiki_monthly_page_status = tsv_loader(
	paste(DATA_DIR, "otherwiki/monthly_page_status.tsv", sep="/"),
	"OTHERWIKI_MONTHLTY_PAGE_STATUS",
	clean.monthly_creations
)
