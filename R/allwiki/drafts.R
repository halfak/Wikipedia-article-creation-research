source("loader/enwiki/monthly_article_page_status.R")
source("loader/dewiki/monthly_article_page_status.R")

dewiki = load_monthly_article_page_status.dewiki(reload=T)
dewiki$wiki = "dewiki"
enwiki = load_monthly_article_page_status.enwiki(reload=T)
enwiki$wiki = "enwiki"
monthly_status = rbind(dewiki,enwiki)

monthly_status$articles_unpublished_quickly = sapply(
	monthly_status$articles_unpublished_quickly,
	function(x){
		if(is.na(x)){
			0
		}else{
			x
		}
	}
)
monthly_status$successful_articles = with(
	monthly_status,
	articles_published-articles_unpublished_quickly
)
monthly_status$month_published = as.Date(monthly_status$month_published)
monthly_status$survival_prop = with(
	monthly_status,
	successful_articles/articles_published
)

monthly_status$survival_prop.se = with(
	monthly_status,
	sqrt(survival_prop*(1-survival_prop)/articles_published)
)

monthly_status$editor_tenure = factor(
	monthly_status$creator_tenure,
	c('-day', 'day-week', 'week-month', 'month-')
)

monthly_status[
	creator_type == "self-created" & 
	month_published == "2013-10-01" & 
	articles_published >= 10 &
	wiki == "enwiki",
	list(
		origin=original_namespace,
		creator_tenure,
		authors=unique_authors,
		articles=articles_published,
		surviving=successful_articles,
		survival.prop=round(survival_prop, 3)
	)
][order(origin, creator_tenure),]

monthly_status[
	creator_type == "self-created" & 
	month_published == "2013-10-01" & 
	articles_published >= 25 &
	wiki == "dewiki",
	list(
		origin=original_namespace,
		creator_tenure,
		authors=unique_authors,
		articles=articles_published,
		surviving=successful_articles,
		survival.prop=round(survival_prop, 3)
	)
][order(origin, creator_tenure),]
