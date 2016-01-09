slotNames(ratings_matrix)
class(ratings_matrix@data)
dim(ratings_matrix@data)


vector_ratings <- as.vector(ratings_matrix@data) # this doesn't work

count_per_item <- colCounts(ratings_matrix)

table_views <- data.frame(
  item_names = names(count_per_item),
  count = count_per_item
)
table_views <- table_views[order(table_views$count, decreasing = TRUE), ]


ggplot(table_views[1:6, ], aes(x = item_names, y = count)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ggtitle("Number of Items")
