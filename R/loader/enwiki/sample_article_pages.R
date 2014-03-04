source("env.R")
source("util.R")

load_sample_article_pages = tsv_loader(
	paste(DATA_DIR, "enwiki/sample_article_pages.tsv", sep="/"),
	"SAMPLE_ARTICLE_PAGES"
)
