library(rgdal)
library(raster)

# Open buffer example
buffer <- readOGR("../Data/Buffer_validation.geojson", "Buffer_validation")
plot(buffer)

GEEstats <- read.csv("../Data/CECstats.csv")[,c(2,3)]
GEEstats$StudySite <- "Site 269"
# Open Soil CEC to have statistics taken
cec <- raster("../soil_CEC_30cm_1km.tif")
cec <- crop(cec, buffer)
cec <- mask(cec, buffer)

mapview(cec, maxpixels = 5000, burst = TRUE)
plot(buffer, add=T)


# Taking statistics
statsR <- matrix(data = NA, 1,3)
statsR[1,1] <- 'Site 269'
statsR[1,2] <- extract(cec, buffer, fun = mean, na.rm = TRUE)
statsR[1,3] <- extract(cec, buffer, fun = sd, na.rm = TRUE)
statsR <- as.data.frame(statsR)
names(statsR) <- c("StudySite", "CEC_Mean", "CEC_sd")
write.csv(statsR, "CEC_Rstats.csv", row.names = FALSE)
