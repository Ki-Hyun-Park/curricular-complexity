library(rvest)
library(stringr)
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
  as_tibble()





