source("loader/daily_page_status.R")

daily_status = load_daily_page_status(reload=T)

new_date = as.Date(as.character(daily_status$date), format="%Y%m%d")

daily_status$new_date = new_date
daily_status$account_creation = sapply(
	daily_status$account_type,
	function(type){
		if(is.na(type)){
			"self"
		}else if(type == "anon"){
			"anon"
		}else if(type == "autocreate"){
			"autocreated"
		}else{
			"self"
		}
	}
))
daily_status$experience = factor(daily_status$experience, levels=c("day", "week", "month", "oldtimer"))

monthly_status = with(
	daily_status,
	rbind(
		data.table(
			date=new_date,
			page_namespace,
			account_creation,
			experience,
			status="now-visible",
			n = pages-archived,
			pages
		),
		data.table(
			date=new_date,
			page_namespace,
			account_creation,
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
		account_creation,
		experience
	)
]
monthly_status$experience = factor(monthly_status$experience, levels=c("day", "week", "month", "oldtimer"))



svg("monthly_pages/plots/status/monthly_counts.articles.svg",
	height=3,
	width=13)
g = ggplot(
	monthly_status[page_namespace == 0,
		list(n=sum(n)),
		list(month.date, page_namespace, status)
	],
	aes(x=month.date, y=n, fill=status)
) + 
geom_bar(stat="identity", color="#000000") + 
scale_x_date("Page creation month") + 
scale_y_continuous("Pages") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ page_namespace)
print(g)
dev.off()

svg("monthly_pages/plots/status/monthly_counts.articles.by_experience.svg",
	height=6,
	width=13)
g = ggplot(
	monthly_status[page_namespace == 0 & account_creation=="self",],
	aes(x=month.date, y=n, fill=status)
) + 
geom_bar(stat="identity", color="#000000") + 
scale_x_date("Page creation month") + 
scale_y_continuous("Pages") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ experience, ncol=1)
print(g)
dev.off()

svg("monthly_pages/plots/status/monthly_counts.articles.day_one_only.svg",
	height=3,
	width=13)
g = ggplot(
	monthly_status[
		page_namespace == 0 & 
		account_creation=="self" & 
		experience=="day",],
	aes(x=month.date, y=n, fill=status)
) + 
geom_bar(stat="identity", color="#000000") + 
scale_x_date("Page creation month") + 
scale_y_continuous("Pages") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ experience, ncol=1)
print(g)
dev.off()

svg("monthly_pages/plots/status/monthly_counts.articles.day_one_only.by_account_creation.svg",
	height=3,
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
facet_wrap(~ experience + account_creation, ncol=1)
print(g)
dev.off()

svg("monthly_pages/plots/status/monthly_surviving_prop.articles.svg",
	height=3,
	width=13)
g = ggplot(
	monthly_status[page_namespace == 0,
		list(n=sum(n)),
		list(month.date, page_namespace, status)
	],
	aes(x=month.date, y=prop)
) + 
geom_line() + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ page_namespace)
print(g)
dev.off()

svg("monthly_pages/plots/status/monthly_surviving_prop.area.articles.svg",
	height=3,
	width=13)
g = ggplot(
	monthly_status[page_namespace == 0,],
	aes(x=month.date, y=prop, fill=status)
) + 
geom_area(color="black") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ page_namespace)
print(g)
dev.off()

