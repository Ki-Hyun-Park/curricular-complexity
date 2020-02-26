# extract full list of courses from course requisites list
# maybe there's a better way to do this?
# NOT GOOD, need diff groups

library(readxl)
library(dplyr)
library(stringr)

requisites <- read_xlsx("curricular_complexity_data_codebook.xlsx", sheet = 1)

course_list <- requisites %>%
  mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
         rqs_crs_catlg_no = str_replace(rqs_catlg_no, "^0+", "")) %>%
  transmute(crs = paste(subj_area_cd, crs_catlg_no),
            rqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no)) %>%
  unlist(use.names = FALSE) %>%
  unique()


