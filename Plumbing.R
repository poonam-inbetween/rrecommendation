library("data.table")
library("ggplot2")
library("recommenderlab")
library("countrycode")
library("sets")

# we use data table to query only users and items
getUsersAndItems <- function(tbl){
  all_data <- data.table(table[, 1:2])
  setnames(all_data, 1:2, c("Type", "Id"))
  all_data[Type %in% c("C", "V")]
  
  # remaining <- all_data[!Type %in% c("C", "V")]
}


# we want to remove item. from all columns. To do that 
# 1. we remove user column
# 2. remove user_inc, which is anyway not required henceforth
# 3 .simply apply trim all column names to get only item ids and 
# 4. then prepend user column again


convertIntoBinaryMatrix <- function(users_and_items_wide){
  # get users in a vector
  vector_users <- users_and_items_wide[, user]
  
  #remove user column
  users_and_items_wide[, user := NULL]
  
  #remove user_inc column
  users_and_items_wide[, user_inc := NULL]
  
  head(users_and_items_wide[, 1:5, with = FALSE])
  
  # use setnames to change column names. We use substring function to remove first 6 characters
  setnames(x = users_and_items_wide, old = names(users_and_items_wide), new = substring(names(users_and_items_wide), 7))
  
  # create a matrix out of it, until now we were operating on Table of data.table
  matrix_wide <- as.matrix(users_and_items_wide)
  # add users back again
  rownames(matrix_wide) <- vector_users
  
  #
  # Convert to binary matrix by replacing all 'NA's by 0
  matrix_wide[is.na(matrix_wide)] <- 0
  # Convert to recommenderlab's binaryRatingMatrix. TODO: describe binaryRatingMatrix
  assoc_matrix <- as(matrix_wide, "binaryRatingMatrix")
  assoc_matrix
}

createModel <- function (rating_matrix){
  #sample logical array which is randomized with probability of 0.8 for true an 0.2 for false
  which_train <- sample(x = c(TRUE, FALSE),size = nrow(ratings_matrix),
                        replace = TRUE,prob = c(0.8, 0.2))
  
  # this will get all rows which has associated vector value true
  recc_data_train <- ratings_matrix[which_train, ]
  # same as above
  r_test <- ratings_matrix[!which_train, ]
  
  #create recommendeation model using Recommender function of recommendere package.
  # we are going to create IBCF - Item based collaborative filtering model
  r_model <- Recommender(data = recc_data_train, method = "IBCF",
                         parameter = list(method = "Jaccard"))
  
  #return our results into a tuple
  pair(recc_model = r_model, recc_data_test = r_test)
}