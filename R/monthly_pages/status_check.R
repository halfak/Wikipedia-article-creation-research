source("loader/daily_page_status.R")

daily_status = load_daily_page_status(reload=T)

new_date = as.Date(as.character(daily_status$date), format="%Y%m%d")

daily_status$new_date = new_date

monthly_status = with(
	daily_status,
	rbind(
		data.table(
			date=new_date,
			page_namespace,
			account_type,
			experience,
			status="now-visible",
			n = pages-archived,
			pages
		),
		data.table(
			date=new_date,
			page_namespace,
			account_type,
			experience,
			status="now-archived",
			n = archived,
			pages
		)
	)
)[,
	list(
		n = sum(n),
		prop = sum(n)/sum(pages)
	),
	list(
		month.date = as.Date(paste(substr(as.Date(date), 0, 7), "01", sep="-")),
		status,
		page_namespace,
		account_type,
		experience
	)
]
monthly_status$experience = factor(monthly_status$experience, levels=c("day", "week", "month", "oldtimer"))


svg("monthly_pages/plots/status/monthly_counts.articles.day_one_only.by_account_type.svg",
	height=13,
	width=13)
g = ggplot(
	monthly_status[
		page_namespace == 0 & 
		experience=="day",],
	aes(x=month.date, y=n, fill=status)
) + 
geom_bar(stat="identity", color="#000000") + 
scale_x_date("Page creation month") + 
scale_y_continuous("Pages") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ account_type, ncol=1)
print(g)
dev.off()


