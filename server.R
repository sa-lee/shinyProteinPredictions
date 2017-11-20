library(shiny)
library(shinydashboard)
library(googlesheets)
library(dplyr)
library(readr)
library(stringr)
library(V8)
library(shinyjs)

saveData <- function(data) {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}

sampleData <- function(tbl) {
  str_replace_all(as.character(sample_n(tbl, 1)[["message"]]),
                  "www/", "")
}

fields <- c("session_id", "date_time", "q1_answer", "q2_answer")
table <- "ppp-responses"
pdb <- read_rds("pdb.rds")

server <- function(input, output, session) {
  
  user <- reactiveValues(session_id = shiny:::createUniqueId(16))

  # protein files db preparation
  input_pdb <- reactiveValues(message = sampleData(pdb))

  # take values from radiobutton questions
  responseData <- reactive({
    data <- data.frame(
      session_id = isolate(user$session_id),
      datetime = Sys.time(),
      q1_answer = input$q1_answer,
      q2_answer = input$q2_answer,
      subject_pdb = str_extract(isolate(input_pdb$message), "(?<=;).*"),
      query_pdb = str_extract(isolate(input_pdb$message), ".*(?=;)")
    )
    data
  })
  
  observe({
    session$sendCustomMessage(type='myCallbackHandler', 
                              message = input_pdb$message) 
  })
  
  observeEvent(input$continue, {
    saveData(responseData())
    shinyjs::reset("q1_answer")
    shinyjs::reset("q2_answer")
    shinyjs::js$resetdiv()
    print(isolate(input_pdb$message))
    input_pdb$message <- sampleData(pdb)
  })

  # When the submit button is clicked, save the results
  observeEvent(input$submit, {
    print(isolate(responseData()))
    saveData(responseData())
    session$reload()
  })
  
}



