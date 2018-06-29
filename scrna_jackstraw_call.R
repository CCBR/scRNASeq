## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc")
setwd(DIR) # new 
rmarkdown::render("scrna_jackstraw.Rmd", output_file=paste0(args[3],"_scrna_jackstraw.html"), params = list(
    seurat = args[2],
    projectId = args[3],
    projectDesc = args[4]
  ))

