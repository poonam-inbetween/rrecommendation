# install.packages("data.table")
# install.packages("ggplot2")
# install.packages("recommenderlab")
# install.packages("countrycode")

library("data.table")
library("ggplot2")
library("recommenderlab")
library("countrycode")


table <- read.csv("demo_data.csv", header = FALSE)
head(table)
help("data.table")
# to filter the data on one column value

# table_test <- data.table(table)
# setnames(table_test, 1:6, c("col1", "col2", "col3", "col4", "col5", "col6"))
# table_test <- table_test[col1 %in% c("C")]
# head(table_test)


# snap only first two columns and filter for only users and items
all_data <- data.table(table[, 1:2])
setnames(all_data, 1:2, c("Type", "Id"))
users_and_items <- all_data[Type %in% c("C", "V")]
remaining <- all_data[!Type %in% c("C", "V")]


# Insert increment on users
users_and_items_with_inc <- users_and_items[, user_inc := cumsum(Type == "C")]
head(users_and_items_with_inc)

# Table in long format
users_and_items_long <- users_and_items_with_inc[, 
                                                 list(user = Id[1], item = Id[-1])
                                                 , by = "user_inc"
                                                 ]
head(users_and_items_long)

# Table in wide format
users_and_items_long[, value := 1]
users_and_items_wide <- reshape(data = users_and_items_long, 
                                direction = "wide",
                                idvar = "user",
                                timevar = "item",
                                v.names = "value"
)
head(users_and_items_wide[, 1:5, with = FALSE])


vector_users <- users_and_items_wide[, user]
users_and_items_wide[, user := NULL]
users_and_items_wide[, user_inc := NULL]


head(users_and_items_wide[, 1:5, with = FALSE])

setnames(x = users_and_items_wide,old = names(users_and_items_wide),new = substring(names(users_and_items_wide), 7))

matrix_wide <- as.matrix(users_and_items_wide)
rownames(matrix_wide) <- vector_users
head(matrix_wide[, 1:6])

# Convert to binary matrix by replacing all 'NA's by 0
matrix_wide[is.na(matrix_wide)] <- 0
# Convert to recommenderlab's binary rating matrix
ass_matrix <- as(matrix_wide, "binaryRatingMatrix")
ass_matrix


image(ass_matrix[1:50, 1:50], main = "Binary rating matrix")

n_users <- colCounts(ass_matrix)
qplot(n_users) + stat_bin(binwidth = 100, bins = 30) + ggtitle("Distribution of the number of users")


qplot(n_users[n_users < 100]) + stat_bin(binwidth = 10) + ggtitle("Distribution of the number of users")

sum(rowCounts(ratings_matrix) == 0)
ratings_matrix <- ass_matrix[, colCounts(ass_matrix) >= 7]

n_users1 <- colCounts(ratings_matrix)
qplot(n_users1[n_users1 < 100], color="red") + stat_bin(binwidth = 10) 
+  ggtitle("Distribution of the number of users")

ratings_matrix


# Attributes

# table <- data.table(table)
# table_items <- table[V1 == "A"]
# head(table_items)
# 
# 
# table_items <- table_items[, c(2, 4, 5), with = FALSE]
# setnames(table_items, 1:3, c("id", "description", "url"))
# table_items <- table_items[order(id)]
# head(table_items)
# 
# table_items[, category := "product"]
# 
# name_countries <- c(countrycode_data$country.name, "Taiwan", "UK", "Russia", "Venezuela", "Slovenija", "Caribbean", "Netherlands (Holland)", "Europe", "Central America", "MS North Africa")
# table_items[description %in% name_countries, category := "region"]
# 
# table_items[grepl("Region", description), category := "region"]
# head(table_items)
# 
# table_items[, list(n_items = .N), by = category]
# 
# help(package = "recommenderlab")
# table_items[category %in% c("region")]



## Training and test

which_train <- sample(x = c(TRUE, FALSE),size = nrow(ratings_matrix),
                      replace = TRUE,prob = c(0.8, 0.2))

recc_data_train <- ratings_matrix[which_train, ]
recc_data_test <- ratings_matrix[!which_train, ]


recc_model <- Recommender(data = recc_data_train, method = "IBCF",
                          parameter = list(method = "Jaccard"))
class(recc_model@model$sim)


image(recc_model@model$sim)

# 
# dist_ratings <- as(recc_model@model$sim, "matrix")
# dist_category <- table_items[, 1 - dist(category == "product")]
# class(dist_category)
# dist_category <- as(dist_category, "matrix")
# 
# dim(dist_category)
# dim(dist_ratings)
# 
# rownames(dist_category) <- table_items[, id]
# colnames(dist_category) <- table_items[, id]
# 
# vector_items <- rownames(dist_ratings)
# dist_category <- dist_category[vector_items, vector_items]
# 
# identical(dim(dist_category), dim(dist_ratings))
# image(dist_category)
# 
# weight_category <- 0.25
# dist_tot <- dist_category * weight_category + dist_ratings * (1 - weight_category)
# 
# image(dist_tot)
# recc_model@model$sim <- as(dist_tot, "dgCMatrix")
# 
# Final Result

recc_predicted <- predict(object = recc_model, newdata = recc_data_test, n = 5)
head(recc_predicted@itemLabels)
user1_recommendetions <- recc_predicted@items[[1]]
items_labels_for_user_1 <- recc_predicted@itemLabels[user1_recommendetions]
items_labels_for_user_1

head(recc_model@model$sim)
range(recc_model@model$sim)
