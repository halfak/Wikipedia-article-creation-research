source("loader/enwiki/monthly_article_page_status.R")
source("loader/monthly_new_editor_article_creators.R")

new_editor.months = load_monthly_new_editor_article_creators(reload=T)
new_editor.months$registration_month = as.Date(new_editor.months$registration_month)

article.months = load_monthly_article_page_status.enwiki(reload=T)
article.months$month_published = as.Date(article.months$month_published)
article.months$articles_unpublished_quickly = sapply(
	article.months$articles_unpublished_quickly,
	function(x){
		if(is.na(x)){
			0
		}else{
			x
		}
	}
)
article.months$surviving_articles = with(
	article.months,
	articles_published-articles_unpublished_quickly
)

new_article.months = article.months[
	(
		is.na(creator_type) | 
		creator_type == "self-created"
	) & (
		creator_tenure == "-day" | 
		creator_tenure == "day-week" | 
		creator_tenure == "week-month"
	),
	list(
		surviving_articles = sum(surviving_articles),
		surviving_draft_articles = sum(surviving_articles * (original_namespace != 0))
	),
	by=list(month_published)
]

months = merge(
	new_editor.months[
		wiki=="enwiki",
		list(
			month = registration_month,
			new_editors,
			new_page_creators
		),
	],
	new_article.months[,
		list(
			month = month_published,
			surviving_articles
		),
	],
	by="month"
)

months$surviving_articles_per_editor = with(
	months,
	surviving_articles/new_editors
)

months$surviving_articles_per_page_creators = with(
	months,
	surviving_articles/new_page_creators
)

months$pre_afc = with(
	months,
	factor(
		ifor(month <= "2010-02-01", "Pre-AFC", "Post-AFC"), 
		levels=c("Pre-AFC", "Post-AFC")
	)
)


svg("article_pages/plots/surviving_articles/surviving_articles_per_newcomer.by_month.enwiki.svg",
	height=3,
	width=7)
ggplot(
	months[month <= "2013-10-01",],
	aes(
		x=month,
		y=surviving_articles_per_editor
	)
) + 
scale_y_continuous("Surviving articles/new editors", limits=c(0,.175)) +
geom_point(size=1) + 
stat_smooth() + 
theme_bw()
dev.off()


svg("article_pages/plots/surviving_articles/surviving_articles_per_new_page_creator.by_month.enwiki.svg",
	height=3.5,
	width=7)
ggplot(
	months[month <= "2013-10-01",],
	aes(
		x=month,
		y=surviving_articles_per_page_creators,
		group=pre_afc,
		color=pre_afc,
		fill=pre_afc
	)
) + 
scale_y_continuous("Surviving articles per new page creator", limits=c(.1, .35)) +
geom_point(size=1) + 
stat_smooth() + 
theme_bw() + 
theme(
	legend.position="top"
) + 
scale_color_discrete("") + 
scale_fill_discrete("")
dev.off()
