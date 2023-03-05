function(input, output, session) {
  
  updateSelectizeInput(session, 'selected_package', choices = all_packages, server = TRUE)
  
  output$text <- renderText({sprintf("You rated it as %s stars", input$ratings)})
  
  observeEvent(input$submit, {
    shinyalert("Sucessfull!",  type = "success", "Your review has been submitted.", timer = 3000)
  })
}
