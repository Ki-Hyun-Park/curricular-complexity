library(rvest)
library(stringr)
library(dplyr)

# URL for math major
url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-961.html"

# url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-596.html"
# regex patterns for extracting subject, course, or subject and course
subject_pattern <- "(?<!\\d)[A-Z][A-Z &-]+(?!\\d)"
course_pattern <- "[CM]{0,2}\\d+[A-Z]{0,3}"
subject_course_pattern <- paste(subject_pattern, course_pattern)

# use subject codes to abbreviate subject names, e.g., "Mathematics" -> "MATH"
abbreviate <- function(vec){
  abbrev <- read.csv("abbrev_table.csv", stringsAsFactors = FALSE)
  return(str_replace_all(vec, setNames(abbrev$code, abbrev$subject)))
}

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

full_reqs %>%
  lapply(add_subject) %>%
  str_split(",") %>%
  lapply(str_trim)
  
  
