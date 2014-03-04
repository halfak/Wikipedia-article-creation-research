source("env.R")
source("util.R")

load_monthly_afc_draft_count = tsv_loader(
	paste(DATA_DIR, "enwiki/monthly_afc_draft_count.tsv", sep="/"),
	"MONTHLY_AFC_DRAFT_COUNT",
	function(d){
		d$month_created = as.Date(d$month_created)
		
		d
	}
)
