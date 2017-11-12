makedb: 
							Rscript prepare_db.R

serve: 
							Rscript -e "shiny::runApp()"

install: 
							Rscript -e "install.packages(c('dplyr', 'readr', 'stringr', 'googlesheets', 'shiny', 'shinyjs', 'shinydashboard'))"