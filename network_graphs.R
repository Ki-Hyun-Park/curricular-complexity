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