## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc")
setwd(DIR) # new 
rmarkdown::render("scrna_cluster.Rmd", output_file=paste0(args[5],"_scrna_cluster_",args[3],"_",args[4],".html"), params = list(
    seurat = args[2],
    pcs = as.numeric(args[3]),
    resolution = as.numeric(args[4]),
    projectId = args[5],
    projectDesc = args[6]
  ))

