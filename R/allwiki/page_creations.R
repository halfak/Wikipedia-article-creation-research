source("loader/allwiki_monthly_page_status.R")

wiki_namespace_month = load_allwiki_monthly_page_status(reload=T)

wnm.post_2008.articles = wiki_namespace_month[
	month_created >= "2008-01-01" & 
	month_created <= "2013-10-01" & 
	page_namespace == 0,
	list(
		n = sum(pages),
		surviving.k = sum(pages) - sum(archived_quickly)
	),
	list(
		wiki,
		month_created,
		experience_type
	)
]

wmn.post_2008.normalized = rbind(
	wnm.post_2008.articles[,
		list(
			wiki,
			month_created,
			experience_type,
			group = "all",
			n = n
		),
	],
	wnm.post_2008.articles[,
		list(
			wiki,
			month_created,
			experience_type,
			group = "surviving",
			n = surviving.k
		),
	],
	wnm.post_2008.articles[,
		list(
			wiki,
			month_created,
			experience_type,
			group = "archived",
			n = n-surviving.k
		),
	]
)
wmn.post_2008.month_totals = wmn.post_2008.normalized[,
	list(
		month_total = sum(n)
	),
	list(
		wiki,
		month_created,
		group
	)
]
wmn.post_2008.normalized.with_total = merge(
	wmn.post_2008.normalized,
	wmn.post_2008.month_totals,
	by=c("wiki", "month_created", "group")
)
wmn.post_2008.normalized.with_total$prop = with(
	wmn.post_2008.normalized.with_total,
	n/month_total
)
wmn.post_2008.normalized.with_total$experience_type = factor(
	wmn.post_2008.normalized.with_total$experience_type,
	levels=c("anon", "autocreate", "day", "week", "month", "oldtimer")
)

svg("allwiki/plots/page_creations/monthly_article_creations.by_experience_type.enwiki.svg",
	height=6,
	width=7)
ggplot(
	wmn.post_2008.normalized.with_total[
		wiki == "enwiki",
	],
	aes(
		x=month_created,
		y=prop,
		group=experience_type,
		fill=experience_type,
		order=experience_type
	)
) + 
geom_area(
	color="#000000", 
	size=.2,
	position="stack"
) + 
facet_wrap(~ group, ncol=1) + 
scale_fill_manual(values=c("#000000", "#FFCCCC", "#CCCCCC", "#BBBBBB", "#AAAAAA", "transparent")) + 
theme_bw() + 
scale_y_continuous("Proportion of articles") + 
scale_x_date("Month created")
dev.off()

svg("allwiki/plots/page_creations/monthly_article_creations.by_experience_type.eswiki.svg",
	height=6,
	width=7)
ggplot(
	wmn.post_2008.normalized.with_total[
		wiki == "eswiki",
	],
	aes(
		x=month_created,
		y=prop,
		group=experience_type,
		fill=experience_type,
		order=experience_type
	)
) + 
geom_area(
	color="#000000", 
	size=.2,
	position="stack"
) + 
facet_wrap(~ group, ncol=1) + 
scale_fill_manual(values=c("#000000", "#FFCCCC", "#CCCCCC", "#BBBBBB", "#AAAAAA", "transparent")) + 
theme_bw() + 
scale_y_continuous("Proportion of articles") + 
scale_x_date("Month created")
dev.off()

svg("allwiki/plots/page_creations/monthly_article_creations.by_experience_type.frwiki.svg",
	height=6,
	width=7)
ggplot(
	wmn.post_2008.normalized.with_total[
		wiki == "frwiki",
	],
	aes(
		x=month_created,
		y=prop,
		group=experience_type,
		fill=experience_type,
		order=experience_type
	)
) + 
geom_area(
	color="#000000", 
	size=.2,
	position="stack"
) + 
facet_wrap(~ group, ncol=1) + 
scale_fill_manual(values=c("#000000", "#FFCCCC", "#CCCCCC", "#BBBBBB", "#AAAAAA", "transparent")) + 
theme_bw() + 
scale_y_continuous("Proportion of articles") + 
scale_x_date("Month created")
dev.off()

