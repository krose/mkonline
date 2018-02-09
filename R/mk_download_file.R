
#' Function to download a file from MKonline
#'
#' @param mk_user Your MKOnline user name.
#' @param mk_password Your MKOnline user password.
#' @param key The key (as in file) to download (ex CON_POW_H_A)
#' @param area The area (ex: cee, cwe, np, it etc.)
#' @export
mk_download_file <- function(mk_user, mk_password, key, area){


  # Make the request and use basic authentication to access the list files csv file
  mk_request <- httr::GET(url = paste0("http://download.mkonline.com/download-file?", "file=", key, "&area=", area,"&separator=period"),
                          httr::authenticate(user = mk_user, password = mk_password))

  # Make sure that the request is valid
  httr::stop_for_status(mk_request)

  # Get and parse content
  # find the starting line of the actual data by looking for "date" as
  # this is the headers before the content
  # Look for the value "date" in the headers and parse the date if it's there.
  mk_request <- httr::content(x = mk_request, as = "text", type = "text/csv", encoding = "UTF-8")
  first_8_lines <- suppressWarnings(readr::read_lines(mk_request, n_max = 8))
  row_with_headers <- c(1:8)[stringr::str_detect(tolower(first_8_lines), "^date,")]

  look_for_date <- stringr::str_detect(tolower(first_8_lines[row_with_headers]), "^date")

  # Extract column names and the first data line
  mk_col_names <- stringr::str_split(first_8_lines[row_with_headers], pattern = ",")[[1]]
  mk_first_data_line <- stringr::str_split(first_8_lines[row_with_headers + 1], pattern = ",")[[1]]

  # If there are different lengths between the column names and the number of columns
  # in the data, then remove one column name.
  if(length(mk_col_names) > length(mk_first_data_line) & mk_col_names[length(mk_col_names)] == ""){
    mk_col_names <- mk_col_names[1:(length(mk_col_names)-1)]
  }

  # parse if date is good
  if(look_for_date){
    
    mk_content <- readr::read_csv(mk_request,
                                  col_names = FALSE,
                                  na = " ",
                                  skip = row_with_headers)
    names(mk_content) <- mk_col_names

    mk_content$Date <- mk_date_parse(date = as.character(mk_content$Date))
  } else {
    stop("The data couldn't be parsed.")
  }

  # Set attribtutes from the first five lines
  attr(x = mk_content, which = "info") <- first_8_lines[1:row_with_headers - 1]

  # remove last column if all are NA and the column name is ""
  if(names(mk_content)[length(names(mk_content))] == "" & all(is.na(mk_content[[length(names(mk_content))]]))){
    mk_content[[length(names(mk_content))]] <- NULL
  }
  # Clean names as they start with upper case and contain space
  # Remove headers named [empty]
  names(mk_content) <- stringr::str_trim(tolower(names(mk_content)), "both")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), " ", "_")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "/", "_")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "[+]", "")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "[%]", "")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "-", "_")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "\\[|\\]", "")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "\\(|\\)", "")
  if(names(mk_content)[length(names(mk_content))] == "" & all(is.na(mk_content[,length(names(mk_content))]))){
    mk_request <- mk_content[, stringr::str_length(names(mk_content)) != 0]
  }
  
  # Are there empty column names ("")?
  # - if they all are NA, then remove the column
  # - if they not all are NA then give it the name 'empty'
  if("" %in% names(mk_content)){
    if(all(is.na(mk_content[, names(mk_content) == ""]))){
      mk_content <- mk_content[, names(mk_content) != ""]
    } else {
      names(mk_content)[names(mk_content) == ""] <- "empty"
    }
  }

  return(mk_content)
}




