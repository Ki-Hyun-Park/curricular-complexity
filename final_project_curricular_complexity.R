#=======================#
##### DATA CLEANING #####
#=======================#

library(readxl)
library(dplyr)
library(stringr)

# Read in data
requisites <- read_xlsx("curricular_complexity_data_codebook.xlsx", sheet = 1)
# transfer <- read_xlsx("curricular_complexity_ttd_data_v2.xlsx", sheet = 1)

# In the requisites table, C (for concurrent) and M (for multiple-listed)
# are suffixes; we want to take them and move them to the front of the
# course catalog numbers, so that, e.g., "140 M" -> "M140"
transpose_prefix <- function(string){
  prefix <- str_extract(string, "(?<= |L)[CM]{1,2}$")
  first_digit <- str_extract(string, "\\d")
  # If the prefix is preceded by a space or an "L" (lab class), extract it.
  # This avoids extracting a "prefix" that is actually part of the course 
  # number, such as "PSYCH 119M" or "STATS 100C"
  # Otherwise, return the original string; no prefix exists
  if(!is.na(first_digit) & !is.na(prefix)){
    string %>% 
      str_replace("(?<= |L)[CM]{1,2}$", "") %>%
      str_replace("\\d", paste0(prefix, first_digit)) %>%
      str_trim() %>%
      return()
  } else {
    return(string)
  }
}

# Create a "proper" table of requisites that has full and correct course names
requisites_clean <- requisites %>%
  # Remove leading zeroes from the course catalog number
  mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
         rqs_crs_catlg_no = str_replace(rqs_crs_catlg_no, "^0+", ""),
         course = paste(subj_area_cd, crs_catlg_no),
         reqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no)) %>%
  # Tranpose the prefix for every course; "a" is just a placeholder that
  # indicates that we want vapply to return a character string
  mutate(course = vapply(course, transpose_prefix, "a", USE.NAMES = FALSE),
         reqs = vapply(reqs, transpose_prefix, "a", USE.NAMES = FALSE)) %>%
  select(course, reqs, everything())

# Create CSV file with cleaned data
# write.csv(requisites_clean, "curricular_complexity_requisites_cleaned.csv")

# Create a list of all courses included in the requisites table
all_courses <- requisites_clean %>%
  select(course, reqs) %>%
  unlist(use.names = FALSE)


#==================================#
##### EXTRACTING PREREQUISITES #####
#==================================#

# Get a list of all possible immediate requisites of a course
get_immediate_reqs <- function(course_name, requisites = requisites_clean){
  if(course_name %in% requisites$course){
    reqs_table <- requisites %>% 
      filter(course == course_name)
    
    immediate_reqs <- reqs_table %>%
      pull(reqs)
    
    or_count <- reqs_table %>%
      pull(lgc_conn_cd) %>%
      str_count("OR") %>%
      sum(na.rm = TRUE)
    
    return(list(reqs = immediate_reqs, or_count = or_count))
    # return(reqs_table %>% select(reqs, lgc_conn_cd))
  } else {
    return(list(reqs = NULL, or_count = 0))
  }
}

# Prints all possible prerequisites recursively
# However, this ignores conditional operators like AND and OR
in_class_print <- function(course_name, requisites = requisites_clean){
  req_list <- get_immediate_reqs(course_name)
  # or_count <- req_list$or_count
  for(req in req_list$reqs){
    cat(req, sep = "\n")
    in_class_print(req)
    # return(rbind(req_list, in_class_print(req)))
  }
}

# Captures output of in_class_print and stores it as a character vector
in_class <- function(course_name){
  sort(unique(capture.output(in_class_print(course_name))))
}

# Example for A&O SCI 90: includes all potential requisites recursively
aos_90_reqs <- in_class("A&O SCI 90")

#==================================#
#### INTERACTIVE NETWORK GRAPHS ####
#==================================#

# NOTE: All network graphs below were MANUALLY CREATED
# A potential next step would be to automatically create these graphs
# based on major information
library(visNetwork)

##### Single-Course Example: Expression Tree #####
# Here, it only makes sense to consider prerequisites, not postrequisites

# Example for A&O SCI 90
# label includes both leaf nodes (classes) non-leaf nodes (expressions)
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

# links describe the connections between each node; we want acyclic directed
vis.links <- tibble(
  from = c(1, 2, 3, 3, 3, 2, 7, 8, 8,  7,  11, 11, 2,  14, 14, 14),
  to =   c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17),
  color = "black",
  arrows = "to"
)

