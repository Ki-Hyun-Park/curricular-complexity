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


# 2. One for the entire math major

# 
# label <- c(
#   "MATH 31A", "MATH 31AL", "1 of", "MATH 31B", "MATH 32A", "all of", "MATH 32B", 
#   "1 of", "MATH 33A", "MATH 33B", "PHYSICS 1A", "COMPTNG 10A", "2 of", "CHEM 20A", 
#   "CHEM 20B", "ECON 11", "LIFESCI 7A", "PHILOS 31", "PHILOS 132", "PHYSICS 1B", 
#   "PHYSICS 1C", "PHYSICS 5B", "PHYSICS 5C", "MATH 110A", "MATH 110B", 
#   "MATH 115A", "MATH 120A", "all of", "MATH 131A", "all of", "MATH 131B", "all of", "MATH 132", "all of", 
#   "MATH 106-199", "STATS 100A-102C"
# )
# 
# vis.nodes <- tibble(
#   id = 1:length(label),
#   label = label,
#   shape = "circle",
#   color.background = c("yellow", rep("white", length(label) - 1)),
#   color.border = "black",
#   shadow = TRUE
#   # level = c(
# )
# 
# vis.links <- tibble(
#   from = c(24, 25, 26, 27, 28, 28, 28, 28, 29, 30, 30, 31, 32, 32, 32, 33, 34, 34),
#   to =   c(26, 24, 9,  28, 7,  10, 26, 29, 30, 7,  10, 32, 10, 26, 29, 34, 7,  10),
#   color = "black",
#   arrows = "to"
# )
# 
# visnet <- visNetwork(vis.nodes, vis.links, main = "Math Major")
# visnet %>% 
#   visOptions(highlightNearest = TRUE, collapse = TRUE) %>%
#   visHierarchicalLayout(direction = "UD")

# 3. Fixing POLISCI and Nursing
extract_level <- function(course_vec){
  return(as.integer(str_extract(course_vec, "\\d+")) %/% 100 + 1)
}
color_vec <- c("lightblue", "yellow")

label <- c("POL SCI 10", "POL SCI 20", "POL SCI 30", "POL SCI 40", "STATS 10", 
          "POL SCI 140A", "POL SCI 140B", "POL SCI 140C", "POL SCI M111A", 
          "POL SCI 120A", "POL SCI 150", "POL SCI 151A", "POL SCI 151B", 
          "POL SCI 151C", "POL SCI 171A")

vis.nodes <- tibble(
  id = 1:length(label),
  label = label,
  shape = "circle",
  color.background = color_vec[extract_level(label)],
  color.border = "black",
  shadow = TRUE
)

vis.links <- tibble(
  from = c(4, 4, 4, 3),
  to =   c(6, 7, 8, 15),
  color = "black",
  arrows = "to"
)


visnet <- visNetwork(vis.nodes, vis.links, main = "POL SCI Major")
visnet %>% 
  visOptions(highlightNearest = TRUE, collapse = TRUE) %>%
  visHierarchicalLayout(direction = "UD")