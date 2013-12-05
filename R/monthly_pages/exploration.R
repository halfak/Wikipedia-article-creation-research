source("loader/daily_page_stats.R")

daily_stats = load_daily_page_stats(reload=T)

new_date = as.Date(as.character(daily_stats$date), format="%Y%m%d")

daily_stats$new_date = new_date
daily_stats$deleted.prop = with(
	daily_stats,
	archived/pages
)


monthly_stats = with(
	daily_stats,
	rbind(
		data.table(
			date=new_date,
			page_namespace,
			status="now-visible",
			n = pages-archived,
			prop = (pages-archived)/pages
		),
		data.table(
			date=new_date,
			page_namespace,
			status="now-archived",
			n = archived,
			prop = archived/pages
		)
	)
)[,
	list(
		n = sum(n)
	),
	list(
		month.date = as.Date(paste(substr(as.Date(date), 0, 7), "01", sep="-")),
		status,
		page_namespace
	)
]

svg("plots/monthly_pages/
ggplot(
	monthly_stats[page_namespace == 0,],
	aes(x=month.date, y=n, fill=status)
) + 
geom_bar(stat="identity", color="#000000") + 
scale_x_date("Article creation month") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ page_namespace)