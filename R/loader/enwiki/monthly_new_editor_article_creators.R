source("env.R")
source("util.R")

load_monthly_new_editor_article_creators.enwiki = tsv_loader(
	paste(DATA_DIR, "enwiki/monthly_new_editor_article_creators.tsv", sep="/"),
	"ENWIKI_MONTHLY_NEW_EDITOR_ARTICLE_CREATORS"
)
