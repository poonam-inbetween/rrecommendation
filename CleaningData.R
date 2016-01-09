# Cleaning Data course -- Coursera
getwd()
if(!file.exists("/Users/peelu/Data"))
{dir.create("/Users/peelu/Data")}

file.exists("/Users/peelu/Data")

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
# method = "curl" is required for mac, for windows t shd work without it
download.file(fileURL, destfile = "/Users/peelu/Data/cameras.csv", method = "curl")
list.files("/Users/peelu/Data")

Datedownloaded <- date()
Datedownloaded

Cameras <- read.csv(file.choose(), header=T, sep=",")
head(Cameras)
names(Cameras)

# if one wants to read data in chunks in case of huge datasets
camera1 <- read.table(file.choose(), header=T, sep=",", nrows=40, skip = 10)
camera1


#Excel File

fileURL1 <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileURL1, destfile = "/Users/peelu/Data/cameras.xlsx", method = "curl"  )
list.files("/Users/peelu/Data")

install.packages("xlsx")
library(xlsx)
cameras2 <- read.xlsx(file.choose(), sheetIndex = 1, header = T)

install.packages("XML")
library(XML)

# Test xml

URLxml <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(URLxml, useInternal = TRUE)
rootnode <- xmlRoot(doc) # its like a wrapper element for the entire document
rootnode
xmlName(rootnode)
names(rootnode)

rootnode[[3]]
rootnode[[3]][[1]]
rootnode[[3]][[2]]
rootnode[[3]][[3]]
rootnode[[3]][[4]]
rootnode[[3]][[5]]

xmlSApply(rootnode,xmlValue) # This will give all the values under all the nodes joined together
xpathSApply(rootnode,"//name",xmlValue) # This will give the value under the node "name" for all the nodes
xpathSApply(rootnode,"//price",xmlValue)

# xml from cameras data, we downloaded the file and saved it on local machine
fileURL2 <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xml?accessType=DOWNLOAD"
download.file(fileURL2, destfile = "/Users/peelu/Data/cameras.xml", method = "curl")
list.files("/Users/peelu/Data")
doc <- xmlTreeParse(file.choose(), useInternal = TRUE)
rootnode <- xmlRoot(doc) # its like a wrapper element for the entire document
rootnode
xmlName(rootnode)
names(rootnode)

rootnode[[1]]


# Reading a html from the web 
fileURL3  <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileURL3, useInternal = TRUE)
# The html is from espn related to information about a particular team.
# we want to inspect the scores

Scores <- xpathSApply(doc, "//li[@class='scoreboard-menu']",xmlValue)
Teams <- xpathSApply(doc, "//li[@class='team-name']",xmlValue)
Scores
Teams


# Reading from json

install.packages("jsonlite") # Required packages for reading jsons
install.packages("curl")
library(jsonlite)
library(curl)

jsonData<- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData) # This will retrieve only first level
names(jsonData$owner) # This will give the array of tags under owner
names(jsonData$owner$login) # this will give NULL as there are no elements under login, its a leaf node


# To access values
jsonData$owner$login
jsonData$owner$id


myJSON <- toJSON(iris, pretty = TRUE)
cat(myJSON)

iris2 <- fromJSON(myJSON)
head(iris2)
