#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    textInput("postdate", "Date uploaded", "Date in ISO format (2019-07-31)"),
    verbatimTextOutput("postdate"),
    
    textInput("name", "Name", "Please type your name here"),
    verbatimTextOutput("name"),
    
    textInput("email", "E-mail address", "type your email address here"),
    verbatimTextOutput("email"),
    
    textInput("label", "Data set label", "a short lable for your data"),
    verbatimTextOutput("label"),
    
    textInput("description", "Description", "a description of the data"),
    verbatimTextOutput("description")
    
   #tableOutput('table')
    
    
  )
  server <- function(input, output) {
    output$email <- email <- renderText({ input$email })
    output$postdate <- postdate <- renderText({ input$postdate })
    output$name <- name <- renderText({ input$name })
    output$label <- label <- renderText({ input$label })
    output$description <- description <- renderText({ input$description })
    
    #output$table <- renderTable(c(paste(email),paste(postdate),paste(name),paste(label),paste(description)))
    
    # output$table <- renderTable(
    #   rbind(c("email","postdate","name","label","description"),
    #         c(output$email,output$postdate,output$name,output$label,output$description)))
    # 
    
  }
  shinyApp(ui, server)
}
# Run the application 
shinyApp(ui = ui, server = server)

