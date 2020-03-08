library(readxl)
library(dplyr)
library(stringr)

requisites <- read_xlsx("curricular_complexity_data_codebook.xlsx", sheet = 1)
transfer <- read_xlsx("curricular_complexity_ttd_data_v2.xlsx", sheet = 1)

# In the requisites table, C (for concurrent) and M (for multiple-listed)
# are suffixes. We want to take them and move them to the front of the
# course catalog numbers, so that, e.g., "140 M" -> "M140".
transpose_prefix <- function(string){
  prefix <- str_extract(string, "(?<= |L)[CM]{1,2}$")
  first_digit <- str_extract(string, "\\d")
  # If the prefix is preceded by a space or an "L" (lab class), extract it. 
  # This avoids extracting a "prefix" that is actually part of the course 
  # number, such as "PSYCH 119M" or "STATS 100C".
  # Otherwise, return the original string; no prefix exists.
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

# Create a "proper" table of requisites that has full and correct course names.
requisites_clean <- requisites %>%
  # Remove leading zeroes from the course catalog number.
  mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
         rqs_crs_catlg_no = str_replace(rqs_crs_catlg_no, "^0+", ""),
         course = paste(subj_area_cd, crs_catlg_no),
         reqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no)) %>%
  # Tranpose the prefix for every course. "a" is just a placeholder that
  # indicates that we want vapply to return a character string.
  mutate(course = vapply(course, transpose_prefix, "a", USE.NAMES = FALSE),
         reqs = vapply(reqs, transpose_prefix, "a", USE.NAMES = FALSE)) %>%
  select(course, reqs, everything())

all_courses <- requisites_clean %>%
  select(course, reqs) %>%
  unlist(use.names = FALSE)

# fix me!
get_immediate_reqs <- function(course_name, requisites = requisites_clean){
  # course_name <- "MATH 33A"
  if(course_name %in% requisites$course){
    reqs_table <- requisites %>% 
      filter(course == course_name)
    
    immediate_reqs <- reqs_table %>%
      pull(reqs)
    
    or_count <- reqs_table %>%
      pull(lgc_conn_cd) %>%
      str_count("OR") %>%
      sum(na.rm = TRUE)
    
    # return(list(reqs = immediate_reqs, or_count = or_count))
    return(reqs_table %>% select(reqs, lgc_conn_cd))
  } else {
    return(list(reqs = NULL, or_count = 0))
  }
}


get_reqs <- function(course_name, requisites = requisites_clean){
  reqs_table <- requisites %>%
    filter(course == course_name)
}

make_label <- function(course_name){
  course_name <- "A&O SCI 90"
  reqs_table <- requisites_clean %>%
    filter(course == course_name)
  label_vec <- course_name
  
  level_vec <- as.integer(reqs_table$rqs_seq_num) %/% 100
  if(length(unique(level_vec)) > 1){
    label_vec <- append(label_vec, "all of")
  }
  
  for(i in 1:nrow(reqs_table)){
    curr_row <- reqs_table[i,]
    left_paren <- !is.na(curr_row[, c("left_paren_3", "left_paren_2", "left_paren_1")])
    right_paren <- !is.na(curr_row[, c("right_paren_3", "right_paren_2", "right_paren_1")])
    
    if((length(unique(level_vec)) == 1) & (i == 1)){
      if(curr_row$lgc_conn_cd == "OR"){
        label_vec <- append(label_vec, "1 of", course_name)
      } else if(curr_row$lgc_conn_cd == "AND"){
        label_vec <- append(label_vec, "all of", course_name)
      } else {
        label_vec <- append(label_vec, course_name)
      }
    } else if((length(unique(level_vec)) == 1) & (i != 1)){
      label_vec <- append(label_vec, course_name) 
    }
  }
    
    # if(sum(left_paren) == 1){
    #   if(curr_row$lgc_conn_cd == "OR"){
    #     label_vec <- append(label_vec, c("1 of", course_name))
    #   } else if(curr_row$lgc_conn_cd == "AND"){
    #     label_vec <- append(label_vec, c("all of", course_name))
    #   }
    # } else if(sum(left_paren) == 2) {
    #   
    #   label_vec <- append(label_vec, course_name)
    # }


}


label <- c(
  "A&O SCI 90", "all of", "1 of", "EPS SCI 71", "C&EE 20M", "COMPTNG 10A",
  "1 of", "all of", "MATH 3A", "MATH 3B", "all of", "MATH 31A", "MATH 31B",
  "1 of", "PHYSICS 1A", "PHYSICS 5A", "PHYSICS 6A"
)


# let's try to calcuate the complexity score
in_class_print <- function(course_name, requisites = requisites_clean){
  req_list <- get_immediate_reqs(course_name)
  # or_count <- req_list$or_count
  for(req in req_list$reqs){
    # cat(req, sep = "\n")
    return(rbind(req_list, in_class_print(req)))
  }
}

in_class <- function(course_name){
  sort(unique(capture.output(in_class_print(course_name))))
  # sink()
}

out_class <- function(course_name){
  return(nrow(requisites_proper %>% filter(reqs == course_name)))
}



  