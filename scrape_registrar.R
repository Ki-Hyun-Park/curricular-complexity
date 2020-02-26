library(rvest)
library(stringr)
# URL for math major
url <- "http://catalog.registrar.ucla.edu/ucla-catalog19-20-961.html"

# page <- read_html(url)
# rank_data_html <- html_text(html_nodes(page,'p, h2'))
# 
# prep_marker <- str_which(rank_data_html, "Preparation for the Major")
# prep_par <- rank_data_html[prep_marker + 1]
# 
# prep_reqs <- str_split_fixed(prep_par, "\\.", 2)[1]
# 
# # remove "Required: "
# prep_reqs <- str_replace(prep_reqs, "Required: ", "")
# 
# prep_reqs_list <- str_split(prep_reqs, ", ")

# one-step approach
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


prepend_reqs[[1]] %>%
  str_replace_all(setNames(code_table$code, code_table$subject))



# set up OR logic


setNames(code_table[, "subject"], code_table["code"])

