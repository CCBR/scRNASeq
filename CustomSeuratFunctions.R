### This function psuedocolors the expression of two genes concurrently
CoexpressionPlot <- function(so, feature.1, feature.2){
  feature.1.exprs <- FetchData(so, feature.1)
  feature.2.exprs <- FetchData(so, feature.2)
  feature.1.scale <- 1/max(feature.1.exprs)
  feature.2.scale <- 1/max(feature.2.exprs)
  clrs <- rgb(feature.1.exprs*feature.1.scale, feature.2.exprs*feature.2.scale, 0)
  tsne <- GetDimReduction(object = so_combined, reduction.type = "tsne", slot = "cell.embeddings")
  tsne.df <- as.data.frame(tsne)
  alpha.scale = (max((col2rgb(clrs)[1,])+(col2rgb(clrs)[2,]))+1)
  ggplot(tsne.df, aes(x=tSNE_1, y=tSNE_2)) + geom_point(color=clrs, alpha=(((col2rgb(clrs)[1,])+(col2rgb(clrs)[2,])+1)/alpha.scale)) + theme(legend.position="none") +
    annotate(geom="text", label=feature.1, x = min(tsne.df$tSNE_1), y= max(tsne.df$tSNE_2), hjust = 0, vjust = 1, color = rgb(1,0,0)) +
    annotate(geom="text", label=feature.2, x = min(tsne.df$tSNE_1), y= max(tsne.df$tSNE_2), hjust = 0, vjust = 3, color = rgb(0,1,0))
}

### This function generates a density histogram of feature expression
### Contrasts categorical grouping using a type from meta.data
FeatureDensity <- function(so, feature, grouping){
  exprs <- FetchData(so, feature)
  meta <- so@meta.data[[grouping]]
  dat <- data.frame(dens = as.numeric(exprs), lines = meta)
  ggplot(dat,aes(x=dens,fill=lines)) + geom_density(alpha=0.2) +
    ggtitle(feature) +
    xlab("Expression")
}