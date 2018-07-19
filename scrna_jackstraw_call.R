## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
Sys.setenv(RSTUDIO_PANDOC="/usr/local/apps/rstudio/rstudio-1.1.447/bin/pandoc/")#COMMENT OUT/CHANGE AS NEEDED
setwd(DIR) # new 
rmarkdown::render("scrna_jackstraw.Rmd", output_file=paste0(args[3],"_scrna_jackstraw.html"), params = list(
    seurat = args[2],
    projectId = args[3],
    projectDesc = args[4]
  ))

