## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc")
setwd(DIR) # new 
rmarkdown::render("scrna_cca.Rmd", output_file=paste0(args[4],"_scrna_cca.html"), params = list(
  seurat = as.character(unlist(strsplit(args[2], split=" "))),
  contrasts = as.character(unlist(strsplit(args[3], split=" "))),
  projectId = args[4],
  projectDesc = args[5]
))
