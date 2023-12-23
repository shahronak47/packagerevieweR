page_sidebar(
    title = "Package Reviewer",
    shinyjs::useShinyjs(),
    shiny::includeCSS('www/stylesheet.css'),
    theme = bs_theme(bootswatch = "solar"),
    sidebar = sidebar(id = "login",
            textInput('username', 'Username'), 
            passwordInput('password', 'Password', placeholder = 'Enter your password'), 
            actionButton('login_btn', 'Login'), 
            br(),
            p("Don't have an account? Sign up below!"),
            div(class = "sign_up_btn", id = "sign_up_btn", actionButton("sign_up", "Sign Up!")),
      ), 
      card(
         selectizeInput('selected_package', 'Select a package to view the reviews.', choices = NULL),
         shinycssloaders::withSpinner(uiOutput("avg_box")),
         uiOutput('your_review'), 
         h3("User Reviews : "),
         shinycssloaders::withSpinner(dataTableOutput('review_table'))
      )  
  )
