## Load libraries

library(shiny)
library(shinyRatings)
library(shinyalert)
library(shinyjs)
library(blastula)
library(bslib)
## Source files

source('db_file.R')

#tmp <- available.packages()
#all_packages <- rownames(tmp)

correct_login <- function(user, pass, con) {
  out <- DBI::dbGetQuery(con, glue::glue("SELECT password from users where username = '{user}'"))
  out$password == pass
}

is_valid_email <- function(email) {
  # Taken from https://www.r-bloggers.com/2012/07/validating-email-adresses-in-r/
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(email), ignore.case=TRUE)
}

generate_random_code <- function() {
  paste0(sample(0:9, 6, replace = TRUE), collapse = '')
}

email_template <- function(code) {
  date_time <- add_readable_time(lubridate::now(tz = 'UTC'))
  
  email <-
    compose_email(
      body = md(glue::glue(
        "Hello, please use this {code} to verify your account.")),
      footer = md(glue::glue("Email sent on {date_time}."))
    )
  email
}


