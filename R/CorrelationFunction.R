# rm(list=ls())

sp.corrAnalysis <- function(r.model, npts, ...){

  # loading library
  library(raster)
  library(dplyr)
  library(pgirmess)
  
  # output drectory
  outDir <- "./CorrelationResults"
  
  # testign if output dir exists
  # if not, will be created
  if (! dir.exists(outDir)){
    dir.create(outDir)
  }
  
  # generating random points
  df.pts <- as_tibble(
    sampleRandom(
      r.model, npts*5, xy = TRUE, sp = FALSE, na.rm = TRUE))
  
  # getting model name to use when saving as csv
  modelName <- colnames(df.pts)[ncol(df.pts)]
  
  # saving as csv
  write_csv(df.pts, paste0(outDir, "/", modelName, "_rndPts.csv"))
  
  # estimating correlog
  modelCorrelog <- pgirmess::correlog(coords = df.pts[,c(1:2)], 
                          z = df.pts[[ncol(df.pts)]])
 
  # saving correlog result as csv
  write_csv(as_tibble(modelCorrelog), paste0(outDir, "/", modelName, "_moranCorrelog.csv"))

  # saving correlog plot
  png(paste0(outDir, "/", modelName, "_moranCorrelog.png"))
  plot(modelCorrelog)
  dev.off()
  }
