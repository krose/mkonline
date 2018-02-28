
#' Function to return the file list.
#'
#' The files list can be returned with either all the files or only the accessible files.
#'
#' @param only_accessible TRUE if you only want to see your available data series.
#' @param ws_user Your Wattsight user name. Defaults to a environment variable called WS_USER.
#' @param ws_password Your Wattsight user password. Defaults to a environment variable called WS_USER.
#' 
#' @importFrom magrittr %>%
#' @export
ws_list_files <- function(only_accessible = FALSE, ws_user = Sys.getenv("WS_USER"), ws_password = Sys.getenv("WS_PASSWORD")){

  # Make the request and use basic authentication to access the list files csv file
  ws_request <- httr::GET(url = "http://download.wattsight.com/list-files?response-as=csv",
                          httr::authenticate(user = ws_user, password = ws_password))

  # Make sure that the request is valid
  httr::stop_for_status(ws_request)

  # Get and parse content
  ws_request <- httr::content(x = ws_request, as = "text", type = "text/csv", encoding = "UTF-8")
  ws_request <- stringr::str_replace_all(string = ws_request, pattern = "\r\n\r\n", "\r\n") # remove the last empty line.
  ws_request <- suppressWarnings(suppressMessages(readr::read_csv2(ws_request, skip = 2, col_names = TRUE, col_types = "ccccccc_")))

  # Clean names as they start with upper case and contain space
  names(ws_request) <- stringr::str_replace_all(tolower(names(ws_request)), " ", "")


  # Sometimes the last row is NA, so remove it if it is.
  na_test <- is.na(ws_request$updated)
  if(sum(na_test) > 1){
    warning("File contains more than 2 NAs. NAs have been removed")
  }
  ws_request <- ws_request[!na_test,]

  # some files are not accessible and the user might only be interested in
  # the accessible files
  ws_request$access <- as.logical(toupper(ws_request$access))
  if(only_accessible){
    ws_request <- ws_request[ws_request$access, ]
  }

  # parse the date with the specified time_zone
  ws_request$updated <- lubridate::ymd_hm(ws_request$updated, tz = "CET")

  return(ws_request)
}



