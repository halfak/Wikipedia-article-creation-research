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
)
daily_status$experience_type = factor(
	mapply(
		function(experience, account_type){
			if(!is.na(account_type)){
				if(account_type == "anon"){
					"anon"
				}else if(account_type == "autocreate"){
					"autocreate"
				}else{
					as.character(experience)
				}
			}else{
				as.character(experience)
			}
		},
		daily_status$experience, 
		daily_status$account_type
	),
	levels=c("anon", "autocreate", "day", "week", "month", "oldtimer")
)

monthly_status = with(
	daily_status,
	rbind(
		data.table(
			date=new_date,
			page_namespace,
			account_creation,
			experience_type,
			status="now-visible",
			n = pages-archived_quickly,
			pages
		),
		data.table(
			date=new_date,
			page_namespace,
			account_creation,
			experience_type,
			status="now-archived",
			n = archived_quickly,
			pages
		)
	)
)[
	as.character(date) >= "2008",
	list(
		n = sum(n),
		prop = sum(n)/sum(pages)
	),
	list(
		month.date = as.Date(paste(substr(as.Date(date), 0, 7), "01", sep="-")),
		status,
		page_namespace,
		account_creation,
		experience_type
	)
]
monthly_status$experience_type = factor(
	monthly_status$experience_type, 
	levels=c("anon", "autocreate", "day", "week", "month", "oldtimer")
)

svg("monthly_pages/plots/status.post_2008/monthly_counts.articles.by_experience.svg",
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

svg("monthly_pages/plots/status.post_2008/monthly_counts.articles.day_one_only.svg",
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

svg("monthly_pages/plots/status.post_2008/monthly_counts.articles.day_one_only.by_account_creation.svg",
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

svg("monthly_pages/plots/status.post_2008/monthly_surviving_prop.area.articles.svg",
	height=3,
	width=13)
g = ggplot(
	monthly_status[
		page_namespace == 0 & 
		account_creation=="self",
	],
	aes(x=month.date, y=prop, fill=status)
) + 
geom_area(color="black") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
scale_fill_manual(values=c("#CCCCCC", "#555555")) + 
theme_bw() + 
facet_wrap(~ experience, ncol=4)
print(g)
dev.off()

svg("monthly_pages/plots/status.post_2008/monthly_surviving_prop.lm.articles.svg",
	height=3,
	width=13)
g = ggplot(
	monthly_status[
		page_namespace == 0 & 
		experience_type != "anon" &
		status=="now-visible",
	],
	aes(x=month.date, y=prop, fill=status)
) + 
geom_point() + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=5)
print(g)
dev.off()

svg("monthly_pages/plots/status.post_2008/monthly_surviving_prop.lm.articles.enwiki.newbies.svg",
	height=5,
	width=7)
g = ggplot(
	monthly_status[
		page_namespace == 0 & 
		experience_type != "anon" &
		experience_type != "autocreate" &
		experience_type != "oldtimer" &
		status=="now-visible",
	],
	aes(x=month.date, y=prop)
) + 
geom_point() + 
stat_smooth(method="lm") + 
scale_x_date("Pages creation month") + 
scale_y_continuous("Surviving proportion") + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
facet_wrap(~ experience_type, ncol=5)
print(g)
dev.off()

