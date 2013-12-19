source("env.R")
source("util.R")

load_enwiki_monthly_article_or_draft_status = tsv_loader(
	paste(DATA_DIR, "enwiki/monthly_article_or_draft_status.tsv", sep="/"),
	"ENWIKI_MONTHLY_ARTICLE_STATUS",
	clean.monthly_creations
)
