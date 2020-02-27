library(rvest)
library(stringr)
library(dplyr)

# URL for math major
url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-961.html"


# regex patterns for extracting subject, course, or subject + course
subject_pattern <- "(?<!\\d)[A-Z][A-Z &-]+(?!\\d)"
course_pattern <- "[CM]{0,2}\\d+[A-Z]{0,3}"
subject_course_pattern <- paste(subject_pattern, course_pattern)

# use subject codes to abbreviate full subject names
# e.g., "Mathematics" -> "MATH"
abbreviate <- function(vec){
  abbrev <- read.csv("abbrev_table.csv", stringsAsFactors = FALSE)
  return(str_replace_all(vec, setNames(abbrev$code, abbrev$subject)))
}

# get full list of requisites
full_reqs <- url %>%
  read_html %>%                          # read as html 
  html_nodes('p, h2') %>%                # query the paragraph under h2 headings
  html_text %>%                          # convert to text
  subset(str_detect(., "Required")) %>%  # query required courses
  str_replace("Required: ", "") %>%      # remove "Required: " from text
  str_split_fixed("\\.", 2) %>%          # split on period
  subset(select = c(T, F)) %>%           # keep only sentences with courses
  abbreviate()

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



full_reqs[1] %>%
  abbreviate %>%
  str_extract_all(subject_pattern) %>%
  rep(times = )

full_reqs[1] %>% 
  abbreviate %>%
  str_count(subject_pattern)

string <- full_reqs[1] %>% abbreviate
test <- string %>% 
  str_split(subject_pattern) %>%
  unlist %>%
  str_extract_all(course_pattern)
test <- test[-1]

sapply(test, length)

test_pattern <- paste0(subject_pattern, "[A-Za-z ,]*(?!((", subject_pattern, ")))")
test_pattern <- "(?<!\\d)[A-Z][A-Za-z0-9 &-,]+(?!([A-Z]))"
str_extract(string, test_pattern)
subjects <- unlist(str_extract_all(full_reqs[1] %>% abbreviate, subject_pattern))
for(subject in subjects){
  subject_count <- str_count(full_reqs[1] %>% abbreviate, subject)
  print(c(subject, subject_count))
}


# add subject names to course number to get full course name
add_subject <- function(req_vec){
  for (i in 1:length(req_vec)) {
    # extract subject if it exists; otherwise use previous subject
    if (str_detect(req_vec[i], "[:alpha:]{2,}")) {
      subject <- str_extract(req_vec[i], "[:alpha:]{2,}")
    } else {
      req_vec[i] <- paste(subject, req_vec[i])
    }
  }
  return(req_vec)
}


# add subject codes to inline course numbers
# e.g., "MATH 31A or 31AL" -> "MATH 31A or MATH 31AL"
add_subject_inline <- function(req_vec){
  return_vec <- c()
  for(req in req_vec){
    # if a subject is detected, extract it
    if(str_detect(req, subject_pattern)){
      curr_subject <- req %>% 
        str_extract(subject_pattern) %>%
        str_trim(side = "right")
    }
    # subsitute full course phrases in and/or phrases
    # and phrases must be followed by a course pattern
    if(str_detect(req, paste0("(through)|(or)|(and ", course_pattern, ")"))){
      req <- str_replace_all(req, c(or = paste("or", curr_subject),
                                    and = paste("and", curr_subject)))
    }
    # subsitute when there's a course pattern but not a full pattern
    if(str_detect(req, course_pattern) & !str_detect(req, subject_pattern)){
      course <- setdiff(str_extract_all(req, course_pattern),
                        str_extract_all(req, subject_course_pattern))
      req <- str_replace_all(req, course_pattern, paste(curr_subject, course))
    }
    return_vec <- c(return_vec, req)
  }
  return(return_vec)
}

