require(rvest)
setwd("C:\\Users\\talis\\Documents\\Daniel\\MM")

Extra = read.csv("Extra.csv",stringsAsFactors=FALSE)

#Succ
ExSucc = Extra[Extra$state=="successful",] 
links=Extra$link
NROW(links)
grep("the-worlds-first-stonepaper-notebookwaterproof-eco",links,fixed=TRUE)
#any ohev otah !

print(Sys.time())
for (j in 15:17)
{
  print(sprintf("Running loop %d",j))
  error = c()
  DB = data.frame()
  print(Sys.time())
  for (i in k:end)
  {
    #loading page  
    url = links[i]
    webpage = read_html(url)
    
    #check if live
    pointer = html_nodes(webpage,'.bttn')
    pointer = html_text(pointer)
    
    if (length(pointer)==0)
      {
      error = append(error,links[i])
      next()
      }

    #Getting nodes
    nod4 = html_nodes(webpage,'.border-left')
    nod4 = html_text(nod4)
    nod4 = gsub("[\r\n]", "", nod4)
    nod4 = gsub(" ", "", nod4)
    
    Pledged = unlist(strsplit(nod4,"pledgedof"))
    if (length(Pledged)==0)
    {
      error = append(error,links[i])
      next()
    }
    
    Goal = unlist(strsplit(Pledged[2],"goal"))
    Backers = unlist(strsplit(Goal[2],"backer"))[1]
    Pledged = Pledged[1]
    Goal = Goal[1]
    
    #Title and Author
    g = html_nodes(webpage,'.hero__link')
    g = html_text(g)
    Title = g[1]
    Author = gsub("[\r\n]","",g[2])
    
    #Description
    n = html_nodes(webpage,'.js-edit-profile-blurb')
    n = html_text(n)
    Description = gsub("[\r\n]","",n)
    
    #Subcategory Location category
    s = html_nodes(webpage,'.type-12')
    s = html_text(s)
    Location = gsub("[\r\n]","",s[1])
    Subcategory = gsub("[\r\n]","",s[2])
    Category = NA
    
    
    #URLs
    Link = url

    
    #Funding Period and Estimated Delivery
    t = html_nodes(webpage,'.pledge__detail-info , .f5')
    t = html_text(t)
    FundingPeriod = t[NROW(t)-1]
    FundingPeriod = gsub("[\r\n]","",FundingPeriod)
    
    e = html_nodes(webpage,'.js-adjust-time')
    e = html_text(e)
    e = e[1]
    if (nchar(e)==8)
        EstimatedDelivery = e
    if (nchar(e)>8)
        EstimatedDelivery = NA

    Status = "Successful"
    
    #merge variables
    project = cbind(Link,Category,Subcategory,Title,Description,
                    Author,Backers,Status,Pledged,Goal,Location,
                    FundingPeriod,EstimatedDelivery)
    DB = rbind(DB,project)
  } 
  print(Sys.time())

  name = paste0("Extra_",j,".csv")
  write.csv(DB,name,row.names=FALSE)
  write.csv(error,paste0("error",j,".csv"),row.names=FALSE)
  k=i
  end=k+2000
}
#end 

