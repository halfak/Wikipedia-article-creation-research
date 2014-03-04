source("loader/allwiki_monthly_page_status.R")

wiki_namespace_month = load_allwiki_monthly_page_status(reload=T)

wnm.post_2008 = wiki_namespace_month[
	month_created >= "2008-01-01" & 
	(wiki != "enwiki" | experience_type != "anon"),
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

plot_trends = function(wiki_db){
	g = ggplot(
		wnm.post_2008[page_namespace == 0 & wiki == wiki_db,],
		aes(
			x=month_created,
			y=surviving.prop,
			fill=experience_type
		)
	) + 
	geom_point(size=1, aes(color=experience_type)) + 
	stat_smooth(method="lm", color="black") + 
	scale_x_date(
		"Article creation month"
	) + 
	scale_y_continuous("Surviving proportion") + 
	scale_fill_discrete("Experience level") +
	scale_color_discrete("Experience level") +
	theme_bw() + 
	theme(
		axis.text.x = element_text(angle = 45, hjust = 1),
		legend.position = "top"
	)
	print(g)
}
plot_trends("dewiki")

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.enwiki.svg",
	height=6,
	width=6)
	plot_trends("enwiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.ptwiki.svg",
	height=6,
	width=6)
	plot_trends("ptwiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.dewiki.svg",
	height=6,
	width=6)
	plot_trends("dewiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.plwiki.svg",
	height=6,
	width=6)
	plot_trends("plwiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.eswiki.svg",
	height=6,
	width=6)
	plot_trends("eswiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.frwiki.svg",
	height=6,
	width=6)
	plot_trends("frwiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.ruwiki.svg",
	height=6,
	width=6)
	plot_trends("ruwiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.jawiki.svg",
	height=6,
	width=6)
	plot_trends("jawiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.zhwiki.svg",
	height=6,
	width=6)
	plot_trends("zhwiki")
dev.off()

svg("allwiki/plots/trends/survival_proportion.articles.over_time.lm.itwiki.svg",
	height=6,
	width=6)
	plot_trends("itwiki")
dev.off()
