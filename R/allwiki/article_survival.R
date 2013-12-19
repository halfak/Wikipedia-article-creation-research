source("loader/allwiki_monthly_page_status.R")

wiki_namespace_month = load_allwiki_monthly_page_status(reload=T)

wnm.post_2008 = wiki_namespace_month[
	month_created >= "2008-01-01",
	list(
		n = sum(pages),
		surviving.k = sum(pages) - sum(archived_quickly)
	),
	list(
		wiki,
		month_created,
		page_namespace,
		experience_type
	)
]
wnm.post_2008$surviving.prop = with(
	wnm.post_2008,
	surviving.k/n
)


svg("allwiki/plots/exploration/survival_proportion.articles.lm.svg",
	height=5,
	width=9)
g = ggplot(
	wnm.post_2008[page_namespace==0,],
	aes(
		x=month_created,
		y=surviving.prop
	)
) + 
geom_point(size=1) + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ wiki + experience_type, ncol=6)
print(g)
dev.off()

wmn.post_2008.newbie.articles = wnm.post_2008[
	page_namespace==0 & 
	(
		experience_type == "day" |
		experience_type == "week" |
		experience_type == "month"
	),
]

svg("allwiki/plots/exploration/survival_proportion.articles.lm.enwiki.newbies.svg",
	height=5,
	width=9)
g = ggplot(
	wmn.post_2008.newbie.articles[wiki == "enwiki",],
	aes(
		x=month_created,
		y=surviving.prop
	)
) + 
geom_point(size=1) + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=3)
print(g)
dev.off()

svg("allwiki/plots/exploration/survival_proportion.articles.lm.frwiki.newbies.svg",
	height=5,
	width=9)
g = ggplot(
	wmn.post_2008.newbie.articles[wiki == "frwiki",],
	aes(
		x=month_created,
		y=surviving.prop
	)
) + 
geom_point(size=1) + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=3)
print(g)
dev.off()

svg("allwiki/plots/exploration/survival_proportion.articles.lm.eswiki.newbies.svg",
	height=5,
	width=9)
g = ggplot(
	wmn.post_2008.newbie.articles[wiki == "eswiki",],
	aes(
		x=month_created,
		y=surviving.prop
	)
) + 
geom_point(size=1) + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=3)
print(g)
dev.off()

svg("allwiki/plots/exploration/survival_proportion.articles.lm.ruwiki.newbies.svg",
	height=5,
	width=9)
g = ggplot(
	wmn.post_2008.newbie.articles[wiki == "ruwiki",],
	aes(
		x=month_created,
		y=surviving.prop
	)
) + 
geom_point(size=1) + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=3)
print(g)
dev.off()