library(gdalUtils)
library(raster)
library(tibble)

# Mosaicking according to group analysis ----
grupos <- list.files("../Data/Raster/Results", full.names = T)
studyArea <- "../Data/Vector/StudyArea.shp"
CalcBioVariation <- TRUE

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
                           pattern = ".tif$", 
                           full.names = TRUE), 
      dstfile = paste(folder, 
                      paste0(name, "_Merged.tif"), sep = "/"), 
      srcnodata = 0,
      #dstnodata = 9999,
      cutline = studyArea, crop_to_cutline = TRUE,
      te = c(-122.1189111747849978, -35.0000000000000000, 180.0000000000000000, 35.0000000000000000), tr = c(0.00898308, -0.00898357),
      overwrite = TRUE)
    
    cat("Mosaic ", name, " done\n")
    
    # test if raster is no OOTR nor Restorable*
    if (!grepl("OOTR|Restorable", name)){
      r.landscape <- raster(
        paste(folder,
              paste0(name, "_Merged.tif"), sep = "/"))
      
      r.landscape <- setMinMax(r.landscape)
      
      # teste if raster must be normalized
      if (maxValue(r.landscape) != 1 ){
        cat("Normalizing raster values\n")
        r.landscape <- r.landscape/maxValue(r.landscape)
        
        r.landscape <- setMinMax(r.landscape)
        
        cat("Saving raster", name, "normalized \n")
        writeRaster(r.landscape, 
                    paste(folder,
                          paste0(name, "_Norm.tif"), sep = "/"), overwrite = TRUE)
        }
      
    }

  }
  
}
