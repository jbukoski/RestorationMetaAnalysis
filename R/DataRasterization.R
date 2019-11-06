library(gdalUtils)
library(sf)
# Biomes and Countries data preparation

countries <- read_sf("../Data/Vector/Countries.shp") # crountry data for study area
#plot(st_geometry(countries))

VectorData <- list.files("../Data/Vector", 
                         full.names = T, 
                         pattern = 'Countries.shp$|ForestBiomes.shp$', recursive = T)

for (shp in VectorData){
  # shp <- VectorData[2]
  
  # if mosaicked result already exists, it wont run again
  overwriteResult <- T 
  
  # identifying group name
  name <- dplyr::last(strsplit(shp, split = "/")[[1]])
  name <- strsplit(name, split = '.shp')[[1]]
  rasterName <- paste0(name, "Raster.tif")
  
  # confirm if merged result already exists
  if (
    length(list.files(
      '../Data/Raster',  pattern = rasterName, full.names = T)) != 0){
    overwriteResult <- readline(prompt = paste("File", rasterName,"already exists. Overwrite? \n T/F: "))
  }
  
  # in case it exists and should be overwritten:
  if (overwriteResult){
    cat("Rasterizing", name, "\n")
    if (name != 'ForestBiomes'){
      # rasterizing countries to apply zonal stats
      gdal_rasterize(
        src_datasource = shp, 
        dst_filename = paste0("../Data/Raster/", rasterName), 
        a = "ID_Country", l = name, of = "GTiff", 
        a_nodata = 9999, te = c(-122.1189111747849978, -35.0000000000000000, 180.0000000000000000, 35.0000000000000000), tr = c(0.00898308, -0.00898357), q = FALSE)
      } else {
        gdal_rasterize(
          src_datasource = shp, 
          dst_filename = paste0("../Data/Raster/", rasterName), 
          a = "ID_Biome",
          l = name, of = "GTiff", 
          a_nodata = 9999, te = c(-122.1189111747849978, -35.0000000000000000, 180.0000000000000000, 35.0000000000000000), tr = c(0.00898308, -0.00898357), q = FALSE)
      }
    
  }
  
}
