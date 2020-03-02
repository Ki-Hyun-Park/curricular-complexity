library(readxl)
library(dplyr)
library(stringr)

requisites <- read_xlsx("curricular_complexity_data_codebook.xlsx", sheet = 1)
transfer <- read_xlsx("curricular_complexity_ttd_data_v2.xlsx", sheet = 1)

# a bit slow, could optimize some more
transpose_prefix <- function(string){
  prefix <- str_extract(string, "(?<= |L)[CM]{1,2}$")
  first_digit <- str_extract(string, "\\d")
  # only ENGCOMP A and ENGCOMP AP don't have numbers
  # another edge case: ART 186CLM is really ART M186CL
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

requisites_proper <- requisites %>%
  mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
         rqs_crs_catlg_no = str_replace(rqs_crs_catlg_no, "^0+", ""),
         course = paste(subj_area_cd, crs_catlg_no),
         reqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no)) %>%
  mutate(course = vapply(course, transpose_prefix, "a", USE.NAMES = FALSE),
         reqs = vapply(reqs, transpose_prefix, "a", USE.NAMES = FALSE)) %>%
  select(course, reqs, everything())

all_courses <- requisites_proper %>%
  select(course, reqs) %>%
  unlist(use.names = FALSE)


get_immediate_reqs <- function(course_name, requisites = requisites_proper){
  if(course_name %in% requisites_proper$course){
    reqs_table <- requisites_proper %>% 
      filter(course == course_name)
    
    immediate_reqs <- reqs_table %>%
      pull(reqs)
    
    or_count <- reqs_table %>%
      pull(lgc_conn_cd) %>%
      str_count("OR") %>%
      sum(na.rm = TRUE)
    
    return(list(reqs = immediate_reqs, or_count = or_count))
  } else {
    return(list(reqs = NULL, or_count = 0))
  }
}


# let's try to calcuate the complexity score
in_class_print <- function(course_name, requisites = requisites_proper){
  req_list <- get_immediate_reqs(course_name)
  # or_count <- req_list$or_count
  for(req in req_list$reqs){
    cat(req, sep = "\n")
    in_class_print(req)
  }
}

in_class <- function(course_name){
  sort(unique(capture.output(in_class_print(course_name))))
  # sink()
}

out_class <- function(course_name){
  return(nrow(requisites_proper %>% filter(reqs == course_name)))
}



  