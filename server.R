library(shiny)
library(shinydashboard)

library(googlesheets)

saveData <- function(data) {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}


fields <- c("session_id", "date_time", "q1_answer", "q2_answer")
table <- "ppp-responses"

server <- function(input, output, session) {
  
  # protein files db
  dir <- "db/"
  # current selection, passed to the javascript file
  input_pdb <- paste0(dir, c("PF3D7_0608310_model1.pdb", "4k3c.pdb"),
                      collapse = ";")
  observe({
    session$sendCustomMessage(type='myCallbackHandler', message = input_pdb) 
  })
  
  # take values from radiobutton questions
  responseData <- reactive({
    data <- data.frame(
      session_id = shiny:::createUniqueId(16),
      datetime = Sys.time(),
      q1_answer = input$q1_answer,
      q2_answer = input$q2_answer
      )
    data
  })
  
  # When the submit button is clicked, save the results
  observeEvent(input$submit, {
    print(isolate(responseData()))
    saveData(responseData())
    session$reload()
  })
  
                  
}



