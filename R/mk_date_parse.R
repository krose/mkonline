
#' This is a helper function to detect the date format of a character vector with dates
#'
#' @param character vector of dates
mk_date_parse <- function(date){
  # First I check if the date is a character vector and then
  # I look for a date pattern that is either hourly or daily.
  # I look for the hourly first as the daily will turn up as true
  # for hourly as well.

  if(!is.character(date)){
    stop("The date isn't a character vector.")
  }

  if(all(stringr::str_detect(date, "[0-9]{4}+[:punct:]{1}+[0-9]{2}+[:punct:]{1}+[0-9]{2}+[:blank:]{1}+[0-9]{2}:[0-9]{2}"))){
    # Hourly
    date <- lubridate::ymd_hm(date, tz = "GMT")
    return(date)

  } else if(all(stringr::str_detect(date, "[0-9]{4}+[:punct:]{1}+[0-9]{2}+[:punct:]{1}"))){
    # Daily
    date <- lubridate::ymd(date, tz = "GMT")
    return(date)

  } else {
    stop("The date format couldn't be detected.")
  }
}

