## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc")
setwd(DIR) # new 
rmarkdown::render("scrna_initial.Rmd", params = list(
    matrix = args[2],
    species = args[3],
    projectId = args[4],
    projectDesc = args[5],
    mattype = args[6]
  ))

