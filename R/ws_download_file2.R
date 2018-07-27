


#' Function to download a file from MKonline
#'
#' @param key The key (as in file) to download (ex CON_POW_H_A)
#' @param area The area (ex: cee, cwe, np, it etc.)
#' @param ws_user Your Wattsight user name. Defaults to an Environment file called WS_USER.
#' @param ws_password Your Wattsight user password. Defaults to an Environment file called WS_PASSWORD.
#' 
#' @export
ws_download_file2 <- function(key, area, ws_user = Sys.getenv("WS_USER"), ws_password = Sys.getenv("WS_PASSWORD")){
  
  
  # Make the request and use basic authentication to access the list files csv file
  ws_request <- httr::GET(url = paste0("http://download.wattsight.com/download-file?", "file=", key, "&area=", area,"&separator=period"),
                          httr::authenticate(user = ws_user, password = ws_password))
  
  # Make sure that the request is valid
  httr::stop_for_status(ws_request)
  
  # Get and parse content
  # find the starting line of the actual data by looking for "date" as
  # this is the headers before the content
  # Look for the value "date" in the headers and parse the date if it's there.
  ws_request <- httr::content(x = ws_request, as = "text", type = "text/csv", encoding = "UTF-8")
  first_6_lines <- suppressWarnings(readr::read_lines(ws_request, n_max = 6))
  
  # If there are different lengths between the column names and the number of columns
  # in the data, then remove one column name.
  ws_content <- suppressWarnings(readr::read_csv(ws_request, skip = 6))
  
  # Set attribtutes from the first five lines
  attr(x = ws_content, which = "info") <- first_6_lines
  
  is_character_na_test <- function(x){
    
    is.character(x) & all(is.na(x))
  }
  ws_content <- dplyr::mutate_if(ws_content, is_character_na_test, as.numeric)
  
  ws_names <- tolower(names(ws_content))
  names(ws_content) <- ws_names
  
  if(all(stringr::str_detect(ws_names, "^x"))){
    stop("All headers are replaced by default names. There might be a problem with the number of lines that are skipped in the call to readr::read_csv.")
  }
  
  if(ws_names[1] == "x1" & 
     stringr::str_detect(dplyr::summarise_all(ws_content, readr::guess_parser)[[1]][1], "date")){
    names(ws_content)[1] <- "date"
  }
  
  if(stringr::str_detect(ws_names[length(ws_names)], "^x")[1] & 
     all(is.na(ws_content[[length(ws_names)]]))){
    ws_content[[length(ws_names)]] <- NULL
  }
  
  return(ws_content)
}
