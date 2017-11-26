makedb: 
							Rscript prepare_db.R

serve:
							touch ppp-responses.txt
							Rscript -e "shiny::runApp()"

install: 
							Rscript -e "install.packages(c('dplyr', 'readr', 'stringr', 'googlesheets', 'shiny', 'shinyjs', 'shinydashboard', 'V8', 'rsconnect'), repos = 'https://cran.ms.unimelb.edu.au/')"

deploy:
							Rscript -e "options(repos=c(CRAN='https://cran.ms.unimelb.edu.au/')); rsconnect::deployApp(appFiles = c('pdb.rds', 'server.R', 'ui.R', 'www/'))"