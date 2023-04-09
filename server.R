function(input, output, session) {
  
  rv <- reactiveValues(is_login = FALSE)
  
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
  
  # On Login
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
          textInput('sign_up_email', 'Enter your email'),
          actionButton('verification_btn', 'Send Verification code'),
          textInput('code', 'Enter verification code')
        )
      )
    )
    shinyjs::hide('code')
  })
  
  observeEvent(input$verification_btn, {
    if(is_valid_email(input$sign_up_email)) {
      shinyjs::show('code')
    } else {
      shinyalert("Wrong email", paste("The email entered", input$sign_up_email, "is not a valid email."))
    }
  })
}
