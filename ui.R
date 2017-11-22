library(shinydashboard)
library(shinyjs)
response1 <- list("None selected" = 0,
                  "No match" = 1,
                  "Poor match" = 2,
                  "Ok match" = 3,
                  "Good match" = 4,
                  "Perfect match" = 5)

response2 <- list("None selected" = 0,
                  "Completely unsure" = 1,
                  "Somewhat unsure" = 2,
                  "Neither sure or unsure" = 3,
                  "Somewhat sure" = 4,
                  "Completely sure" = 5)
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
      box(title = "How well does the predicted structure (blue) match the reference structure (orange)? (0 is no match, 100 is perfect match)",
          width = "6",
          sliderInput("q1_answer", NULL, 0, 100, 50)
      ),
      box(title =  "How confident are you in your prediction? (0 is completely unsure, 100 is completely certain)",
          width = "6",
          sliderInput("q2_answer", NULL, 0, 100, 50)
      ),
      box(title = "Try Again?",
          width = "12", 
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