## Load libraries

library(shiny)
library(shinyRatings)
library(shinyalert)
library(shinyjs)

tmp <- available.packages()
all_packages <- rownames(tmp)

correct_login <- function(user, pass) {
  user == "shahronak47" && pass == "test"
}

is_valid_email <- function(email) {
  # Taken from https://www.r-bloggers.com/2012/07/validating-email-adresses-in-r/
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(email), ignore.case=TRUE)
}