fluidPage(
    shinyjs::useShinyjs(),
    shiny::includeCSS('www/stylesheet.css'),
    shiny::fluidRow(
      column(10, titlePanel("Package Reviewer")),  
      column(2, div(class = "sign_up_btn", id = "sign_up_btn", actionButton("sign_up", "Sign Up!")))
    ),
    sidebarLayout(
      sidebarPanel(id = "login",
            textInput('username', 'Username/Email'), 
            passwordInput('password', 'Password', placeholder = 'Enter your password'), 
            actionButton('login_btn', 'Login')
      ), 
      mainPanel(
             selectizeInput('selected_package', 'Select a package to view the reviews.', choices = NULL),
             shinycssloaders::withSpinner(uiOutput("avg_box")),
             uiOutput('your_review'), 
             h3("User Reviews : "),
             shinycssloaders::withSpinner(dataTableOutput('review_table'))
      )  
    )
)
