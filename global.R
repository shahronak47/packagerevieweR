## Load libraries

library(shiny)
library(shinyRatings)
library(shinyalert)
library(shinyjs)
library(blastula)
library(bslib)
library(DT)
library(digest)
## Source files

options(repos = c("CRAN" = "https://cran.rstudio.com/"))
source('db_file.R')

tmp <- available.packages()
all_packages <- rownames(tmp)

correct_login <- function(user, pass, con) {
  out <- DBI::dbGetQuery(con, glue::glue("SELECT password from users where username = '{user}'"))
  out$password %in% digest::digest(pass)
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

check_username <- function(username, rv) {
  out <- DBI::dbGetQuery(rv$con, glue::glue("SELECT * from users where username = '{username}'"))
  if(nrow(out) > 0) {
    shinyalert("Error!!", "Username is taken. Please choose another username.", type = "error", immediate = TRUE)
    rv$is_valid <- FALSE
  } else {
    rv$is_valid <- TRUE
  }
}

check_email <- function(email, rv) {
  out <- DBI::dbGetQuery(rv$con, glue::glue("SELECT * from users where email = '{email}'"))
  if(nrow(out) > 0) {
    shinyalert("Error!!", "Email is already registered!. Please choose another username.", type = "error", immediate = TRUE)
    rv$is_valid <- FALSE
  } else {
    rv$is_valid <- TRUE
  }
}


about_text <- function() {
  tagList(
    p("R has more than 20k packages now. Some packages like dplyr, data.table, ggplot2 etc are very well known and are reliable. Most R developers know and trust them."),
    p("However, there are some packages which are very specific, they do a very specific thing. 
    Sometimes there are also multiple packages who do the same thing. 
    It can be difficult to choose one package which suits your needs perfectly when you have not heard about that package before. 
    You don’t know which one to choose. There’s no way to compare them or get some feedback. 
    Do I trust this package? Is it reliable? Are there any security issues with the package? 
    What is the opinion of other developers who have used this package before? What do they think? 
    I am trying to answer all these questions with my project called Package Reviewer."),
    p("Goal of package reviewer is to be a review site where people can review the packages that they have used. 
      They can assign 0.5-5 stars to the package and add reviews in text form. It is google reviews for packages.
      Viewing reviews does not need an account. However, if you want to post a review then you need to create an account by sharing your email address.")
  )
}


next_text <- function() {
  tagList(
    h4("If there is enough interest in this project then I have list of things that I can work on : "), 
    shiny::HTML("<p>
            <ul>
              <li>Allow individuals to own their package and reply to reviews.</li>
              <li>Show most used keywords for a package.</li>
              <li>Move DB from free version to more secure and professional option.</li>
            </ul>
          </p>
         "), 
    p("If you think there is something else that can be useful here, feel free to email me at shahronak47[at]yahoo[dot]in")
  )
}

