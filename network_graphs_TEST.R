library(dplyr)
library(stringr)
library(visNetwork)
# Setup for network graphing: single-course
# Here, it only makes sense to consider prerequisites, not postrequisites

# Example for A&O SCI 90

# 1. Define label (must include all courses and logical operators)

label <- c(
  "A&O SCI 90", "all of", "1 of", "EPS SCI 71", "C&EE 20M", "COMPTNG 10A",
  "1 of", "all of", "MATH 3A", "MATH 3B", "all of", "MATH 31A", "MATH 31B",
  "1 of", "PHYSICS 1A", "PHYSICS 5A", "PHYSICS 6A"
)

vis.nodes <- tibble(
  id = 1:length(label),
  label = label,
  shape = "circle",
  color.background = c("yellow", rep("white", length(label) - 1)),
  color.border = "black",
  shadow = TRUE,
  level = c(1, 2, 3, 4, 4, 4, 3, 4, 5, 5, 4, 5, 5, 3, 4, 4, 4)
)

vis.links <- tibble(
  from = c(1, 2, 3, 3, 3, 2, 7, 8, 8,  7,  11, 11, 2,  14, 14, 14),
  to =   c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17),
  color = "black",
  arrows = "to"
)

visnet <- visNetwork(vis.nodes, vis.links, main = "A&O SCI 90 Requisites")
visnet %>% 
  visOptions(highlightNearest = TRUE, collapse = TRUE) %>%
  visHierarchicalLayout(direction = "UD")
# visnet



# next: we want to get prerequisites based off the data itself...but how?

