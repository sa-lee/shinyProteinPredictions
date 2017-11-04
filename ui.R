library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "People Powered Protein Predictions!"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      # First tab content
      box(title = "Let's Play!",
             id = "game",
             width = 12,
             height ="600px",
             side = "right",
             includeScript("www/pv.min.js"),
             tags$div(id = 'gl', style="width:600px; margin: auto;"),
             includeScript("www/message.js")
      ), 
      box(title = "Questions",
          width = 12,
          radioButtons("q1_answer", "Q1?", choices = 1:5, inline = TRUE),
          radioButtons("q2_answer", "Q2?", choices = 1:5, inline = TRUE),
          actionButton("submit", "Sumbit Your Answer", icon("refresh"))
      )
    )
  )
)