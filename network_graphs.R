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
visnet



#### Art Major

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21),
  label = c("ART 1A", "ART 1B", "ART 11A", "ART 11B", "ART 11D", "ART 11E", "ART 31A", "ART 31B", "ART 31C", "ART HIS 22", "ART 100", "ART 132", "ART HIS M110A", "ART 130", "ART 133", "ART 137", "ART C180", "ART 145", "ART 147", "ART 148", "ART 150")
  # value = ,
  # title = ,
)

edges <- tibble(
  from = c(7, 8, 7, 8, 9, 7, 8, 9, 1, 3, 5, 2, 4, 6),
  to =   c(8, 9,11,11,11,12,12,12,14,15,16,18,19,20)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 500) %>% 
  visSave(file="network.html", selfcontained = TRUE, background = "white")
visnet


#### Political Science Major

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
  label = c("POL SCI 10", "POL SCI 20", "POL SCI 30", "POL SCI 40", "STATS 10", "POL SCI 140A", "POL SCI 140B", "POL SCI 140C", "POL SCI M111A", "POL SCI 120A", "POL SCI 150", "POL SCI 151A", "POL SCI 151B", "POL SCI 151C", "POL SCI 171A")
  # value = ,
  # title = ,
)

edges <- tibble(
  from = c(4, 4, 4, 3),
  to =   c(6, 7, 8, 15)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 500) %>% 
  visSave(file="network.html", selfcontained = TRUE, background = "white")
visnet





