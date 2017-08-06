#install.packages("rvest")
require(rvest)

Live = read.csv("C:\\Users\\Daniel\\Downloads\\MM\\LiveAll.csv",
                stringsAsFactors=FALSE)

#links = subset(Succ,subset=Subcategory=="Textiles",select=Link)
links = Live$Link
NROW(links)
#run from here

print(Sys.time())
for (j in 1:2)
{
  DB = data.frame()
  print(sprintf("Running loop %d",j))
  print(Sys.time())
  
  for (i in k:end)
  {
    #loading page  
    url = links[i]
    webpage = read_html(url)

    #check if live
    pointer = html_nodes(webpage,'.bttn')
    pointer = html_text(pointer)
    if (pointer!="Report this project to Kickstarter")
      next()
    
    #Getting nodes
    nod4 = html_nodes(webpage,'.money , .type-24-md')
    nod4 = html_text(nod4)
    Pledged = nod4[1]
    Goal = nod4[3]
    Backers = gsub("[\r\n]", "", nod4[4])
    
    #preventing NA data
    a=is.na(Pledged)
    b=is.na(Goal)
    c=is.na(Backers)
    if(sum(a,b,c)>2)
      next()
    
    
    #Location
    n = html_nodes(webpage,'.auto-scroll-x')
    n = html_text(n)
    n = unlist(strsplit(n,"\n\n\n"))
    Location = gsub("[\r\n]", "", n[length(n)])

    #URLs
    Link = url
    #website = html_nodes(webpage,".project-profile__link , .btn--large") 
    #Website = website[2]
  
    #unique paths
    t = html_nodes(webpage,'.pledge__detail-info , .f5')
    t = html_text(t)
    FundingPeriod = "Live"
    EstimatedDelivery = t[2]
    
    #merge variables
    project = cbind(Link,Backers,Pledged,Goal,Location,FundingPeriod,EstimatedDelivery)
    DB = rbind(DB,project)
  } 
  name = paste0("DFL_",j,".csv")
  write.csv(DB,name,row.names=FALSE)
  print(Sys.time())
  k=i=
  end=k+2250
}#end 

#78657
