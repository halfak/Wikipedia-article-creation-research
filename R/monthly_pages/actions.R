source("loader/daily_page_actions.R")

daily_actions = load_daily_page_actions(reload=T)

new_date = as.Date(as.character(daily_actions$date), format="%Y%m%d")

daily_actions$new_date = new_date

monthly_actions = daily_actions[,
	list(
		n = sum(n)
	),
	list(
		month.date = as.Date(paste(substr(new_date, 0, 7), "01", sep="-")),
		page_namespace,
		action
	)
]

svg("monthly_pages/plots/actions/action_counts.svg",
	height=3,
width=13)
g = ggplot(
	monthly_actions[page_namespace == 0,],
	aes(
		x=month.date,
		y=n
	)
) + 
geom_bar(
	stat="identity",
	position="stack",
	aes(fill=action),
	color="black"
) + 
scale_fill_manual(values=c("#000000", "#CCCCCC", "#FF0000")) + 
scale_y_log10("Count of actions (log scaled)") +  
scale_x_date("Month of action") + 
theme_bw() + 
facet_wrap(~ action, ncol=1)
print(g)
dev.off()

