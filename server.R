function(input, output, session) {
  
  updateSelectizeInput(session, 'selected_package', choices = all_packages, server = TRUE)
  
  output$text <- renderText({sprintf("You rated it as %s stars", input$ratings)})
  
  observeEvent(input$submit, {
    shinyalert("Sucessfull!",  type = "success", "Your review has been submitted.", timer = 3000)
  })
  
  observeEvent(input$sign_up, {
    shinyalert::shinyalert("Thank You!", "Access to the app is currently available only via invite. Please email shahronak47@yahoo.in to get access to the app.")
  })
}
