# Attributes

table <- data.table(table)
table_items <- table[V1 == "A"]
head(table_items)


table_items <- table_items[, c(2, 4, 5), with = FALSE]
setnames(table_items, 1:3, c("id", "description", "url"))
table_items <- table_items[order(id)]
head(table_items)

table_items[, category := "product"]

name_countries <- c(countrycode_data$country.name, "Taiwan", "UK", "Russia", "Venezuela", "Slovenija", "Caribbean", "Netherlands (Holland)", "Europe", "Central America", "MS North Africa")
table_items[description %in% name_countries, category := "region"]

table_items[grepl("Region", description), category := "region"]
head(table_items)

table_items[, list(n_items = .N), by = category]

help(package = "recommenderlab")

dist_ratings <- as(recc_model@model$sim, "matrix")
dist_category <- table_items[, 1 - dist(category == "product")]
class(dist_category)
dist_category <- as(dist_category, "matrix")

dim(dist_category)
dim(dist_ratings)

rownames(dist_category) <- table_items[, id]
colnames(dist_category) <- table_items[, id]

vector_items <- rownames(dist_ratings)
dist_category <- dist_category[vector_items, vector_items]

identical(dim(dist_category), dim(dist_ratings))
image(dist_category)

weight_category <- 0.25
dist_tot <- dist_category * weight_category + dist_ratings * (1 - weight_category)

image(dist_tot)
recc_model@model$sim <- as(dist_tot, "dgCMatrix")
