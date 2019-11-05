library(gdalUtils)

# Flora Abundance ----
grupos <- list.files("../Data/Raster/Results", full.names = T)
#studyArea <- "../Data/Vector/StudyArea.shp"
for (folder in grupos){
  # folder <- grupos[1]
  folder
  name <- dplyr::last(strsplit(folder, split = "/")[[1]])
  gdalwarp(
    srcfile = list.files(folder, 
                         pattern = "Prediction.tif$", 
                         full.names = TRUE), 
    dstfile = paste(folder, 
                    paste0(name, "_Merged.tif"), sep = "/"), 
    srcnodata = 0,
    #dstnodata = 9999,
    #cutline = studyArea, crop_to_cutline = TRUE,
    overwrite = TRUE)
}
