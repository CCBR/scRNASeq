## grab args
args <- commandArgs(trailingOnly = TRUE)
DIR <- args[1]
Sys.setenv(RSTUDIO_PANDOC="/usr/local/apps/rstudio/rstudio-1.1.447/bin/pandoc/")#COMMENT OUT/CHANGE AS NEEDED
setwd(DIR) # new 
rmarkdown::render("scrna_multicluster.Rmd", output_file=paste0(args[5],"_scrna_multicluster_",args[3],"_",args[4],".html"), params = list(
  seurat = args[2],
  ccs = as.numeric(args[3]),
  resolution = as.numeric(args[4]),
  projectId = args[5],
  projectDesc = args[6]
))
