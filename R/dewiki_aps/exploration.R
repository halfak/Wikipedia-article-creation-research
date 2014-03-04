source("loader/dewiki/monthly_article_page_status.R")

monthly_status = load_monthly_article_page_status.dewiki(reload=T)
monthly_status$articles_unpublished_quickly = sapply(
	monthly_status$articles_unpublished_quickly,
	function(x){
		if(is.na(x)){
			0
		}else{
			x
		}
	}
)
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

svg("dewiki_aps/plots/exploration/survival_prop.smoother.by_original_namespace_and_tenure.svg",
	height=5,
	width=13)
ggplot(
	monthly_status[
		articles_published >= 25 & 
		creator_type == "self-created" & 
		!is.na(creator_tenure) & 
		month_published > "2008-01-01" & 
		(original_namespace == 0 | original_namespace == 2) ,
	],
	aes(
		x=month_published,
		y=survival_prop,
		group=as.factor(original_namespace),
		linetype=as.factor(original_namespace),
		shape=as.factor(original_namespace),
		fill=as.factor(original_namespace)
	)
) + 
geom_point(size=1) + 
stat_smooth(color="black") + 
scale_fill_discrete("Original namespace") +
scale_shape_discrete("Original namespace") +
scale_linetype_discrete("Original namespace") + 
facet_wrap(~ creator_tenure, ncol=4) + 
theme_bw() + 
theme(
	legend.position="top", legend.direction="horizontal",
	axis.text.x = element_text(angle = 45, hjust = 1)
)
dev.off()

svg("dewiki_aps/plots/exploration/survival_prop.by_original_namespace_and_tenure.2013-10-01.svg",
	height=5,
	width=13)
ggplot(
	monthly_status[
		articles_published >= 25 & 
		creator_type == "self-created" & 
		!is.na(creator_tenure) & 
		month_published == "2013-10-01",
	],
	aes(
		x=factor(creator_tenure, levels=c("-day", "day-week", "week-month", "month-")),
		y=qbeta(0.5, successful_articles+1, articles_unpublished_quickly+1),
		fill=as.factor(original_namespace)
	)
) + 
geom_bar(
	stat="identity",
	position=position_dodge(.9),
	color="#000000"
) + 
geom_errorbar(
	position=position_dodge(.9),
	aes(
		ymax=qbeta(0.8413447, successful_articles+1, articles_unpublished_quickly+1),
		ymin=qbeta(0.1586553, successful_articles+1, articles_unpublished_quickly+1)
	),
	width=0.25
) + 
scale_fill_discrete("Original namespace") +
scale_y_continuous("Authors") + 
scale_x_discrete("Author tenure") + 
theme_bw() + 
theme(legend.position="top", legend.direction="horizontal")
dev.off()

svg("dewiki_aps/plots/exploration/unique_authors.by_original_namespace_and_tenure.2013-10-01.svg",
	height=5,
	width=13)
ggplot(
	monthly_status[
		articles_published >= 25 & 
		creator_type == "self-created" & 
		!is.na(creator_tenure) & 
		month_published == "2013-10-01",
	],
	aes(
		x=factor(creator_tenure, levels=c("-day", "day-week", "week-month", "month-")),
		y=unique_authors,
		fill=as.factor(original_namespace)
	)
) + 
geom_bar(
	stat="identity",
	position="dodge",
	color="#000000"
) + 
scale_fill_discrete("Original namespace") +
scale_y_continuous("Authors") + 
scale_x_discrete("Author tenure") + 
theme_bw() + 
theme(legend.position="top", legend.direction="horizontal")
dev.off()


svg("dewiki_aps/plots/exploration/articles_published.by_original_namespace_and_tenure.2013-10-01.svg",
	height=5,
	width=13)
ggplot(
	monthly_status[
		articles_published >= 25 & 
		creator_type == "self-created" & 
		!is.na(creator_tenure) & 
		month_published == "2013-10-01",
	],
	aes(
		x=factor(creator_tenure, levels=c("-day", "day-week", "week-month", "month-")),
		y=articles_published,
		fill=as.factor(original_namespace)
	)
) + 
geom_bar(
	stat="identity",
	position="dodge",
	color="#000000"
) + 
scale_fill_discrete("Original namespace") +
scale_y_continuous("Articles published") + 
scale_x_discrete("Author tenure") + 
theme_bw() + 
theme(legend.position="top", legend.direction="horizontal")
dev.off()