# Shading and clustering enabled: try in RStudio Viewer window
visnet <- visNetwork(vis.nodes, vis.links, main = "A&O SCI 90 Requisites")
visnet %>% 
  visOptions(highlightNearest = TRUE, collapse = TRUE) %>%
  visHierarchicalLayout(direction = "UD")

##### Political Science Example

# Extracts the level from a vector of courses based on 100 vs. 200
extract_level <- function(course_vec){
  return(as.integer(str_extract(course_vec, "\\d+")) %/% 100 + 1)
}

# Blue stands for lower-division courses, and yellow for upper-division courses
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
  # level = c(2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
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

##### Economics Major #####

label <- c("ECON 1", "ECON  2", "ECON 11", "ECON 41", "MATH 31A", 
           "MATH 31B", "WRITING II", "ECON 101", "ECON 102", 
           "ECON 103/103L", "ECON 134", "ECON 137", "ECON 145", 
           "ECON 160", "ECON 106G", "ECON 195")

vis.nodes <- tibble(
  id = 1:length(label),
  label = label,
  shape = "circle",
  color.background = color_vec[extract_level(label)],
  color.border = "black",
  shadow = TRUE,
  level = c(8, 8, 8, 7, 7, 6, 5, 4, 4, 3, 3, 2, 2, 2, 1, 1)
)

vis.links <- tibble(
  from = c(1, 2, 3, 3, 3,4 , 4 , 5, 7, 8, 8 , 8,  8,  8,  9),
  to =   c(3, 3, 8, 12, 10, 11, 10, 4, 7, 9, 11, 13, 15, 16,  14 ),
  color = "black",
  arrows = "to"
)

visnet <- visNetwork(vis.nodes, vis.links, main = "ECONOMICS Major")
visnet %>% 
  visOptions(highlightNearest = TRUE, collapse = TRUE) %>%
  visHierarchicalLayout(direction = "DU")

##### Nursing Major #####

label <- c("Chem 14A", "Chem14B", "Nursing20", "Nursing10", "Nursing54B", "Nursing54A", "Nursing115", "Life Sci 7A", "Nursing 150A", "Nursing 150B", "Nursing 152A", "Nursing 152B", "Nursing 161", "Nursing 162B", "Nursing 162A", "Nursing 54C", "Nursing 162C", "Nursing 162D", "Nursing 163", "Nursing 164","Nursing 165", "Nursing 168","Nursing 171", "Nursing 16","Chem 14C","Nursing 160","Nursing 160B","Nursing 161C","Nursing 174","Nursing 3", "Nursing 13")

vis.nodes <- tibble(
  id = 1:length(label),
  label = label,
  shape = "circle",
  color.background = color_vec[extract_level(label)],
  color.border = "black",
  shadow = TRUE,
  level = c(8, 8, 7, 7, 7, 7, 5, 6, 5, 5, 4, 4, 4, 3, 3, 5, 
            2, 2, 1, 1, 1, 1, 2, 5, 6, 2, 2, 2, 4, 7, 7)
)

vis.links <- tibble(
  from = c(25,25,3,5,7,7,7,9,9,9,10,10,10,10,26,26,26,26,
           13,13,15,15,15,14,17,18,19,20,20,21,22,22,22,22,
           22,23,23,23,23,23,29,24,24,24,24,24),
  to =   c(1,2,4,6,6,5,6,8,4,3,6,9,11,12,23,9,10,11,12,26,14,
           6,5,16,15,14,17,15,26,27,26,14,13,19,20,21,28,13,
           19,20,21,28,30,31,13,19),
  color = 'black',
  arrows = 'to'
)


visnet <- visNetwork(vis.nodes, vis.links, main = "NURSING Major")
visnet %>% 
  visOptions(highlightNearest = TRUE, collapse = TRUE) %>%
  visPhysics(hierarchicalRepulsion = list(springLength = 200)) %>%
  visHierarchicalLayout(direction = "RL")

##### Computer Science Major #####

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36),
  label = c("MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B", "MATH 33A", 
            "MATH 33B", "MATH 61", "PHYSICS 1A", "PHYSICS 1B", "PHYSICS 1C", 
            "PHYSICS 4AL", "COM SCI 31", "COM SCI 32", "COM SCI 33", "COM SCI 35L", 
            "COM SCI M51A","COM SCI 111", "COM SCI 118", "COM SCI 131", "COM SCI M151B", 
            "COM SCI M152A", "COM SCI 180","COM SCI 181", "MATH 170A", "COM SCI 130", 
            "COM SCI 145", "COM SCI M146", "COM SCI 174A", "COM SCI 132", "COM SCI 161",
            "CHEM 20A", "CHEM 20B", "LIFESCI 7A", "MGMT 180", "ENGR 110",
            "ENGR 111"),
  shape ='circle'
)