svg("allwiki/plots/page_creations/monthly_article_creations.by_experience_type.ruwiki.svg",
	height=6,
	width=7)
ggplot(
	wmn.post_2008.normalized.with_total[
		wiki == "ruwiki",
	],
	aes(
		x=month_created,
		y=prop,
		group=experience_type,
		fill=experience_type,
		order=experience_type
	)
) + 
geom_area(
	color="#000000", 
	size=.2,
	position="stack"
) + 
facet_wrap(~ group, ncol=1) + 
scale_fill_manual(values=c("#000000", "#FFCCCC", "#CCCCCC", "#BBBBBB", "#AAAAAA", "transparent")) + 
theme_bw() + 
scale_y_continuous("Proportion of articles") + 
scale_x_date("Month created")
dev.off()

################################################################################
#     Just last year
################################################################################

wnm.last_year.articles = wiki_namespace_month[
	month_created > "2012-10-01" & 
	month_created <= "2013-10-01" & 
	page_namespace == 0 & 
	(wiki != "enwiki" | experience_type != "anon"),
	list(
		all = sum(pages),
		surviving = sum(pages) - sum(archived_quickly),
		archived = sum(archived_quickly),
		survival.prop = round((sum(pages) - sum(archived_quickly)) / sum(pages), 3)
	),
	list(
		wiki,
		experience_type
	)
]
wnm.last_year.articles[order(wmn.last_year.articles$wiki, wmn.last_year.articles$experience_type),]

wnm.last_year.articles.normalized = with(
	wnm.last_year.articles,
	rbind(
		data.table(
			wiki,
			experience_type,
			group="all",
			n=all,
			prop=1
		),
		data.table(
			wiki,
			experience_type,
			group="surviving",
			n=surviving,
			prop=surviving/all
		),
		data.table(
			wiki,
			experience_type,
			group="archived",
			n=archived,
			prop=archived/all
		)
	)
)

svg("allwiki/plots/page_creations/article_survival.by_experience_type.allwikis.svg",
	height=3,
	width=7)
ggplot(
	wnm.last_year.articles.normalized[group == "surviving",],
	aes(
		x=factor(experience_type, levels=c("autocreate", "anon", "day", "week", "month", "oldtimer")),
		y=prop
	)
) + 
geom_bar(
	stat="identity",
	color="black",
	fill="#CCCCCC"
) + 
scale_x_discrete("Experience level") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() +
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ wiki, ncol=4)
dev.off()

wnm.last_year.articles.totals = wnm.last_year.articles[,
	list(
		total=sum(all)
	),
	list(
		wiki
	)
]
wnm.last_year.articles.with_totals = merge(
	wnm.last_year.articles,
	wnm.last_year.articles.totals,
	by="wiki"
)
wnm.last_year.articles.with_totals$creation.prop = with(
	wnm.last_year.articles.with_totals,
	round(all/total, 3)
)
wnm.last_year.articles.with_totals[
	order(wiki, experience_type),
	list(
		wiki, 
		experience_type, 
		articles=all, 
		surviving, 
		survival.prop,
		creation.prop
	)
]

svg("allwiki/plots/page_creations/article_creation_prop.by_experience_type.allwikis.svg",
	height=3,
	width=7)
ggplot(
	wnm.last_year.articles.with_totals,
	aes(
		x=factor(experience_type, levels=c("autocreate", "anon", "day", "week", "month", "oldtimer")),
		y=creation.prop
	)
) + 
geom_bar(
	stat="identity",
	color="black",
	fill="#CCCCCC"
) + 
scale_x_discrete("Experience level") + 
scale_y_continuous("Article creation proportion") + 
theme_bw() +
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ wiki, ncol=4)
dev.off()
