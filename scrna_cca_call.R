## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
Sys.setenv(RSTUDIO_PANDOC="/usr/local/apps/rstudio/rstudio-1.1.447/bin/pandoc/")#COMMENT OUT/CHANGE AS NEEDED
setwd(DIR) # new 
rmarkdown::render("scrna_cca.Rmd", output_file=paste0(args[4],"_scrna_cca.html"), params = list(
  seurat = as.character(unlist(strsplit(args[2], split=" "))),
  contrasts = as.character(unlist(strsplit(args[3], split=" "))),
  projectId = args[4],
  projectDesc = args[5]
))