edges <- tibble(
  from = c(1, 1, 2, 2, 3, 5, 1, 2, 1, 2, 3, 8, 4, 5, 9, 9, 12, 13, 12, 13, 10, 13, 14, 15, 17, 14, 15, 14, 16, 16, 13, 7, 22, 5, 17, 19, 22, 24, 14, 13, 19, 22, 1, 31, 2),
  to = c(2, 3, 4, 5, 4, 6, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 13, 14, 15, 15, 16, 17, 17, 17, 18, 19, 19, 20, 20, 21, 22, 22, 23, 24, 25, 25, 26, 27, 27, 28, 29, 30, 31, 32, 32)
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
  visSave(file="comsci.html", selfcontained = TRUE, background = "white")


##### World Arts Major #####

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
  label = c("WL ARTS 1", "WL ARTS 20", "WL ARTS 24", "WL ARTS 33", "WL ARTS 2",
            "WL ARTS 100A", "WL ARTS 104", "WL ARTS 124", "WL ARTS 103", "WL ARTS 114",
            "WL ARTS 144", "WL ARTS C146", "WL ARTS C158", "WL ARTS 186A", "WL ARTS 186B", ""),
  shape ='circle'
)

edges <- tibble(
  from = c(2, 14),
  to = c(7,15)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout()

visnet

visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout() %>% 
  visSave(file="wlarts.html", selfcontained = TRUE, background = "white")


##### Music Major #####

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20),
  label = c("MUSC 3", "MUSC M6A", "MUSC M6B",  "MUSC M6C",  "MUSC 20A",
            "MUSC 20B",  "MUSC 20C",  "MUSC 60A", "MUSC 185A", "MUSC 120A", 
            "MUSC 120B", "MUSC 120C", "MUSC 140A", "MUSC 140B", "MUSC 140C",
            "MUSC 160A", "MUSC 160B", "MUSC C175A", "ETHNMUS 101", "ETHNMUS 105"
            ),
  shape ='circle'
)

edges <- tibble(
  from = c(1, 2, 3, 5, 6, 7, 10, 11, 2, 13, 14 ),
  to = c(2, 3, 4, 6, 7, 10, 11, 12, 13, 14, 15)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "UD", levelSeparation = 150)

visnet

visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "UD", levelSeparation = 150) %>% 
  visSave(file="musc.html", selfcontained = TRUE, background = "white")

##### Aerospace Engineering Major #####

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36),
  label = c("MATH 31A", "MATH 31B", "MATH 32A", "MATH 32B", "MATH 33A",
            "CHEM 20A", "CHEM 20B", "CHEM 20L", "MECH&AE M20", "MECH&AE 82",
            "PHYSICS 1A", "PHYSICS 1B", "PHYSICS 1C", "PHYSICS 4AL", "PHYSICS 4BL",
            "MECH&AE 1", "MECH&AE 101", "MECH&AE 102", "MECH&AE 103", "MECH&AE 105A",
            "MECH&AE 105D", "MECH&AE 107", "MECH&AE 150A", "MECH&AE 157", "MECH&AE 166A",
            "MECH&AE 171A", "MECH&AE 150B", "MECH&AE C150P", "MECH&AE 154A", "MECH&AE 154S",
            "MECH&AE 157A", "MECH&AE C150R", "MECH&AE 161A", "MGMT 180", "ENGR 110",
            "ENGR 111"),
  shape ='circle'
)

edges <- tibble(
  from = c(1, 1, 2, 2, 3, 1, 6, 2, 7, 5, 5, 2, 3, 11, 4, 12, 5, 12, 13, 2, 11, 17, 5, 4, 5, 12, 7, 4, 10, 19, 20, 9, 10, 10, 19, 18, 19, 20, 10, 17, 22, 23, 20, 23, 30, 27, 23, 24, 14, 15, 18),
  to = c(2, 3, 4, 5, 4, 6, 7, 7, 8, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15, 17, 17, 18, 18, 19, 19, 19, 20, 20, 21, 21, 21, 22, 22, 23, 23, 24, 24, 24, 25, 25, 26, 27, 28, 28, 29, 30, 31, 31, 32, 32, 33)
)

