## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
Sys.setenv(RSTUDIO_PANDOC="/usr/local/apps/rstudio/rstudio-1.1.447/bin/pandoc/")#COMMENT OUT/CHANGE AS NEEDED
setwd(DIR) # new 
rmarkdown::render("scrna_initial.Rmd", output_file=paste0(args[4],"_scrna_initial.html"), params = list(
    matrix = args[2],
    species = args[3],
    projectId = args[4],
    projectDesc = args[5],
    mattype = args[6],
    doCycleRegress = args[7]
  ))

