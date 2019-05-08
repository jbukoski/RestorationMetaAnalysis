library(sf)
library(raster)
library(tidyverse)

## Loading datasets ----
# loading Country raster
r.countries <- raster("../Data/CountriesRaster.tif")
plot(r.countries)

# Loading invertebrates results
r.invert <- raster("./3rdRoundResult/Invertebrades/InvertebradesMerged.tif")

r.vert <- raster("./3rdRoundResult/Vertebrades/VertebradesMerged.tif")


# Zonal stats ----
Mean.stats.invert <- zonal(r.invert, r.countries, fin = "mean", na.rm = TRUE, progress="text")
write.csv(Mean.stats.invert, "Mean.stats.invert.csv")
SD.stats.invert <- zonal(r.invert, r.countries, fin = "sd", na.rm = TRUE, progress="text")
write.csv(SD.stats.invert, "SD.stats.invert.csv")


Mean.stats.vert <- zonal(r.vert, r.countries, fin = "mean", na.rm = TRUE, progress="text")
write.csv(Mean.stats.vert, "Mean.stats.vert.csv")
SD.stats.vert <- zonal(r.vert, r.countries, fin = "sd", na.rm = TRUE, progress="text")
write.csv(SD.stats.vert, "SD.stats.vert.csv")

rm(list=ls())
gc()

Mean.stats.invert <- read.csv("./Mean.stats.invert.csv")[,2:3]
SD.stats.invert <- read.csv("./SD.stats.invert.csv")[,2:3]
countries <- read_sf("../Data/Countries.shp") %>% select("ID_country")
countries[,"ID_Country"]
invert <- Mean.stats.invert %>% left_join(SD.stats.invert, by = "zone") %>% left_join(countries, by = c("zone" = "ID_Country"))
write.csv(invert, "stats.Invert.csv")
