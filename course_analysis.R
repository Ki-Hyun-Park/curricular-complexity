library(readxl)
library(dplyr)
library(stringr)

requisites <- read_xlsx("curricular_complexity_data_codebook.xlsx", sheet = 1)
transfer <- read_xlsx("curricular_complexity_ttd_data_v2.xlsx", sheet = 1)

# course_list <- requisites %>%
#   mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
#          rqs_crs_catlg_no = str_replace(rqs_crs_catlg_no, "^0+", ""),
#          course = paste(subj_area_cd, crs_catlg_no),
#          rqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no),
#          connector = lgc_conn_cd) %>%
#   select(course, rqs, connector, everything())

all_courses_raw <- requisites %>%
  mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
         rqs_crs_catlg_no = str_replace(rqs_crs_catlg_no, "^0+", ""),
         course = paste(subj_area_cd, crs_catlg_no),
         rqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no)) %>%
  transmute(course = transpose_prefix(course),
            rqs = transpose_prefix(course))
  # select(course, rqs) %>%
  # unlist(use.names = FALSE) %>%
  # unique()

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

all_courses <- vapply(all_courses_raw, transpose_prefix, "a", USE.NAMES = FALSE)

  