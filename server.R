function(input, output, session) {
  
  rv <- reactiveValues(is_login = FALSE, otp_code = NULL, con = NULL)
  rv$con <- create_connection_object()
  
  updateSelectizeInput(session, 'selected_package', choices = all_packages, server = TRUE)
  
  output$text <- renderText({
    req(rv$is_login)
    sprintf("You rated it as %s stars", input$ratings)
  })
  
  output$your_review <- renderUI({
    req(rv$is_login)
    tagList(
      shinyRatings('ratings'), 
      textOutput('text'), 
      textAreaInput("review", "Add your Review (optional)"),
      actionButton('submit', 'Submit')
    )
  })
  
  #### On Login ####
  observeEvent(input$login_btn, {
    if(correct_login(input$username, input$password)) {
      rv$is_login <- TRUE
      hide('login')
    }
  })
  
  observeEvent(input$submit, {
    shinyalert("Sucessfull!",  type = "success", "Your review has been submitted.", timer = 3000)
  })
  
  #Sign Up modal
  observeEvent(input$sign_up, {
    showModal(
      modalDialog(title = "Sign Up!", 
        tagList(
          # TO DO - Arrange them next to each other in 2 columns instead of doing it one after another in a single column
          textInput('first_name', 'First Name'), 
          textInput('last_name', 'Last Name'),
          textInput('sign_up_username', 'Pick a username'),
          passwordInput('sign_up_password', 'Select your password'),
          textInput('sign_up_email', 'Enter your email'),
          actionButton('verification_btn', 'Send Verification code'),
          br(), br(),
          div(id = "verify", 
            fluidRow(
              textInput('code', 'Enter verification code'), 
              actionButton('code_btn', 'Verify')
            )
          )
        )
      )
    )
    shinyjs::hide('verify')
  })
  
  observeEvent(input$verification_btn, {
    if(is_valid_email(input$sign_up_email)) {
      shinyjs::show('verify')
      #rv$otp_code <- generate_random_code()
      rv$otp_code <- 123
      # email_template(rv$otp_code) |>
      #   smtp_send(
      #     to = input$sign_up_email,
      #     from = "shahronak47@gmail.com",
      #     subject = "Code Email",
      #     credentials = creds_file("gmail_creds")
      #   )
    } else {
      shinyalert("Wrong email", paste("The email entered", input$sign_up_email, "is not a valid email."))
    }
  })
  
  observeEvent(input$code_btn, {
    if(input$code == rv$otp_code){
      removeModal()
      insert_in_table(input$sign_up_email, input$sign_up_username, input$sign_up_password, input$first_name, input$last_name, rv$otp_code, rv$con)
      shinyalert("Success!!", "Email address verified", type = "success", immediate = TRUE, timer = 3000)
    }
    else {
      shinyalert("Error!!", "Incorrect code entered. Try again!", type = "error", immediate = TRUE)
    }
    
      
  })
}
