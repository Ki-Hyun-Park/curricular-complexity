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