# install.packages("visNetwork")
library(visNetwork)

# let's do MATH.
# we can at least get immediate requisites

nodes <- tibble(
  id = c(1, 2, 3, 4, 5),
  label = c("MATH 1", "MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B")
  # value = ,
  # title = ,
)

edges <- tibble(
  from = c(1, 2, 2, 2, 3),
  to = c(2, 3, 4, 5, 5)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet


# a slightly different view for a single course
nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8),
  label = c(
    "MATH 33A", "1 of 3", "MATH 3B", "MATH 31B", "MATH 32A",
    "MATH 3A", "MATH 31A", "MATH 1"
  )
  # value = ,
  # title = ,
)

edges <- tibble(
  from = c(1, 2, 2, 2, 3, 6, 4, 7, 5),
  to = c(2, 3, 4, 5, 6, 8, 7, 8, 7)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "to"
vis.nodes$color.background <- c("white", "yellow", rep("white", 6))
vis.nodes$shape <- "circle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet

###################################################################### from ki
install.packages("visNetwork")
library(visNetwork)
install.packages("tibble")
library(tibble)

# Statistics Major

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20),
  label = c("STATS 10", "STATS 20", "MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B", "MATH 33A", "STATS 100A", "STATS 100B", "STATS 100C", "STATS 101A", "STATS 101B", "STATS 101C", "STATS 102A", "STATS 102B", "STATS 102C", "STATS 140SL", "STATS 141SL", "STATS 112", "STATS 143")
  # value = ,
  # title = ,
)

edges <- tibble(
  from = c(1, 3, 3, 4, 4, 5, 6, 7, 8, 9, 1, 2, 11, 12, 1, 2, 7, 7, 9, 14, 9, 14, 9, 12, 17, 1, 9, 12),
  to =   c(2, 4, 5, 6, 7, 6, 8, 8, 9,10,11,11,12,13,14,14,14,15,15,15,16,16,17,17,18, 19,20,20)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 500) %>% 
  visSave(file="network.html", selfcontained = TRUE, background = "white")

