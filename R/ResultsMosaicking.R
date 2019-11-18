library(gdalUtils)
library(raster)
library(tibble)

# Mosaicking according to group analysis ----
grupos <- list.files("../Data/Raster/Results", full.names = T)
studyArea <- "../Data/Vector/StudyArea.shp"
CalcBioVariation <- TRUE
r.restorableAmount <- raster("../Data/Raster/Results/RestorableAmount/RestorableAmount_Merged.tif")

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
    
    warning("Mosaic ", name, " done\n")
    
    # test if raster must be normailized
    if (!grepl("OOTR|Restorable", name)){
      r.landscape <- raster(
        paste(folder,
              paste0(name, "_Merged.tif"), sep = "/"))
      
      r.landscape <- setMinMax(r.landscape)
      if (maxValue(r.landscape) != 1 ){
        cat("Normalizing raster values\n")
        r.landscape <- r.landscape/maxValue(r.landscape)
        
        cat("Saving raster", name, "normalized \n")
        writeRaster(r.landscape, 
                    paste(folder,
                          paste0(name, "_Norm.tif"), sep = "/"))
        }
      
    }
    
    # test if Biodiversity variation recovery must be calculated
    if (CalcBioVariation){
      r.restorableAmount <- setMinMax(r.restorableAmount)
      r.BioVar <- r.landscape/r.restorableAmount
      r.BioVar <- r.BioVar/maxValue(r.BioVar)
      
      cat("Saving biodiversity recovery variation for", name, "\n")
      writeRaster(r.BioVar, 
                  paste(folder,
                        paste0(name, "_BioVar.tif"), sep = "/"), overwrite = TRUE)
      
      # cat("Exporting biodiversity recovery variation results for", name, "\n")
      # t.BioVar <- as_tibble( # no working yet
      #   as.data.frame(r.BioVar))
      # t.BioVar <- na.omit(t.BioVar)
      # write_csv(t.BioVar, paste0("../Data/CSV/Results/", name, "_BioVar.csv"))
      # 
      # cat("Saving histogram for", name, "\n")
      # ggplot(dat, aes(x = breaks, y = counts, fill =counts)) + ## Note the new aes fill here
        # geom_bar(stat = "identity",alpha = 0.8)
      }

  }
  
}
