source("loader/enwiki/sample_article_pages.R")

pages = load_sample_article_pages(reload=T)
pages$lifetime = with(
	pages,
	pmax(
		1, 
		as.numeric(as.POSIXlt(as.character(unpublished), format="%Y%m%d%H%M%S")) - 
		as.numeric(as.POSIXlt(as.character(published), format="%Y%m%d%H%M%S"))
	)
)

svg("page_lifetime/plots/draft_diff/lifetime.density.by_year.svg",
	height=7,
	width=7)
ggplot(
	pages,
	aes(
		x = lifetime+1,
		group = as.factor(original_namespace),
		fill = as.factor(original_namespace)
	)
) + 
geom_density(
	alpha=0.2
) + 
theme_bw() + 
scale_x_log10(
	"Lifetime",
	breaks=c(60, 60*60, 24*60*60, 7*24*60*60, 30*24*60*60, 365*24*60*60),
	labels=c("minute", "hour", "day", "week", "month", "year")
) + 
scale_fill_discrete("Original NS") + 
facet_wrap(~ original_namespace, ncol=1)
dev.off()


pages[,
	list(
		median = round(median(lifetime)/(60), 2),
		geo.mean = round(geo.mean.plus.one(lifetime)/(60), 2)
	),
	list(
		original_namespace
	)
]
