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
    
    max_id <- DBI::dbGetQuery(con, 'select max(id) as id from signup_data.users')
    max_id <- max_id$id + 1
    res <- DBI::dbSendQuery(con, glue::glue(                          
    "INSERT INTO users (id, email, username, password, first_name, last_name, otp_code) 
    VALUES ({max_id}, '{email}', '{username}', '{password}', '{first_name}', '{last_name}', '{otp_code}');"))
    if(NROW(res) > 0) {
      rows_affected <- DBI::dbGetRowsAffected(res)
      message(glue::glue("User {username} was succesfully inserted into database"))
    }
}

insert_review <- function(username, no_of_stars, review, selected_package, con) {
  DBI::dbSendQuery(con, glue::glue("
  INSERT INTO reviews (username, no_of_stars, review, package_name, language)
  VALUES ('{username}', {no_of_stars}, '{review}', '{selected_package}', 'R');"))
}

get_review <- function(selected_package, con) {
  DBI::dbGetQuery(con, glue::glue("SELECT username, no_of_stars, review from reviews where package_name = '{selected_package}'"))
}



