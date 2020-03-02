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

