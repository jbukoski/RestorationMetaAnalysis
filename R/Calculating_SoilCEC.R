# Cation exchange capacity of soil in cmolc/kg on four different soil depth (0,5,15,30 cm)
# install.packages("raster")
library(raster)

s1 <- raster("../Data/SoilGrid/CECSOL_M_sl1_1km_ll.tif")
s2 <- raster("../Data/SoilGrid/CECSOL_M_sl2_1km_ll.tif")
s3 <- raster("../Data/SoilGrid/CECSOL_M_sl3_1km_ll.tif")
s4 <- raster("../Data/SoilGrid/CECSOL_M_sl4_1km_ll.tif")
plot(s1, maxpixels = 5000)

# Calculating Cation Exchange Capacity for all depth until 30cm
overlay(s1, s2, s3, s4, fun = function(a, b, c, d){(1/(30*2)*((5-0)*(a+b)+(15-5)*(b+c)+(30-15)*(c+d)))}, filename = "../Data/soil_CEC_30cm_1km", format = "GTiff", overwrite = TRUE)
rfinal <- raster("../soil_CEC_30cm_1km.tif")

plot(rfinal, maxpixels = 5000)


## PH
PHStack <- stack(
  list.files("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Data/SoilGrid/", pattern = 'PHIKCL', full.names = TRUE))
overlay(PHStack, fun = function(a, b, c, d){(1/(30*2)*((5-0)*(a+b)+(15-5)*(b+c)+(30-15)*(c+d)))}, filename = "../Data/soil_PHIKCL_30cm_1km", format = "GTiff", overwrite = TRUE)

phfinal <- raster("../Data/soil_PHIKCL_30cm_1km.tif")

plot(phfinal, maxpixels = 5000)

## PH 2
PHStack <- stack(
  list.files("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Data/SoilGrid/", pattern = 'PHIHOX', full.names = TRUE))
overlay(PHStack, fun = function(a, b, c, d){(1/(30*2)*((5-0)*(a+b)+(15-5)*(b+c)+(30-15)*(c+d)))}, filename = "../Data/soil_PHIHOX_30cm_1km", format = "GTiff", overwrite = TRUE)

phfinal <- raster("../Data/soil_PHIHOX_30cm_1km.tif")

plot(phfinal, maxpixels = 5000)

## Sand ppt
PHStack <- stack(
  list.files("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Data/SoilGrid/", pattern = 'SNDPPT', full.names = TRUE))
overlay(PHStack, fun = function(a, b, c, d){(1/(30*2)*((5-0)*(a+b)+(15-5)*(b+c)+(30-15)*(c+d)))}, filename = "../Data/soil_SNDPPT_30cm_1km", format = "GTiff", overwrite = TRUE)

phfinal <- raster("../Data/soil_SNDPPT_30cm_1km.tif")

plot(phfinal, maxpixels = 5000)

## Bulk Density
PHStack <- stack(
  list.files("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Data/SoilGrid/", pattern = 'BLDFIE', full.names = TRUE))
overlay(PHStack, fun = function(a, b, c, d){(1/(30*2)*((5-0)*(a+b)+(15-5)*(b+c)+(30-15)*(c+d)))}, filename = "../Data/soil_BLDFIE_30cm_1km", format = "GTiff", overwrite = TRUE)

phfinal <- raster("../Data/soil_BLDFIE_30cm_1km.tif")

plot(phfinal, maxpixels = 5000)