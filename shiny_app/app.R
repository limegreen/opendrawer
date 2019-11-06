library(shiny)

# create the ui
ui <- fluidPage(
  
  # Application title
  titlePanel("Free the Data (or SPRING or NECTAR)"),
  mainPanel( 
    
    # each of the sections of code below create a text input box with a title
    textInput("postdate", "Date uploaded", "Date in ISO format (2019-07-31)"),
    verbatimTextOutput("postdate"), # this line simply displays what has been inputted into the text field
    
    textInput("name", "Name", "Please type your name here"),
    verbatimTextOutput("name"),
    
    textInput("email", "E-mail address", "type your email address here"),
    verbatimTextOutput("email"),
    
    textInput("label", "Data set label", "a short lable for your data"),
    verbatimTextOutput("label"),
    
    textInput("description", "Description", "a description of the data"),
    verbatimTextOutput("description")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # The lines below create objects from the input
  output$email <- email <- renderText({ input$email })
  output$postdate <- postdate <- renderText({ input$postdate })
  output$name <- name <- renderText({ input$name })
  output$label <- label <- renderText({ input$label })
  output$description <- description <- renderText({ input$description })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

