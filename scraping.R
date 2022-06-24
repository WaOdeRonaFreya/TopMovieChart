### Scraping ###

library(rvest)
library(tidyverse)
tgl = Sys.Date()
tgl = gsub("-", "",tgl)
url1 = "https://www.officialcharts.com/charts/film-chart/"
url2 = "/offfilm/"
url = paste(url1, tgl, url2, sep = '')
html = url %>% read_html
movie = html %>% html_node(".chart-positions") %>% html_table
movie$Pos = as.numeric(movie$Pos)
movie = na.omit(movie)
movie = movie[-c(6)]
names(movie)[3] <- 'Judul'
movie= movie %>% mutate(Judul = gsub("                        \r\n                        \r\n\r\n                            \r\n                        \r\n                        ", " by ", Judul))
tes = do.call(rbind, str_split(movie$Judul, ' by '))
tes = as.data.frame(tes)
movie$Title = tes$V1
movie$Artist = tes$V2
movie = movie[-c(3)]
movie = movie[1:5,]
for(i in 1:5){
  if(grepl("(", movie$Title[i], fixed = TRUE) == TRUE){
    ttl = gsub('\\(', '', movie$Title[i])
    ttl = gsub('.{1}$', '', ttl)
    movie$Title[i] = ttl
  }
}

for(i in 1:5){
  mvurl1 = "https://www.rottentomatoes.com/m/"
  mvurl2 = tolower(gsub(' ', '_', movie$Title[i]))
  mvurl = paste(mvurl1, mvurl2, sep = '')
  movie$Url[i] = mvurl
}


### Save to MongoDB ###
library(mongolite)

connection_string = "mongodb+srv://ronafreya:ronahehe@cluster0.zg8xckw.mongodb.net/?retryWrites=true&w=majority"

mv <- mongo(collection = "testing", # Creating collection
                            db = "sample_dataset_R", # Creating DataBase
                            url = connection_string, 
                            verbose = TRUE)

ndata <- mv$count()
if (ndata == 0){
  mv$insert(movie)
} else {
  mv$drop()
  mv$insert(movie)
}







