
#' Function to download a file from MKonline
#'
#' @param key The key (as in file) to download (ex CON_POW_H_A)
#' @param area The area (ex: cee, cwe, np, it etc.)
#' @param ws_user Your Wattsight user name. Defaults to an Environment file called WS_USER.
#' @param ws_password Your Wattsight user password. Defaults to an Environment file called WS_PASSWORD.
#' 
#' @export
ws_download_file <- function(key, area, ws_user = Sys.getenv("WS_USER"), ws_password = Sys.getenv("WS_PASSWORD")){


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
  first_8_lines <- suppressWarnings(readr::read_lines(ws_request, n_max = 8))
  row_with_headers <- c(1:8)[stringr::str_detect(tolower(first_8_lines), "^date,")]

  look_for_date <- stringr::str_detect(tolower(first_8_lines[row_with_headers]), "^date")

  # Extract column names and the first data line
  ws_col_names <- stringr::str_split(first_8_lines[row_with_headers], pattern = ",")[[1]]
  ws_first_data_line <- stringr::str_split(first_8_lines[row_with_headers + 1], pattern = ",")[[1]]

  # If there are different lengths between the column names and the number of columns
  # in the data, then remove one column name.
  if(length(ws_col_names) > length(ws_first_data_line) & ws_col_names[length(ws_col_names)] == ""){
    ws_col_names <- ws_col_names[1:(length(ws_col_names)-1)]
  }

  # parse if date is good
  if(look_for_date){
    
    ws_content <- suppressMessages(readr::read_csv(ws_request,
                                  col_names = FALSE,
                                  na = "",
                                  skip = row_with_headers))
    names(ws_content) <- ws_col_names

    ws_content$Date <- ws_date_parse(date = as.character(ws_content$Date))
  } else {
    stop("The data couldn't be parsed.")
  }

  # Set attribtutes from the first five lines
  attr(x = ws_content, which = "info") <- first_8_lines[1:row_with_headers - 1]

  # remove last column if all are NA and the column name is ""
  if(names(ws_content)[length(names(ws_content))] == "" & all(is.na(ws_content[[length(names(ws_content))]]))){
    ws_content[[length(names(ws_content))]] <- NULL
  }
  # Clean names as they start with upper case and contain space
  # Remove headers named [empty]
  names(ws_content) <- stringr::str_trim(tolower(names(ws_content)), "both")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), " ", "_")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), "/", "_")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), "[+]", "")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), "[%]", "")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), "-", "_")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), "\\[|\\]", "")
  names(ws_content) <- stringr::str_replace_all(tolower(names(ws_content)), "\\(|\\)", "")
  if(names(ws_content)[length(names(ws_content))] == "" & all(is.na(ws_content[,length(names(ws_content))]))){
    ws_request <- ws_content[, stringr::str_length(names(ws_content)) != 0]
  }
  
  # Are there empty column names ("")?
  # - if they all are NA, then remove the column
  # - if they not all are NA then give it the name 'empty'
  if("" %in% names(ws_content)){
    if(all(is.na(ws_content[, names(ws_content) == ""]))){
      ws_content <- ws_content[, names(ws_content) != ""]
    } else {
      names(ws_content)[names(ws_content) == ""] <- "empty"
    }
  }

  return(ws_content)
}




