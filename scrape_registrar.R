library(rvest)
library(stringr)
library(dplyr)

# URL for math major
url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-961.html"

# get full list of requisites
full_reqs <- url %>%
  read_html %>%                          # read as html 
  html_nodes('p, h2') %>%                # query the paragraph under h2 headings
  html_text %>%                          # convert to text
  subset(str_detect(., "Required")) %>%  # query required courses
  str_replace("Required: ", "") %>%      # remove "Required: " from text
  str_split_fixed("\\.", 2) %>%          # split on period
  subset(select = c(T, F)) %>%           # keep only sentences with courses
  str_split(", ")                        # get individual course numbers


# "prepend" subject field to course number to get full course name
prepend <- function(req_vec){
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

prepend_reqs <- lapply(full_reqs, prepend)


# abbrev_table <- read.csv("abbrev_table.csv")
prepend_reqs[[1]] %>%
  str_replace_all(setNames(abbrev_table$code, abbrev_table$subject))



# set up OR logic


setNames(abbrev_table[, "subject"], abbrev_table["code"])

