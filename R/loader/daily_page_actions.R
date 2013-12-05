source("env.R")
source("util.R")

load_daily_page_actions = tsv_loader(
	paste(DATA_DIR, "daily_page_actions.tsv", sep="/"),
	"DAILY_PAGE_ACTIONS"
)
