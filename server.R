library(shiny)
library(shinydashboard)
# Define server logic required to draw a histogram

server <- function(input, output, session) {
  
  dir <- "db/"
  input_pdb <- paste0(dir, c("PF3D7_0608310_model1.pdb", "4k3c.pdb"),
                      collapse = ";")
  observe({
    session$sendCustomMessage(type='myCallbackHandler', message = input_pdb) 
  })
                  
}



