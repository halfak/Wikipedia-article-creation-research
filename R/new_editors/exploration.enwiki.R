source("loader/monthly_new_editor_article_creators.R")

months = load_monthly_new_editor_article_creators(reload=T)
months$registration_month = as.Date(months$registration_month)

normalized.relative.funnel = rbind(
	months[,
		list(
			wiki,
			registration_month,
			transition = "New editors / Registered users",
			prop = new_editors / registered_users
		),
	],
	months[,
		list(
			wiki, 
			registration_month,
			transition = "Page creators / New editors",
			prop = new_page_creators / new_editors
		),
	],
	months[,
		list(
			wiki, 
			registration_month,
			transition = "Article page publishers / Page creators",
			prop = new_article_creators / new_page_creators
		),
	],
	months[,
		list(
			wiki, 
			registration_month,
			transition = "Draft article publishers / Article page publishers",
			prop = new_draft_creators / new_article_creators
		),
	]
)
normalized.relative.funnel$transition = factor(
	normalized.relative.funnel$transition,
	levels = c(
		"New editors / Registered users",
		"Page creators / New editors",
		"Article page publishers / Page creators",
		"Draft article publishers / Article page publishers"
	)
)

svg("new_editors/plots/relative.funnel_props.enwiki.svg",
	width=7,
	height=7)
ggplot(
	normalized.relative.funnel[
		registration_month < "2013-11-01" & 
		wiki == "enwiki",
	],
	aes(
		x=registration_month,
		y=prop
	)
) + 
facet_wrap(~ transition, ncol=1) + 
geom_bar(fill="#CCCCCC", color="black", stat="identity") + 
scale_y_continuous("Proportion of new editors") + 
scale_x_date("Registration month") + 
theme_bw()
dev.off()

svg("new_editors/plots/new_editors.counts.enwiki.svg",
	width=7,
	height=2)
ggplot(
	months[
		registration_month < "2013-11-01" & 
		wiki == "enwiki",
	],
	aes(
		x=registration_month,
		y=new_editors
	)
) + 
geom_bar(fill="#CCCCCC", color="black", stat="identity") + 
scale_y_continuous("New editors") + 
scale_x_date("Registration month") + 
theme_bw()
dev.off()

svg("new_editors/plots/new_page_creators.counts.enwiki.svg",
	width=7,
	height=2)
ggplot(
	months[
		registration_month < "2013-11-01" & 
		wiki == "enwiki",
	],
	aes(
		x=registration_month,
		y=new_page_creators
	)
) + 
geom_bar(fill="#CCCCCC", color="black", stat="identity") + 
scale_y_continuous("New page creators") + 
scale_x_date("Registration month") + 
theme_bw()
dev.off()

svg("new_editors/plots/new_article_creators.counts.enwiki.svg",
	width=7,
	height=2)
ggplot(
	months[
		registration_month < "2013-11-01" & 
		wiki == "enwiki",
	],
	aes(
		x=registration_month,
		y=new_article_creators
	)
) + 
geom_bar(fill="#CCCCCC", color="black", stat="identity") + 
scale_y_continuous("New article creators") + 
scale_x_date("Registration month") + 
theme_bw()
dev.off()

svg("new_editors/plots/new_draft_creators.counts.enwiki.svg",
	width=7,
	height=2)
ggplot(
	months[
		registration_month < "2013-11-01" & 
		wiki == "enwiki",
	],
	aes(
		x=registration_month,
		y=new_draft_creators
	)
) + 
geom_bar(fill="#CCCCCC", color="black", stat="identity") + 
scale_y_continuous("New draft creators") + 
scale_x_date("Registration month") + 
theme_bw()
dev.off()
