fluidPage(
    shiny::includeCSS('www/stylesheet.css'),
    shiny::fluidRow(
      column(10, titlePanel("Package Reviewer")),  
      column(2, div(class = "sign_up_btn", actionButton("sign_up", "Sign Up!")))
    ),
    selectizeInput('selected_package', 'Select a package to view the reviews.', choices = NULL),
    shinyRatings('ratings'), 
    textOutput('text'), 
    actionButton('submit', 'Submit')
)
