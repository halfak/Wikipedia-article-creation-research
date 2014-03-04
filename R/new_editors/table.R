source("loader/monthly_new_editor_article_creators.R")

months = load_monthly_new_editor_article_creators(reload=T)
months$registration_month = as.Date(months$registration_month)

table_data = rbind(
	months[,
		list(
			wiki,
			registration_month,
			group = "New editors",
			n = new_editors,
			relative.prop = new_editors / registered_users,
			absolute.prop = new_editors / registered_users
		),
	],
	months[,
		list(
			wiki, 
			registration_month,
			group = "New page creators",
			n = new_page_creators,
			relative.prop = new_page_creators / new_editors,
			absolute.prop = new_page_creators / registered_users
		),
	],
	months[,
		list(
			wiki, 
			registration_month,
			group = "New article page publishers",
			n = new_article_creators,
			relative.prop = new_article_creators / new_page_creators,
			absolute.prop = new_article_creators / registered_users
		),
	],
	months[,
		list(
			wiki, 
			registration_month,
			group = "New draft publishers",
			n = new_draft_creators,
			relative.prop = new_draft_creators / new_article_creators,
			absolute.prop = new_draft_creators / registered_users
		),
	],
	months[,
		list(
			wiki,
			registration_month,
			group = "Newly registered users",
			n = registered_users,
			relative.prop = 1,
			absolute.prop = 1
		),
	]
)
table_data$group = factor(
	table_data$group,
	levels=c("Newly registered users", "New editors", "New page creators", "New article page publishers", "New draft publishers")
)

merge(
	table_data[registration_month == "2013-10-01" & wiki == "enwiki",],
	table_data[registration_month == "2013-10-01" & wiki == "dewiki",],
	by="group",
	suffixes=c(".enwiki", ".dewiki")
)[,
	list(
		group = as.numeric(group),
		n.enwiki,
		rel.prop.en = round(relative.prop.enwiki, 3),
		abs.prop.en = round(absolute.prop.enwiki, 3),
		n.dewiki,
		rel.prop.de = round(relative.prop.dewiki, 3),
		abs.prop.de = round(absolute.prop.dewiki, 3)
	)
]
