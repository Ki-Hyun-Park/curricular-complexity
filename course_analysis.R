library(readxl)
library(dplyr)
library(stringr)

requisites <- read_xlsx("curricular_complexity_data_codebook.xlsx", sheet = 1)


course_list <- requisites %>%
  mutate(crs_catlg_no = str_replace(crs_catlg_no, "^0+", ""),
         rqs_crs_catlg_no = str_replace(rqs_crs_catlg_no, "^0+", "")) %>%
  transmute(course = paste(subj_area_cd, crs_catlg_no),
            rqs = paste(rqs_subj_area_cd, rqs_crs_catlg_no),
            connector = lgc_conn_cd)
