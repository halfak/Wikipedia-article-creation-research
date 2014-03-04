source("loader/allwiki_monthly_page_status.R")

wiki_namespace_month = load_allwiki_monthly_page_status(reload=T)

################################################################################
#     Just last month
################################################################################

wnm.last_month.articles = wiki_namespace_month[
	month_created == "2013-10-01" & 
	page_namespace == 0 & 
	(wiki != "enwiki" | experience_type != "anon"),
	list(
		all = sum(pages),
		creators = sum(page_creators),
		surviving = sum(pages) - sum(archived_quickly),
		archived = sum(archived_quickly),
		survival.prop = round((sum(pages) - sum(archived_quickly)) / sum(pages), 3)
	),
	list(
		wiki,
		experience_type
	)
]
wnm.last_month.articles[order(wnm.last_month.articles$wiki, wnm.last_month.articles$experience_type),]

wnm.last_month.articles.normalized = with(
	wnm.last_month.articles,
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


wnm.last_month.articles.totals = wnm.last_month.articles[,
	list(
		total.articles=sum(all),
		total.creators=sum(creators)
	),
	list(
		wiki
	)
]
wnm.last_month.articles.with_totals = merge(
	wnm.last_month.articles,
	wnm.last_month.articles.totals,
	by="wiki"
)
wnm.last_month.articles.with_totals$creation.prop = with(
	wnm.last_month.articles.with_totals,
	round(all/total.articles, 3)
)
wnm.last_month.articles.with_totals$creator.prop = with(
	wnm.last_month.articles.with_totals,
	round(creators/total.creators, 3)
)
wiki.table(wnm.last_month.articles.with_totals[
	order(wiki, factor(experience_type, levels=c("anon", "-day", "day-week", "week-month", "month-", "autocreate"))),
	list(
		wiki, 
		exp=experience_type, 
		creators,
		cr.perc=round(creator.prop*100, 3),
		articles=all,
		cn.perc=round(creation.prop*100, 3),
		surv=surviving, 
		surv.perc = round(survival.prop*100, 3)
	)
])
svg("allwiki/plots/barplots/article_survival.by_experience_type.allwikis.svg",
	height=3,
	width=12)
ggplot(
	wnm.last_month.articles.with_totals,
	aes(
		x=factor(experience_type, levels=c("anon", "-day", "day-week", "week-month", "month-", "autocreate")),
		y=survival.prop
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
facet_wrap(~ wiki, ncol=10)
dev.off()

svg("allwiki/plots/barplots/article_creation_prop.by_experience_type.allwikis.svg",
	height=3,
	width=12)
ggplot(
	wnm.last_month.articles.with_totals,
	aes(
		x=factor(experience_type, levels=c("anon", "-day", "day-week", "week-month", "month-", "autocreate")),
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
facet_wrap(~ wiki, ncol=10)
dev.off()


svg("allwiki/plots/barplots/article_creators.by_experience_type.allwikis.svg",
	height=3,
	width=12)
ggplot(
	wnm.last_month.articles.with_totals,
	aes(
		x=factor(experience_type, levels=c("anon", "-day", "day-week", "week-month", "month-", "autocreate")),
		y=creators
	)
) + 
geom_bar(
	stat="identity",
	color="black",
	fill="#CCCCCC"
) + 
scale_x_discrete("Experience level") + 
scale_y_continuous("Article creators") + 
theme_bw() +
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ wiki, ncol=10)
dev.off()


svg("allwiki/plots/barplots/article_creator_prop.by_experience_type.allwikis.svg",
	height=3,
	width=12)
ggplot(
	wnm.last_month.articles.with_totals,
	aes(
		x=factor(experience_type, levels=c("anon", "-day", "day-week", "week-month", "month-", "autocreate")),
		y=creator.prop
	)
) + 
geom_bar(
	stat="identity",
	color="black",
	fill="#CCCCCC"
) + 
scale_x_discrete("Experience level") + 
scale_y_continuous("Article creator proportion") + 
theme_bw() +
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ wiki, ncol=10)
dev.off()



wnm.last_month.articles.with_totals[
	experience_type == "anon",
	list(
		wiki, 
		experience_type,
		creation.prop,
		survival.prop
	)
]
