source("loader/sample_deleted_pages.R")

deleted_pages = load_sample_deleted_pages(reload=T)

deleted_pages$first_revision_timestamp = as.numeric(as.POSIXct(
	as.character(deleted_pages$first_revision), 
	format="%Y%m%d%H%M%S"
))
deleted_pages$last_revision_timestamp = as.numeric(as.POSIXct(
	as.character(deleted_pages$last_revision), 
	format="%Y%m%d%H%M%S"
))
deleted_pages$creation_year = as.numeric(substr(as.character(deleted_pages$first_revision), 0, 4))

deleted_pages$lifetime = with(
	deleted_pages,
	last_revision_timestamp - first_revision_timestamp
)

svg("page_lifetime/plots/
g = ggplot(
	deleted_pages[page_namespace==0 & creation_year > 2004,],
	aes(x=log10(lifetime+1))
) + 
geom_density(
	alpha=0.2,
	color="black",
	fill="#cccccc"
) + 
facet_wrap(~ creation_year, ncol=1) + 
theme_bw() + 
scale_x_continuous(
	breaks=log10(c(60, 60*60, 24*60*60, 7*24*60*60, 30*24*60*60, 365*24*60*60)),
	labels=c("minute", "hour", "day", "week", "month", "year")
)
print(g)

