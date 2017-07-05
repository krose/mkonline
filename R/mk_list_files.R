
#' Function to return the file list.
#'
#' The files list can be returned with either all the files or only the accessible files.
#'
#' @param mk_user Your MKOnline user name.
#' @param mk_password Your MKOnline user password.
#' @param only_accessible TRUE if you only want to see your available data series.
#' @param time_zone GMT (UTC) or another like CET. Used to parse the updated column
#' @importFrom magrittr %>%
#' @export
mk_list_files <- function(mk_user, mk_password, only_accessible = FALSE, time_zone = "GMT"){

  # Make the request and use basic authentication to access the list files csv file
  mk_request <- httr::GET(url = "http://download.mkonline.com/list-files?response-as=csv",
                          httr::authenticate(user = mk_user, password = mk_password))

  # Make sure that the request is valid
  httr::stop_for_status(mk_request)

  # Get and parse content
  mk_request <- httr::content(x = mk_request, as = "text", type = "text/csv", encoding = "UTF-8")
  mk_request <- stringr::str_replace_all(string = mk_request, pattern = "\r\n\r\n", "\r\n") # remove the last empty line.
  mk_request <- suppressWarnings(readr::read_csv2(mk_request, skip = 2, col_names = TRUE, col_types = "ccccccc_"))

  # Clean names as they start with upper case and contain space
  names(mk_request) <- stringr::str_replace_all(tolower(names(mk_request)), " ", "")


  # Sometimes the last row is NA, so remove it if it is.
  na_test <- is.na(mk_request$updated)
  if(sum(na_test) > 1){
    warning("File contains more than 2 NAs. NAs have been removed")
  }
  mk_request <- mk_request[!na_test,]

  # some files are not accessible and the user might only be interested in
  # the accessible files
  if(only_accessible){
    mk_request <-
      mk_request %>%
      dplyr::filter(!stringr::str_detect(access, "false"))
  }

  # parse the date with the specified time_zone
  mk_request$updated <- lubridate::ymd_hm(mk_request$updated, tz = time_zone)
  if(!stringr::str_detect(time_zone, "GMT")){
    mk_request$updated <- lubridate::force_tz(mk_request$updated, tzone = time_zone)
  }

  return(mk_request)
}



