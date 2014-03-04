source("loader/enwiki/monthly_afc_draft_count.R")

months = load_monthly_afc_draft_count(reload=T)

newcomer.months = months[
	(is.na(creator_type) | creator_type == "self-created") & 
	(
		creator_tenure == "-day" |
		creator_tenure == "day-week" |
		creator_tenure == "week-month"
	),
	list(
		pages_created = sum(pages_created),
		unique_authors = sum(unique_authors)
	),
	list(month_created)
]

svg("afc/plots/monthly_newcomer_afc_draft_creations.svg",
	height=3,
	width=7)
ggplot(
	newcomer.months[month_created >= "2008-01-01" & month_created <= "2013-10-01",],
	aes(
		x=month_created,
		y=pages_created
	)
) + 
geom_bar(stat="identity", color="black", fill="#CCCCCC") + 
scale_x_date("Month created") + 
scale_y_continuous("AFC drafts created") + 
theme_bw()
dev.off()


svg("afc/plots/monthly_newcomer_afc_draft_creations.svg",
	height=3,
	width=7)
ggplot(
	newcomer.months[month_created <= "2013-10-01",],
	aes(
		x=month_created,
		y=unique_authors
	)
) + 
geom_bar(stat="identity", color="black", fill="#CCCCCC") + 
scale_x_date("Month created") + 
scale_y_continuous("AFC draft authors") + 
theme_bw()
dev.off()

