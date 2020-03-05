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


# and one for the entire math major
label <- c(
  "MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B", "MATH 33A", "MATH 33B",
  "PHYSICS 1A", "COMPTNG 10A", "2 of 10",
  "CHEM 20A", "CHEM 20B", "ECON 11", "LIFESCI 7A", "PHILOS 31", "PHILOS 132",
  "PHYSICS 1B", "PHYSICS 1C", "PHYSICS 5B", "PHYSICS 5C",
  "MATH 1", "1 of 3", "MATH 3A", "MATH 3B", "ECON 1", "ECON 2", "MATH Prereqs"
)

nodes <- tibble(
  id = 1:length(label),
  label = label
)

edges <- tibble(
  from = c(1,  2, 3, 4, 4, 5,  21, 21, 21, 23, 6, 7, 7, 7, 
           9,  9,  9,  9,  9,  9,  9,  9,  9,  9, 
           10, 11, 11, 11, 12, 12, 12, 12, 15, 
           16, 16, 16, 16, 17, 17, 17, 17, 17,
           26, 26, 26, 26, 26, 26, 26, 26, 26),
  to =   c(20, 1, 1, 2, 3, 21, 2,  3,  23, 22, 2, 1, 2, 3, 
           10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
           1, 10,  1,  2,  24, 25, 1,  2,  14, 
           7,  2,  3,  4,  7,  16,  3,  4,  5,
           1, 2, 3, 4, 5, 6, 7, 8, 9)
=======
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
>>>>>>> 74941814cd0ee59b773d492cfe2fe88e6491c4f1
)

vis.nodes <- nodes
vis.links <- edges
<<<<<<< HEAD
vis.links$arrows <- "to"
backgrounds <- rep("white", length(label))
backgrounds[c(1, 2, 3, 4, 5, 6, 7, 8, 9)] <- "orange"
backgrounds[26] <- "yellow"
vis.nodes$color.background <- backgrounds
vis.nodes$shape <- "circle"

visnet <- visNetwork(vis.nodes, vis.links) %>%
  visPhysics(solver = "forceAtlas2Based", 
             forceAtlas2Based = list(avoidOverlap = 0.9, springLength = 200))
visnet


####### and one for just the math requirements themselves

label <- c(
  "MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B", "MATH 33A", "MATH 33B",
  "PHYSICS 1A", "COMPTNG 10A", "2 of", "OR",
  "CHEM 20A", "CHEM 20B", "ECON 11", "LIFESCI 7A", "PHILOS 31", "PHILOS 132",
  "PHYSICS 1B", "PHYSICS 1C", "PHYSICS 5B", "PHYSICS 5C",
  "MATH 110A", "MATH 110B", "MATH 115A", "MATH 120A", "MATH 131A", 
  "MATH 131B", "MATH 132", "5 of",
  "MATH 106-199", "STATS 100A-102C"
)

nodes <- tibble(
  id = 1:length(label),
  label = label
)

edges <- tibble(
  from = c(2, 3, 4, 4, 5, 10, 10, 6, 7, 7, 7, 
           9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
           11, 12, 12, 12, 13, 13, 16, 17, 17, 17, 17, 
           18, 18, 18, 18, 18,
           21, 22, 23, 24, 24, 24, 24, 25, 25, 26, 26, 26, 27, 27, 28, 28),
  to =   c(1, 1, 2, 3, 10, 2, 3, 2, 1, 2, 3, 
           11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
           1, 11, 1, 2, 1, 2, 15, 7, 2, 3, 4, 
           7, 17, 3, 4, 5,
           23, 21, 5, 4, 6, 23, 25, 4, 6, 6, 23, 25, 4, 6, 29, 30)
=======
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


#### DESMA(Design Media Arts) Major

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21),
  label = c("DESMA 8", "DESMA 10", "DESMA 21", "DESMA 22", "DESMA 24", "DESMA 25", "DESMA 28", "DESMA 101", "DESMA 104", "DESMA 152", "DESMA 153", "DESMA 154", "DESMA 156", "DESMA 157", "DESMA 161", "DESMA 160", "DESMA 171", "DESMA 172", "DESMA 159A", "DESMA 159B", "DESMA 159C")
  # value = ,
  # title = ,
)

