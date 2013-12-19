source("loader/enwiki/monthly_article_or_draft_status.R")

mas = load_enwiki_monthly_article_or_draft_status(reload=T)

mas.post_2008.self = mas[
	account_type == "create" & 
	month_created >= "2008-01-01" & 
	month_created <= "2013-04-01",
]

mas.post_2008.self.grouped = mas.post_2008.self[,
	list(
		pages = sum(pages),
		archived_or_stale = sum((archived_quickly*!draft) + (pages*draft))
	),
	list(
		month_created,
		experience_type
	)
]
mas.post_2008.self.grouped$survival.prop = with(
	mas.post_2008.self.grouped,
	(pages-archived_or_stale)/pages
)

svg("articles_and_drafts/plots/exploration/monthly_survival_prop.articles_and_drafts.svg",
	height=5,
	width=9)
g = ggplot(
	mas.post_2008.self.grouped[
		experience_type == "day" |
		experience_type == "week" |
		experience_type == "month"
	],
	aes(
		x=month_created, y=survival.prop
	)
) + 
geom_point(size=1) + 
stat_smooth(method="lm") + 
scale_x_date("Page creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=4)
print(g)
dev.off()