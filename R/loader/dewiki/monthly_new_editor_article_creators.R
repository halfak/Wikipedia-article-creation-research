source("env.R")
source("util.R")

load_monthly_new_editor_article_creators.dewiki = tsv_loader(
	paste(DATA_DIR, "dewiki/monthly_new_editor_article_creators.tsv", sep="/"),
	"DEWIKI_MONTHLY_NEW_EDITOR_ARTICLE_CREATORS"
)
