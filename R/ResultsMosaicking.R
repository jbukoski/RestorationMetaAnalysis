library(gdalUtils)

# Mosaicking according to group analysis ----
grupos <- list.files("../Data/Raster/Results", full.names = T)
studyArea <- "../Data/Vector/StudyArea.shp"
for (folder in grupos){
  # folder <- grupos[1]
  
  # if mosaicked result already exists, it wont run again
  overwriteResult <- T 
  
  # identifying group name
  name <- dplyr::last(strsplit(folder, split = "/")[[1]])
  
  # confirm if merged result already exists
  if (
    length(list.files(
    folder,  pattern = "Merged.tif$", full.names = T)) != 0){
    overwriteResult <- readline(prompt = paste("File", name,"already exists. Overwrite? \n T/F: "))
  }
  
  # in case it exists and should be overwritten:
  if (overwriteResult){
    cat("Mosaicking", name, "\n")
    gdalwarp(
      srcfile = list.files(folder, 
                           pattern = "Prediction.tif$", 
                           full.names = TRUE), 
      dstfile = paste(folder, 
                      paste0(name, "_Merged.tif"), sep = "/"), 
      srcnodata = 0,
      #dstnodata = 9999,
      cutline = studyArea, crop_to_cutline = TRUE,
      te = c(-122.1189111747849978, -35.0000000000000000, 180.0000000000000000, 35.0000000000000000), tr = c(0.00898308, -0.00898357),
      overwrite = TRUE)
  }
  
}