vis.nodes <- nodes
vis.links <- edges
vis.links$arrows <- "middle"

visnet <- visNetwork(vis.nodes, vis.links)
visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 100)

visnet

visnet %>% 
  visEdges(arrows = "from") %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 100) %>% 
  visSave(file="ae.html", selfcontained = TRUE, background = "white")

##### Russian Major #####

nodes <- tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15),
  label = c("RUSSN 6", "RUSSN 25", "RUSSN 101A", "RUSSN 101B", "RUSSN 101C",
            "RUSSN 102A", "RUSSN 102B", "RUSSN 102C", "HIST 127A", "HIST 127B",
            "HIST 127C", "HIST 127D", "SLAVC 191TA", "SLAVC 191TB", "SLAVC 191TC"),
  shape ='circle'
)

edges <- tibble(
  from = c(1, 3, 4, 5, 6, 7, 13, 14),
  to = c(3, 4, 5, 6, 7, 8, 14, 15)
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
  visHierarchicalLayout() %>% 
  visSave(file="russn.html", selfcontained = TRUE, background = "white") 

#======================#
##### WEB SCRAPING #####
#======================#

##### Scrape Subject Area Codes #####

library(rvest)

url <- "https://www.registrar.ucla.edu/Faculty-Staff/Courses-and-Programs/Department-and-Subject-Area-Codes"

code_table <- url %>%
  read_html %>%                          # read as html 
  html_nodes('td:nth-child(3)') %>%      # query the paragraph under h2 headings
  html_text %>% 
  cbind(subject = .,
        code = 
          url %>%
          read_html %>%
          html_nodes('td:nth-child(4)') %>%
          html_text %>%
          str_trim(side = "both")) %>%
  write.csv(file = "abbrev_table.csv", row.names = FALSE)

##### Extract Major Courses for Pure Math Major #####

# regex patterns for extracting subject, course, or subject and course
subject_pattern <- "(?<!\\d)[A-Z][A-Z &-]+(?!\\d)"
course_pattern <- "[CM]{0,2}\\d+[A-Z]{0,3}"
subject_course_pattern <- paste(subject_pattern, course_pattern)

# use subject codes to abbreviate subject names, e.g., "Mathematics" -> "MATH"
abbreviate <- function(vec){
  abbrev <- read.csv("abbrev_table.csv", stringsAsFactors = FALSE)
  return(str_replace_all(vec, setNames(abbrev$code, abbrev$subject)))
}

# takes a string with non-subject course labels and adds subject codes
# e.g., "MATH 31A or 31AL" -> "MATH 31A or MATH 31AL"
add_subject <- function(string){
  char_vec <- string %>%
    abbreviate %>%
    str_trim() %>%
    str_split(" ") %>%
    unlist()
  
  for(i in 1:length(char_vec)){
    if(str_detect(char_vec[i], subject_pattern)){
      current_subject <- char_vec[i]
      char_vec[i] <- ""
    }
    if((i > 1) & str_detect(char_vec[i], course_pattern)){
      char_vec[i] <- paste(current_subject, char_vec[i])
    }
  }
  return(str_trim(paste(char_vec, collapse = " ")))
}

# URL for math major
url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-961.html"

# get full list of requisites as a vector of strings
full_reqs <- url %>%
  read_html %>%                          # read as html 
  html_nodes('p, h2') %>%                # query the paragraph under h2 headings
  html_text %>%                          # convert to text
  subset(str_detect(., "Required")) %>%  # query required courses
  str_replace("Required: ", "") %>%      # remove "Required: " from text
  str_split_fixed("\\.", 2) %>%          # split on period
  subset(select = c(T, F)) %>%           # keep only sentences with requirements
  abbreviate()                           # abbreviate subject names to codes

# Example for Pure Math major
pure_math_reqs <- full_reqs %>%
  lapply(add_subject) %>%
  str_split(",") %>%
  lapply(str_trim)

##### Extract Major Courses for Applied Math Major #####

# URL for applied math major
url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-962.html"

# Example for Applied Math major
applied_math_reqs <- url %>%
  read_html %>%                          
  html_nodes('p, h2') %>%                
  html_text %>%                          
  subset(str_detect(., "Required")) %>%  
  str_replace("Required: ", "") %>%      
  str_split_fixed("\\.", 2) %>%          
  subset(select = c(T, F)) %>%           
  abbreviate() %>%
  lapply(add_subject) %>%
  str_split(",") %>%
  lapply(str_trim)



