slotNames(ass_matrix)
class(ass_matrix@data)
dim(ass_matrix@data)




count_per_item <- colCounts(ass_matrix)

table_views <- data.frame(
  item_names = names(count_per_item),
  count = count_per_item
)
table_views <- table_views[order(table_views$count, decreasing = TRUE), ]


ggplot(table_views[1:6, ], aes(x = item_names, y = count , label = count)) + 
  geom_bar(stat="identity") +  geom_text(vjust = -.5) + ggtitle("User Ids")
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  
 



count_per_user <- rowCounts(ass_matrix)

table_views1 <- data.frame(
  user_names = names(count_per_user),
  count = count_per_user
)
table_views1 <- table_views1[order(table_views1$count, decreasing = TRUE), ]


ggplot(table_views1[1:6, ], aes(x = user_names, y = count , label = count)) + 
  geom_bar(stat="identity") +geom_text(vjust = -.5) + ggtitle("User Ids")
theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


image(ass_matrix[1:10,1:15], main = "Heatmap of the rating matrix")







