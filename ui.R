library(shinydashboard)
library(shinyjs)
response1 <- list("None selected" = 0,
                  "No match" = 1,
                  "Poor match" = 2,
                  "Ok match" = 3,
                  "Good match" = 4,
                  "Perfect match" = 5)

dashboardPage(
  dashboardHeader(title = "People Powered Protein Predictions!",
                  titleWidth = "600px"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      useShinyjs(),
      extendShinyjs("www/resetdiv.js"),
      includeScript("www/pv.min.js"),
      # First tab content
      box(title = "Let's Play!",
             id = "game",
             width = 12,
             height ="600px",
             side = "right",
             div(id = 'gl', 
                 style="width:600px; margin: auto;"),
          includeScript("www/message.js")
             
      ), 
      box(title = "How well does the predicted structure (blue) match the reference structure (orange)?",
          width = "6",
          radioButtons("q1_answer", "", choices = response1 , width = "100%", inline = TRUE)
      ),
      box(title =  "On a scale of 0-100, how confident are you in your prediction? ",
          width = "6",
          sliderInput("q2_answer", "0 means you are completely unsure. 100 means you are completely certain.", 0, 100, 50)
      ),
      box(title = "Try Again?",
          width = "12",
      textOutput("times_played"),
      br(),
      actionButton("continue", "Keep Playing", icon("play")),
      actionButton("form", "Finished?", icon("refresh")),
      conditionalPanel("input.form", 
                       textInput("name", "What's your name?"),
                       actionButton("submit", "Submit", icon("archive"))
                       )
      )
    )
  )
)