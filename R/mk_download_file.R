
#' Function to download a file from MKonline
#'
#' @param mk_user
#' @param mk_password
#' @param mk_file The key (as in file) to download (ex CON_POW_H_A)
#' @param mk_area The key from area (ex: cee, cwe, np, it etc.)
#' @export
mk_download_file <- function(mk_user, mk_password, mk_file, mk_area){


  # Make the request and use basic authentication to access the list files csv file
  mk_request <- httr::GET(url = paste0("http://download.mkonline.com/download-file?", "file=", mk_file, "&area=", mk_area,"&separator=period"),
                          httr::authenticate(user = mk_user, password = mk_password))

  # Make sure that the request is valid
  httr::stop_for_status(mk_request)

  # Get and parse content
  mk_request <- httr::content(x = mk_request, as = "text")
  mk_content <- readr::read_csv(mk_request, skip = 6, col_type = list(Date = readr::col_character()))

  # Set attribtutes from the first five lines
  attr(x = mk_content, which = "info") <- cat(readr::read_lines(mk_request, n_max = 5))

  # Clean names as they start with upper case and contain space
  # Remove headers named [empty]
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), " ", "_")
  names(mk_content) <- stringr::str_replace_all(tolower(names(mk_content)), "/", "_")
  if(sum(stringr::str_detect(names(mk_content), "[empty]"))){
    mk_request <- mk_content[, !stringr::str_detect(names(mk_content), "empty")]
  }

  return(mk_request)
}