edges <- tibble(
  from = c(3, 4, 6, 4, 7, 8, 9, 3, 4, 6, 9, 8, 5, 7, 8, 7, 12, 9, 8, 14, 9, 13, 8, 9, 14, 15, 16, 17, 18, 5, 7, 8, 9, 11, 13, 16, 17, 18, 5, 7, 8, 9, 12, 16, 17, 18),
  to =   c(7, 7, 7,10,10,10,11,12,12,12,12,13,14,14,14,15, 15,16,17, 17,18, 18, 19, 19, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21, 21)
>>>>>>> 74941814cd0ee59b773d492cfe2fe88e6491c4f1
)

vis.nodes <- nodes
vis.links <- edges
<<<<<<< HEAD
vis.links$arrows <- "to"
backgrounds <- rep("white", length(label))
backgrounds[c(1, 2, 3, 4, 5, 6, 7, 8, 9)] <- "orange"
backgrounds[21:length(backgrounds)] <- "yellow"
# backgrounds[26] <- "yellow"
vis.nodes$color.background <- backgrounds
vis.nodes$shape <- "circle"

visnet <- visNetwork(vis.nodes, vis.links) %>%
  visPhysics(solver = "forceAtlas2Based", 
             forceAtlas2Based = list(avoidOverlap = 0.9, springLength = 200))
visnet
=======
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 500) %>% 
  visSave(file="network.html", selfcontained = TRUE, background = "white")
visnet



#######Situ#######

library(visNetwork)
library(tibble)

# Computer Science Major

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37),
  label = c("MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B", "MATH 33A", 
            "MATH 33B", "MATH 61", "PHYSICS 1A", "PHYSICS 1B", "PHYSICS 1C", 
            "PHYSICS 4AL", "COM SCI 31", "COM SCI 32", "COM SCI 33", "COM SCI 35L", 
            "COM SCI M51A","COM SCI 111", "COM SCI 118", "COM SCI 131", "COM SCI M151B", 
            "COM SCI M152A", "COM SCI 180","COM SCI 181", "MATH 170A", "COM SCI 130", 
            "COM SCI 145", "COM SCI M146", "COM SCI 174A", "COM SCI 132", "COM SCI 161",
            "CHEM 20A", "CHEM 20B", "LIFESCI 7A", "MGMT 180", "ENGR 110",
            "ENGR 111", "")
)

edges <- tibble(
  from = c(1, 1, 2, 2, 3, 5, 1, 2, 1, 2, 3, 8, 4, 5, 9, 9, 12, 13, 12, 13, 10, 13, 14, 15, 17, 14, 15, 14, 16, 16, 13, 7, 22, 5, 17, 19, 22, 24, 14, 13, 19, 22, 1, 31, 2, 33, 34, 35, 36, 32),
  to = c(2, 3, 4, 5, 4, 6, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 13, 14, 15, 15, 16, 17, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 23, 24, 25, 25, 26, 27, 27, 28, 29, 30, 31, 32, 32, 37, 37, 37, 37, 37)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 150)

visnet

visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 150) %>% 
  visSave(file="network.html", selfcontained = TRUE, background = "white")

# World Arts Major

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
  label = c("WL ARTS 1", "WL ARTS 20", "WL ARTS 24", "WL ARTS 33", "WL ARTS 2",
            "WL ARTS 100A", "WL ARTS 104", "WL ARTS 124", "WL ARTS 103", "WL ARTS 114",
            "WL ARTS 144", "WL ARTS C146", "WL ARTS C158", "WL ARTS 186A", "WL ARTS 186B", "")
)

# still working on this
edges <- tibble(
  from = c(1, 1, 2, 2, 3, 5, 1, 2, 1, 2, 3, 8, 4, 5, 9, 9, 12, 13, 12, 13, 10, 13, 14, 15, 17, 14, 15, 14, 16, 16, 13, 7, 22, 5, 17, 19, 22, 24, 14, 13, 19, 22, 1, 31, 2, 33, 34, 35, 36, 32),
  to = c(2, 3, 4, 5, 4, 6, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 13, 14, 15, 15, 16, 17, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 23, 24, 25, 25, 26, 27, 27, 28, 29, 30, 31, 32, 32, 37, 37, 37, 37, 37)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 150)

visnet

visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 150) %>% 
  visSave(file="network.html", selfcontained = TRUE, background = "white")


>>>>>>> 74941814cd0ee59b773d492cfe2fe88e6491c4f1
