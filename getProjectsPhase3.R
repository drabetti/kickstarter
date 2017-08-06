install.packages("rvest")
require(rvest)
setwd("C:\\Users\\Daniel\\Downloads\\MM")

extra = read.csv("extra.csv",stringsAsFactors=FALSE)
links = extra$link

#run from here
print(Sys.time())
for (j in 14:17)
{
  print(sprintf("Running loop %d",j))
  
  DB = data.frame()
  print(Sys.time())
  for (i in k:end)
  {
    #loading page  
    url = links[i]
    webpage = read_html(url)

    #GEt images
    imgsrc = html_nodes(webpage,xpath = '//*/img')
    imgsrc = html_attr(imgsrc,'class')
    Imagem = sum(grepl("fit",imgsrc))
    Video = max((NROW(imgsrc)-Imagem-7),0)
    Video = Video+sum(grepl("has_played_hide",imgsrc))
    
    #GEt Text
    text = html_nodes(webpage,"p")
    text = html_text(text)
    divide = grep("Check out the FAQ",text)
      if(length(divide)==0){
        write.table(url,paste0(i,".txt"))
        next()
      }
    Text = text[1:(divide-1)]
    Text = paste(Text, collapse = '')
    Text = gsub("[\r\n]", "",Text)
    Text = gsub("<U\\+\\w\\w\\w\\w>","",Text)

    TextLength = sapply(gregexpr("[A-z]\\W+", Text), length) + 1
    
    Rewards = text[(divide+1):(length(text)-3)]
    Rewards = gsub("[\r\n]", "",Rewards)
    Rewards = Rewards[-grep("It's a way to bring creative projects to life.",Rewards)]
    RewardsAmmount = sum(grepl("Select this reward",Rewards))
    Rewards = paste(Rewards, sep='',collapse = '#')
    Rewards = gsub("Select this reward#","",Rewards)
    Rewards = gsub("#"," ",Rewards)
    RewardsLength = sapply(gregexpr("[A-z]\\W+", Rewards), length) + 1
    
    Pledged = html_nodes(webpage,".pledge__amount")
    Pledged = html_text(Pledged)
    Pledged = gsub("[\r\n]", "",Pledged)
    Pledged = sapply(strsplit(Pledged, "About "), "[", 2)
    PledgedBrackets = paste (Pledged, collapse = ";")
    Pledged = as.numeric(gsub("[^0-9.]", "", Pledged))
    PledgedMin = min(Pledged)
    PledgedMax = max(Pledged)
    PledgedMed = median(Pledged)
    PledgedAvg = mean(Pledged)
    PledgedRange = PledgedMax-PledgedMin
    PledgedVar = var(Pledged)
    PledgedSd = sd(Pledged)
    
    #getting variables
    Link = url

    project = cbind(Link,Imagem,Video,Text,TextLength,
                    RewardsAmmount,RewardsLength,
                    PledgedBrackets,PledgedMin,PledgedMax,
                    PledgedRange,PledgedMed,PledgedAvg,
                    PledgedVar,PledgedSd)
    DB = rbind(DB,project)
  }
  
  name = paste0("ExtraP3",j,".csv")
  write.csv(DB,name,row.names=FALSE)
  print(Sys.time())
  k=i
  end=k+3000
} #End
