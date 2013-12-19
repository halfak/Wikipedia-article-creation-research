source("env.R")
source("util.R")

load_sample_deleted_pages = tsv_loader(
	paste(DATA_DIR, "sample_deleted_pages.tsv", sep="/"),
	"SAMPLE_DELETED_PAGES"
)
