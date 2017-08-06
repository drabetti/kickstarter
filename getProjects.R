install.packages("rvest")
require(rvest)
setwd("C:\\Users\\aqua.ACIDC\\Documents\\MM")

Succ = read.csv("Succ.csv",
                   stringsAsFactors=FALSE)

Link = "https://www.kickstarter.com/projects/1453553459/boneshaker-books/updates"

url = Link
webpage = read_html(url)  
x = html_nodes(webpage,".timeline__divider--launched--publishing")
x = html_text(x)
x = gsub("[\r\n]", "",x)
x = gsub("Project launched", "",x)

Launch = which(is.na(Succ$FundingPeriod))

#Testing data
t = as.character(which(grepl("day",
      Succ$FundingPeriod)))
#get false rows
x = as.character(1:NROW(Succ))

diff = as.numeric(setdiff(x,t))


#adding variables
launch_date = data.frame(rep(NA,times=NROW(Succ)))
all_or_nothing = data.frame(rep(NA,times=NROW(Succ)))
end_date = data.frame(rep(NA,times=NROW(Succ)))

Succ = cbind(Succ,launch_date,all_or_nothing,end_date)
colnames(Succ)[31]="all_or_nothing"
names(Succ)


  #gets launch, all oir nothing and end date
  for (i in 1:length(diff))
  {
    url = Succ$Link[diff[i]]
    Link = url
    webpage = read_html(url)  
    y = html_nodes(webpage,".type-12")
    
    y = html_text(y)
    y = y[grep("All or nothing.",y)][1]
    y = gsub("[\r\n]", "",y)
    y = gsub("All or nothing.This project will only be funded if it reaches its goal by", "",y)

    if (nchar(y)>29)
    {
      y1 = substr(y,7,12)
      y2 = substr(y,14,17)
    }

    if (nchar(y)==29)
    {
      y1 = substr(y,7,11)
      y2 = substr(y,13,16)
    }
    

    y = paste0(y1,", ",y2)
    Succ$end_date[diff[i]] = y 
    Succ$all_or_nothing[diff[i]] = 1
    
    url = sub("?ref=category","/updates",url,fixed=TRUE)
    webpage = read_html(url)  
    x = html_nodes(webpage,".js-adjust-time")
    x = html_text(x)
    x = x[NROW(x)]  
    Succ$launch_date[diff[i]] = x
  }

Succ$Link[1]
Succ$launch_date[diff]

