### Connect to MongoDB ###
library(mongolite)

connection_string = Sys.getenv("MONGO_CONNECTION_STRING")

mv <- mongo(collection = Sys.getenv("MONGO_COLLECTION_NAME"), 
               db = Sys.getenv("MONGO_DB_NAME"), 
               url = connection_string, 
               verbose = TRUE)
data <- mv$find()
data <- tail(data, 5)

### Post on Twitter ###

# Hashtag
hashtag <- c("github","rvest","rtweet", "bot", "opensource", "dplyr", "topchart")

samp_word <- sample(hashtag, 1)

## Status Message

status_details <- paste0(Sys.Date(),"\n\n Film terpopuler minggu ini adalah ", data[1,5], " oleh ", data[1,6], ".\nInfo detail film dapat dilihat di ", data[1,7],".\n",
                         "#",samp_word, " #topmovie", "\n")

library(rtweet)

## Create Twitter token
mvtoken <- rtweet::create_token(
  app = "BOTTwitterMDS",
  consumer_key =    Sys.getenv("TWITTER_API_KEY"), 
  consumer_secret = Sys.getenv("TWITTER_API_KEY_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)


## Post Twitter
rtweet::post_tweet(
  status = status_details,
  token = mvtoken)
