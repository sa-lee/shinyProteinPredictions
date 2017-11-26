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
  #sheet <- gs_title(table)
  # Add the data as a new row
  #gs_add_row(sheet, ws = 1, input = data)
  tryCatch(readr::write_tsv(data, table, append = TRUE),
           error = function(e) e,
           finally = message("unable to write to file, use logs instead.")
  )
          
}

sampleData <- function(tbl) {
  str_replace_all(as.character(sample_n(tbl, 1)[["message"]]),
                  "www/", "")
}

fields <- c("session_id", "name", "date_time", "q1_answer", "q2_answer")
table <- "ppp-responses.txt"
pdb <- read_rds("pdb.rds")

server <- function(input, output, session) {
  
  user <- reactiveValues(session_id = shiny:::createUniqueId(16))

  # protein files db preparation
  input_pdb <- reactiveValues(message = sampleData(pdb))

  # take values from radiobutton questions
  responseData <- reactive({
    data <- tibble(
      session_id = isolate(user$session_id),
      name = ifelse(is.null(input$name), NA_character_, input$name),
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
    cat(">\n",
        str_c(isolate(responseData())[1,], collapse = "\t"),
        "\n>\n" 
    )
    saveData(responseData())
    shinyjs::reset("q1_answer")
    shinyjs::reset("q2_answer")
    shinyjs::js$resetdiv()
    input_pdb$message <- sampleData(pdb)
  })

  # When the submit button is clicked, save the results
  observeEvent(input$submit, {
    cat(">\n",
        str_c(isolate(responseData())[1,], collapse = "\t"),
        "\n>\n" 
    )
    saveData(responseData())
    cat("Game finished!\n")
    session$reload()
  })
  
}



