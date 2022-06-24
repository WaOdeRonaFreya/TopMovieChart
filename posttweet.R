### Connect to MongoDB ###
library(mongolite)

connection_string = "mongodb+srv://ronafreya:ronahehe@cluster0.zg8xckw.mongodb.net/?retryWrites=true&w=majority"

mv <- mongo(collection = "testing", # Creating collection
               db = "sample_dataset_R", # Creating DataBase
               url = connection_string, 
               verbose = TRUE)
data <- mv$find()

### Post on Twitter ###

# Hashtag
hashtag <- c("github","rvest","rtweet", "bot", "opensource", "dplyr", "topchart")

samp_word <- sample(hashtag, 1)

## Status Message

status_details <- paste0(Sys.Date(),"\n\n Film terpopuler minggu ini adalah ", data[1,5], " oleh ", data[1,6], ".\nInfo detail film dapat dilihat di ", data[1,7],".",
                         "#",samp_word, " #topmovie", "\n")

# Publish to Twitter
library(rtweet)

## Create Twitter token
frx <- rtweet::create_token(
  app = "BOTTwitterMDS",
  consumer_key =    "3PhlxQmGkFX27OYq082mEhgGX",
  consumer_secret = "cIZdb8PQ5MtRlHeXA4JoQd1e5o788MTdBkAg3ex9snYRQQ8vAu",
  access_token =    "1504313492949528591-KbK4GdDlqOUeOXmAUMnADoGIpQKwZn",
  access_secret =   "353XSV5A2hIFPA7HKpxcSa0JkmliiOUTGmSgOAPP32YFd"
)


## Post Twitter
rtweet::post_tweet(
  status = status_details,
  token = frx)
