source("loader/enwiki/monthly_article_page_status.R")

monthly_status = load_monthly_article_page_status(reload=T)

monthly_status$successful_articles = with(
	monthly_status,
	articles_published-articles_unpublished_quickly
)
monthly_status$month_published = as.Date(monthly_status$month_published)
monthly_status$survival_prop = with(
	monthly_status,
	successful_articles/articles_published
)

monthly_status$survival_prop.se = with(
	monthly_status,
	sqrt(survival_prop*(1-survival_prop)/articles_published)
)
monthly_status$creator_tenure = factor(
	monthly_status$creator_tenure,
	c('-day', 'day-week', 'week-month', 'month-')
)

svg("article_pages/plots/exploration/survival_prop.smoother.by_original_namespace_and_tenure.svg",
	height=5,
	width=13)
ggplot(
	monthly_status[
		articles_published >= 25 & 
		creator_type == "self-created" & 
		!is.na(creator_tenure) & 
		month_published > "2008-01-01" & (
			original_namespace == 0 | 
			original_namespace == 2 | 
			original_namespace == 5 
		),
	],
	aes(
		x=month_published,
		y=survival_prop,
		group=as.factor(original_namespace),
		linetype=as.factor(original_namespace)
	)
) + 
geom_point() + 
stat_smooth(color="black") + 
scale_linetype_discrete("Original namespace") + 
facet_wrap(~ creator_tenure, ncol=4) + 
theme_bw() + 
theme(legend.position="top", legend.direction="horizontal")
dev.off()