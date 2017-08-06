install.packages("rvest") ; install.packages("RCurl") 
require(rvest) ; require(RCurl)
setwd("C:\\Users\\aqua.ACIDC\\Documents")

COM = Unsucc$Link
COM = as.data.frame(COM, stringsAsFactors = FALSE)

#Creates variables
TopCities = data.frame(TopCities=rep(NA,times=NROW(Unsucc)))
TopCitiesBackers = data.frame(TopCitiesBackers=rep(NA,times=NROW(Unsucc)))
TopCountries = data.frame(TopCountries=rep(NA,times=NROW(Unsucc)))
TopCountriesBackers = data.frame(TopCountriesBackers=rep(NA,times=NROW(Unsucc)))
NewBackers = data.frame(NewBackers=rep(NA,times=NROW(Unsucc)))
ReturningBackers = data.frame(ReturningBackers=rep(NA,times=NROW(Unsucc)))

COM = cbind(COM,TopCities,TopCitiesBackers,TopCountries,
           TopCountriesBackers,NewBackers,ReturningBackers)
colnames(COM)[1]="Link"

#Call COM

Sys.time()
#RUn from here
for (i in 128315:NROW(COM))
{
  #get community
  url = COM$Link[i]
  url = sub("?ref=category","/community",url,fixed=TRUE)
  if (!url.exists(url))
    next()
  webpage = read_html(url)  

  #get top cities
  x = html_nodes(webpage,".col-6")
  x = html_text(x)
  x = gsub("[\r\n]", "",x)
  y = gsub("Where Backers Come FromTop Cities","",x)[1]
  y = gsub(" backers| backer", ";", y)
  y = sub(";$", "", y)
  y = gsub(" ","",y)
  y2 = gsub("[^0-9;]","", y)
  y = gsub("([[:upper:]])", " \\1", y)
  y = gsub("[0-9]", "", y)
  y = gsub("^ ","",y)
  y = gsub("; ",";",y)
  COM$TopCities[i] = y
  COM$TopCitiesBackers[i] = y2
  
  #get top countries
  x = gsub("Where Backers Come FromTop Countries","",x)[2]
  x = gsub(" backers| backer", ";", x)
  x = gsub(" ","",x)
  x = sub(";$", "", x)
  
  x2 = gsub("[^0-9;]","", x)
  x = gsub("([[:upper:]])", " \\1", x)
  x = gsub("[0-9]", "", x)
  x = gsub("^ ","",x)
  x = gsub("; ",";",x)
  COM$TopCountries[i] = x
  COM$TopCountriesBackers[i] = x2
  
  #get new backers
  n = html_nodes(webpage,".count")
  n = html_text(n)
  COM$NewBackers[i] = gsub("[\r\n]","",n[1])
  COM$ReturningBackers[i] = gsub("[\r\n]","",n[2])
}
Sys.time()
write.csv(COM,"COMBKP.csv",row.names=FALSE)


Sys.time()
#RUn from here
for (i in 1:NROW(COM))
{
  #get community
  url = COM$Link[i]
  url = sub("?ref=category","/community",url,fixed=TRUE)
  if (!url.exists(url))
    next()
  webpage = read_html(url)  
  

