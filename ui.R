fluidPage(
    # Application title
    titlePanel("Package Reviewer"),
    selectizeInput('selected_package', 'Select a package to review', choices = NULL),
    shinyRatings('ratings'), 
    textOutput('text'), 
    actionButton('submit', 'Submit')
)
