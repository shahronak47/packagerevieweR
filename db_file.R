library(odbc)
library(RMySQL)

create_connection_object <- function() {
  creds <- config::get()
  
  con <- RMySQL::dbConnect(
    RMySQL::MySQL(),
    user = creds$username,
    password = creds$password,
    dbname = creds$dbname,
    host = creds$host, 
    port = creds$port
  )
  con
}


insert_in_table <- function(email, username, password, first_name, last_name, otp_code, con) {
    # TO DO - Add a new column is_email_verified logical with TRUE/FALSE values or 1/0
    res <- DBI::dbSendQuery(con, glue::glue(                          
    "INSERT INTO users (id, email, username, password, first_name, last_name, otp_code) 
    VALUES (2, '{email}', '{username}', '{password}', '{first_name}', '{last_name}', '{otp_code}');"))
    if(NROW(res) > 0) {
      rows_affected <- DBI::dbGetRowsAffected(res)
      message(paste0("User was succesfully inserted into database"))
    }
}
