function(input, output, session) {
  
  rv <- reactiveValues(is_login = FALSE, otp_code = NULL, con = NULL, is_valid = TRUE, not_submitted = FALSE)
  rv$con <- create_connection_object()
  
  updateSelectizeInput(session, 'selected_package', choices = all_packages, server = TRUE)
  
  output$text <- renderText({
    req(rv$is_login)
    sprintf("You rated it as %s stars", input$ratings)
  })
  
  output$your_review <- renderUI({
    req(rv$is_login)
    if(isTRUE(rv$not_submitted)) {
      tagList(
        shinyRatings('ratings'), 
        textOutput('text'), 
        textAreaInput("review", "Add your Review (optional)"),
        actionButton('submit', 'Submit'),
        br(), br()
      )
    }
  })
  
  #### On Login ####
  observeEvent(input$login_btn, {
    if(correct_login(input$username, input$password, rv$con)) {
      rv$is_login <- TRUE
      hide('login')
      hide('sign_up_btn')
    } else {
      shinyalert("Error!", "Wrong username/password combination")
    }
  })
  
  #### Submit the review ####
  observeEvent(input$submit, {
    insert_review(input$username, input$ratings, input$review, input$selected_package, rv$con)
    shinyalert("Sucessfull!",  type = "success", "Your review has been submitted.", timer = 3000)
    updateTextInput(session, "review", value = "")
  })
  
  #### Sign Up modal ####
  observeEvent(input$sign_up, {
    showModal(
      modalDialog(
        title = "Sign Up!", 
        tagList(
          fluidRow(
            column(6, textInput('first_name', 'First Name *')), 
            column(6, textInput('last_name', 'Last Name *'))
          ),
          fluidRow(
            column(6, textInput('sign_up_username', 'Pick a username *')), 
            column(6, passwordInput('sign_up_password', 'Select your password *'))
          ),
          fluidRow(
            column(6, textInput('sign_up_email', 'Enter your email *')),
            column(6, actionButton('verification_btn', 'Send Verification code'))
          ),
          br(), br(),
          div(id = "verify", 
              fluidRow(
                column(6, textInput('code', 'Enter verification code')), 
                column(6, actionButton('code_btn', 'Verify'))
              )
          )
        )
      )
    )
    shinyjs::hide('verify')
  })
  #### Send email OTP Verification ####
  observeEvent(input$verification_btn, {
    if(is_valid_email(input$sign_up_email)) {
      check_username(input$sign_up_username, rv)
      check_email(input$sign_up_email, rv)
      if(rv$is_valid) {
      shinyjs::show('verify')
      rv$otp_code <- generate_random_code()
      email_template(rv$otp_code) |>
        smtp_send(
          to = input$sign_up_email,
          from = "shahronak47@gmail.com",
          subject = "Code Email",
          credentials = creds_file("gmail_creds")
        )
      }
    } else {
      shinyalert("Wrong email", paste("The email entered", input$sign_up_email, "is not a valid email."))
    }
  })
  #### OTP Verify ####
  observeEvent(input$code_btn, {
    if(input$code == rv$otp_code){
      removeModal()
      password <- digest::digest(input$sign_up_password)
      insert_in_table(input$sign_up_email, input$sign_up_username, password, input$first_name, input$last_name, rv$otp_code, rv$con)
      shinyalert("Success!!", "Email address verified", type = "success", immediate = TRUE, timer = 3000)
    }
    else {
      shinyalert("Error!!", "Incorrect code entered. Try again!", type = "error", immediate = TRUE)
    }
  })
  
  #### Fetch reviews for selected package ####
  observeEvent(input$selected_package, {
    dt <- get_review(input$selected_package, rv$con)
    # If this user has already not submitted a review for this package
    rv$not_submitted <- rv$is_login && !input$username %in% dt$username
      
    output$avg_box <- renderUI({
      mn <- mean(dt$no_of_stars)
      if(is.na(mn)) mn <- "No"
      tagList(
        div(class = "h1-span-container",
          h1(mn),
          span("average rating")
        )
      )
    })
    
    output$review_table <- DT::renderDataTable({
      req(input$selected_package)
      DT::datatable(dt, 
        options = list(columnDefs = list(list(width = '50px', targets = c(0, 1)), 
                                         list(width = '100px', targets =c(2)))))
    })
    
  })
  
}
