install.packages('RMySQL', type='source')

library(RMySQL)
con <- dbConnect(MySQL(),
                 user="root", 
                 password="",
                 dbname="test2", 
                 host="localhost")
on.exit(dbDisconnect(con))
