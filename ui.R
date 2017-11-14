library(shinydashboard)

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
      shinyjs::useShinyjs(),
      includeScript("www/pv.min.js"),
      # First tab content
      box(title = "Let's Play!",
             id = "game",
             width = 12,
             height ="600px",
             side = "right",
             tags$div(id = 'gl', style="width:600px; margin: auto;"),
             includeScript("www/message.js")
      ), 
      box(title = "How well does the predicted structure (blue) match the reference structure (orange)?",
          width = "6",
          radioButtons("q1_answer", "", choices = response1 , width = "100%", inline = TRUE)
      ),
      box(title =  "How confident are you in your prediction?",
          width = "6",
          radioButtons("q2_answer", "", choices = response2 , inline = TRUE)
      ),
      box(title = "Try Again?",
          width = "12", 
      actionButton("continue", "Keep Playing", icon("play")),
      actionButton("submit", "Finished?", icon("refresh"))
      )
    )
  )
)