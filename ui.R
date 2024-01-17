page_navbar(
    title = "Package Reviewer",
    header = tagList(
      shinyjs::useShinyjs(),
      shiny::includeCSS('www/stylesheet.css')
    ),
    theme = bs_theme(bootswatch = "pulse"),
    sidebar = sidebar(id = "login",
            textInput('username', 'Username'), 
            passwordInput('password', 'Password', placeholder = 'Enter your password'), 
            actionButton('login_btn', 'Login'), 
            br(),
            p("Don't have an account? Sign up below!"),
            div(class = "sign_up_btn", id = "sign_up_btn", actionButton("sign_up", "Sign Up!"))
      ), 
    bslib::nav_panel(title = "Reviews",
      card(
         selectizeInput('selected_package', 'Select a package to view the reviews.', choices = NULL),
         shinycssloaders::withSpinner(uiOutput("avg_box")),
         uiOutput('your_review'), 
         h3("User Reviews : "),
         shinycssloaders::withSpinner(dataTableOutput('review_table'))
      )  
    ), 
    # bslib::nav_panel(title = "About",
    #                  p("About")
    # ),
    # bslib::nav_panel(title = "Contact",
    #                  p("Contact")
    # ),
    nav_spacer(),
    nav_item(
      input_dark_mode(id = "dark_mode", mode = "light")
    ),
  )
