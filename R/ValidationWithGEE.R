library(rgdal)
library(raster)
library(sf)
library(tmap)

# Open buffer example
buffer <- read_sf("../Data/Buffer_validation.geojson", "Buffer_validation")
plot(st_geometry(buffer))

GEEstats <- read.csv("../Data/CECstats.csv")[,c(2,3)]
GEEstats$StudySite <- "Site 269"
# Open Soil CEC to have statistics taken
cec <- raster("../soil_CEC_30cm_1km.tif")
cec <- crop(cec, buffer)
cec <- mask(cec, buffer)

# Taking statistics
statsR <- matrix(data = NA, 1,3)
statsR[1,1] <- 'Site 269'
statsR[1,2] <- extract(cec, buffer, fun = mean, na.rm = TRUE)
statsR[1,3] <- extract(cec, buffer, fun = sd, na.rm = TRUE)
statsR <- as.data.frame(statsR)
names(statsR) <- c("StudySite", "CEC_Mean", "CEC_sd")
write.csv(statsR, "CEC_Rstats.csv", row.names = FALSE)

# map
tmap_mode("view")
tm_shape(cec, maxpixels = 5000) + 
  tm_raster("soil_CEC_30cm_1km", palette = terrain.colors(10) ) +
  tm_shape(buffer) + 
  tm_borders("black")

# slope analysis
slope <- raster("../Data/ValidationData/slope_test.tif")
#site27 <- read_sf("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Data/Database_18_06_01.shp") %>% 
#  dplyr::filter(Site == 27)
site59 <- read_sf("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Data/Database_18_06_01.shp") %>% 
  dplyr::filter(Site == 59)

compare <- read.csv("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/Data/results/Biodiversity_Revision.csv") %>% 
  dplyr::filter(Site == 59) %>% 
  dplyr::select(slope_05Km, slope_10Km, slope_25Km, slope_50Km, slope_75Km, slope_100Km)

vals <- extract(slope, site59)

# kernel R
#Kernel circular
circular.focal.matrix <- function(cellsize, radius){
  n <- (radius / cellsize) * 2 + 1
  m <- matrix(1, nrow=n, ncol=n)
  a <- (radius / cellsize)
  b <- a + 1
  
  for (i in 1:a){
    for (j in 1:a){
      if (sqrt(i^2 + j^2) > a){
        m[b+i, b+j] <- 0
        m[b+i, b-j] <- 0
        m[b-i, b+j] <- 0
        m[b-i, b-j] <- 0
      }
    }
  }
  return(m)
}

class(compare)
buffers <- c(5, 10, 25, 50, 75, 100)
for (buffer in buffers){
  # buffer <- 10
  kernel <- circular.focal.matrix(1, buffer)
  focalR <- focal(slope, kernel, "sum", na.rm=TRUE) / sum(kernel)
  compare[2, which(buffer==buffers)] <- extract(focalR, site59)
}
compare$tool <- c("GEE", "R")

compare %>% tidyr::gather(key = "buffer", value = "value", -tool) %>% 
  tidyr::spread(tool, value) %>%
  dplyr::mutate( dif = GEE - R) %>% 
  format(scientific=F)

# map
tmap_mode("view")
tm_shape(slope[[1]], maxpixels = 5000) + 
  tm_raster("slope_test", palette = terrain.colors(10) ) +
  tm_shape(site27) + 
  tm_borders("black")
