source("Util.r")
source("Plumbing.r")

requirePkg("data.table")
requirePkg("ggplot2")
requirePkg("recommenderlab")
requirePkg("countrycode")


# all the packages called out. 
library("data.table")
library("ggplot2")
library("recommenderlab")
library("countrycode")
library("sets")

table <- read.csv("demo_data.csv", header = FALSE)
head(table)
help("data.table")
# to filter the data on one column value

# snap only first two columns and filter for only users and items

users_and_items = getUsersAndItems(table);

# Add a new column which contains integers started from one and increments for every new user
#
# we use @cumsum@ function from data table for that

users_and_items_with_inc <- users_and_items[, user_inc := cumsum(Type == "C")]
head(users_and_items_with_inc)

# Table in long format, that implies that we create three columns user_inc, user_id and item_id
# every user has multiple items assigned to it
users_and_items_long <- users_and_items_with_inc[, 
                                                   list(user = Id[1], item = Id[-1])
                                                 , by = "user_inc"
                                                ]
head(users_and_items_long)

# add column named value that has a default value as 1 
users_and_items_long[, value := 1]

# Reshape function is provided in Data.Table which is analogous to pivot in SQL
users_and_items_wide <- reshape(data = users_and_items_long, # our data 
                                direction = "wide",          # wide -> long or long -> wide
                                idvar = "user",              # variable identifying a group, row
                                timevar = "item",            # variable identifying a record within the
                                                             # the same group 
                                v.names = "value"            # values
                               )
# let's see only first five columns aka items
head(users_and_items_wide[, 1:5, with = FALSE])

# create associative matrix from above table
assoc_matrix <- convertIntoBinaryMatrix(users_and_items_wide)
assoc_matrix

#let's visualise our matrix
image(assoc_matrix[1:50, 1:50], main = "Binary rating matrix")

# calculate items purchansed by number of users
n_users <- colCounts(assoc_matrix)

# let's plot them using ggplot2
qplot(n_users) + stat_bin(binwidth = 100, bins = 30) + ggtitle("Distribution of the number of users")

# ignoring outliers
qplot(n_users[n_users < 100]) + stat_bin(binwidth = 10) + ggtitle("Distribution of the number of users")

# take users who has purchased at least 7 items
ratings_matrix <- assoc_matrix[, colCounts(assoc_matrix) >= 7]

# users who did not purchase anything
sum(rowCounts(ratings_matrix) == 0)

# TODO: figure out why I did this?
n_users1 <- colCounts(ratings_matrix)
qplot(n_users1[n_users1 < 100], color="red") + stat_bin(binwidth = 10) +  ggtitle("Distribution of the number of users")

# table_items[category %in% c("region")]

p <- createModel(ratings_matrix)
recc_model <- p$recc_model
recc_data_test <- p$recc_data_test

class(recc_model@model$sim)
image(recc_model@model$sim)



# Result

# let's predict for all test users
recc_predicted <- predict(object = recc_model, newdata = recc_data_test, n = 5)
#item labels of our result
head(recc_predicted@itemLabels)

#lets exxtract all predicated items for first user
user1_recommendetions <- recc_predicted@items[[1]]

# let's convert item_lables into item ids
items_labels_for_user_1 <- recc_predicted@itemLabels[user1_recommendetions]
items_labels_for_user_1

