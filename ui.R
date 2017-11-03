library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "People Powered Protein Predictions!"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Let's Play!", tabName = "game", icon = icon("dashboard")),
      menuItem("About", tabName = "about", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "game",
              includeScript("www/pv.min.js"),
              tags$div(id = 'gl', style="width:800px; margin:0 auto;"),
              includeScript("www/message.js")
      ),
      
      # Second tab content
      tabItem(tabName = "about",
              h2("About the project.")
      )
    )
  )
)