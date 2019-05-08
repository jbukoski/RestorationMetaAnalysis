library(sf)
library(raster)
library(tidyverse)

## Loading datasets ----
# country data
country <- read_sf("../Data/Countries_original.shp") %>% st_drop_geometry() %>%  dplyr::select("ID_Country", "CNTRY_NAME")
r.countries <- raster("../Data/CountriesRaster.tif")
# biome data
biome <- read_sf("../Data/Ecoregions2017/Ecoregions2017.shp") %>% st_drop_geometry() %>%  dplyr::select("Biome_ID", "BIOME_NAME")
r.biomes <- raster("../Data/ForestBiomesRaster.tif")
r.restAmount <- raster("./3rdRoundResult/RestAmount.tif")
compareRaster(r.restAmount, r.vert, res = T, orig = T)

# Loading invertebrates results
r.invert <- raster("./3rdRoundResult/Invertebrades/InvertebradesMerged.tif")
# overlay(r.invert, r.restAmount, filename= "./3rdRoundResult/InvertedWeighted.tif", fun = function(x,y){return(x*y)})
r.invert2 <- raster("./3rdRoundResult/InvertedWeighted.tif")
plot(r.invert2, maxpixels=10000)

r.vert <- raster("./3rdRoundResult/Vertebrades/VertebradesMerged.tif")
# overlay(r.vert, r.restAmount, filename= "./3rdRoundResult/VertedWeighted.tif", fun = function(x,y){return(x*y)})
r.vert2 <- raster("./3rdRoundResult/VertedWeighted.tif")
# plot(r.vert2, maxpixels=10000)

# Normalizing Forest Variance ----
#vertRaster <- raster("./3rdRoundResult/Vertebrades/VertebradesMerged.tif")
#vertRasterNorm <- vertRaster/vertRaster@data@max
#writeRaster(vertRasterNorm, "./3rdRoundResult/Vertebrades/VertebradesMerged.tif", overwrite = TRUE)

#invertRaster <- raster("./3rdRoundResult/Invertebrades/InvertebradesMerged.tif")
#invertRasterNorm <- invertRaster/invertRaster@data@max
#invertRasterNorm
#writeRaster(invertRasterNorm, "./3rdRoundResult/Invertebrades/InvertebradesMerged.tif", overwrite = TRUE)


# Zonal stats ----
# InVert
## Country
Mean.Country.stats.invert <- zonal(r.invert, r.countries, fun = "mean", na.rm = TRUE, progress="text")
Mean.Country.stats.invert <- as_tibble(Mean.Country.stats.invert) %>% plyr::rename(c("mean" = "MeanCountryInvert"))
SD.Country.stats.invert <- zonal(r.invert, r.countries, fun = "sd", na.rm = TRUE, progress="text")
SD.Country.stats.invert <- as_tibble(SD.Country.stats.invert) %>% plyr::rename(c("sd" = "SDCountryInvert"))
# Merging SD and Mean stats and organizing columns
Invert.CountryStats <- SD.Country.stats.invert %>% left_join(Mean.Country.stats.invert, by = "zone") %>% left_join(country, by = c("zone" = "ID_Country")) %>% select(CNTRY_NAME, zone, MeanCountryInvert, SDCountryInvert)

## Country*Restoration Amount
Mean.Country.stats.invert <- zonal(r.invert2, r.countries, fun = "mean", na.rm = TRUE, progress="text")
Mean.Country.stats.invert <- as_tibble(Mean.Country.stats.invert) %>% plyr::rename(c("mean" = "weightedMeanCountryInvert"))
SD.Country.stats.invert <- zonal(r.invert, r.countries, fun = "sd", na.rm = TRUE, progress="text")
SD.Country.stats.invert <- as_tibble(SD.Country.stats.invert) %>% plyr::rename(c("sd" = "weightedSDCountryInvert"))
# Merging SD and Mean stats and organizing columns
Invert.CountryStats <- SD.Country.stats.invert %>% left_join(Mean.Country.stats.invert, by = "zone") %>% left_join(country, by = c("zone" = "ID_Country")) %>% select(CNTRY_NAME, zone, weightedMeanCountryInvert, weightedSDCountryInvert)

# Invert.CountryStats %>% dplyr::filter(zone == 269)
write.csv(Invert.CountryStats, "weightedCountryStats.Invertebrates.csv")

## Biome
Mean.Biome.stats.invert <- zonal(r.invert, r.biomes, fun = "mean", na.rm = TRUE, progress="text")
Mean.Biome.stats.invert <- as_tibble(Mean.Biome.stats.invert) %>% plyr::rename(c("mean" = "MeanBiomeInvert"))
SD.Biome.stats.invert <- zonal(r.invert, r.biomes, fun = "sd", na.rm = TRUE, progress="text")
SD.Biome.stats.invert <- as_tibble(SD.Biome.stats.invert) %>% plyr::rename(c("sd" = "SDBiomeInvert"))
# Merging SD and Mean stats and organizing columns
Invert.BiomeStats <- SD.Biome.stats.invert %>% left_join(Mean.Biome.stats.invert, by = "zone") %>% left_join(biome, by = c("zone" = "Biome_ID")) %>% select(BIOME_NAME, zone, MeanBiomeInvert, SDBiomeInvert) %>% distinct()

## Biome*RestorationAmount
Mean.Biome.stats.invert <- zonal(r.invert2, r.biomes, fun = "mean", na.rm = TRUE, progress="text")
Mean.Biome.stats.invert <- as_tibble(Mean.Biome.stats.invert) %>% plyr::rename(c("mean" = "weightedMeanBiomeInvert"))
SD.Biome.stats.invert <- zonal(r.invert, r.biomes, fun = "sd", na.rm = TRUE, progress="text")
SD.Biome.stats.invert <- as_tibble(SD.Biome.stats.invert) %>% plyr::rename(c("sd" = "weightedSDBiomeInvert"))
# Merging SD and Mean stats and organizing columns
Invert.BiomeStats <- SD.Biome.stats.invert %>% left_join(Mean.Biome.stats.invert, by = "zone") %>% left_join(biome, by = c("zone" = "Biome_ID")) %>% select(BIOME_NAME, zone, weightedMeanBiomeInvert, weightedSDBiomeInvert) %>% distinct()

# Invert.CountryStats %>% dplyr::filter(zone == 269)
write.csv(Invert.BiomeStats, "weightedBiomeStats.Invertebrates.csv")


# Vert
## Country
Mean.Country.stats.vert <- zonal(r.vert, r.countries, fun = "mean", na.rm = TRUE, progress="text")
Mean.Country.stats.vert <- as_tibble(Mean.Country.stats.vert) %>% plyr::rename(c("mean" = "MeanCountryVert"))
SD.Country.stats.vert <- zonal(r.vert, r.countries, fun = "sd", na.rm = TRUE, progress="text")
SD.Country.stats.vert<- as_tibble(SD.Country.stats.vert) %>% plyr::rename(c("sd" = "SDCountryVert"))
# Merging SD and Mean stats and organizing columns
vert.CountryStats <- SD.Country.stats.vert %>% left_join(Mean.Country.stats.vert, by = "zone") %>% left_join(country, by = c("zone" = "ID_Country")) %>% select(CNTRY_NAME, zone, MeanCountryVert, SDCountryVert) %>% drop_na()

## Country*restoration Amount
Mean.Country.stats.vert <- zonal(r.vert2, r.countries, fun = "mean", na.rm = TRUE, progress="text")
Mean.Country.stats.vert <- as_tibble(Mean.Country.stats.vert) %>% plyr::rename(c("mean" = "weightedMeanCountryVert"))
SD.Country.stats.vert <- zonal(r.vert2, r.countries, fun = "sd", na.rm = TRUE, progress="text")
SD.Country.stats.vert<- as_tibble(SD.Country.stats.vert) %>% plyr::rename(c("sd" = "weightedSDCountryVert"))
# Merging SD and Mean stats and organizing columns
vert.CountryStats <- SD.Country.stats.vert %>% left_join(Mean.Country.stats.vert, by = "zone") %>% left_join(country, by = c("zone" = "ID_Country")) %>% select(CNTRY_NAME, zone, weightedMeanCountryVert, weightedSDCountryVert) %>% drop_na()

# vert.CountryStats %>% dplyr::filter(zone == 269)
write.csv(vert.CountryStats, "weightedCountryStats.vertebrates.csv")

## Biome
Mean.Biome.stats.vert <- zonal(r.vert, r.biomes, fun = "mean", na.rm = TRUE, progress="text")
Mean.Biome.stats.vert <- as_tibble(Mean.Biome.stats.vert) %>% plyr::rename(c("mean" = "MeanBiomeVert"))
SD.Biome.stats.vert <- zonal(r.vert, r.biomes, fun = "sd", na.rm = TRUE, progress="text")
SD.Biome.stats.vert <- as_tibble(SD.Biome.stats.vert) %>% plyr::rename(c("sd" = "SDBiomeVert"))
# Merging SD and Mean stats and organizing columns
vert.BiomeStats <- SD.Biome.stats.vert %>% left_join(Mean.Biome.stats.vert, by = "zone") %>% left_join(biome, by = c("zone" = "Biome_ID")) %>% select(BIOME_NAME, zone, MeanBiomeVert, SDBiomeVert) %>% distinct()

# vert.CountryStats %>% dplyr::filter(zone == 269)
write.csv(vert.BiomeStats, "BiomeStats.vertebrates.csv")

## Biome* RestorationAmount
Mean.Biome.stats.vert <- zonal(r.vert2, r.biomes, fun = "mean", na.rm = TRUE, progress="text")
Mean.Biome.stats.vert <- as_tibble(Mean.Biome.stats.vert) %>% plyr::rename(c("mean" = "weightedMeanBiomeVert"))
SD.Biome.stats.vert <- zonal(r.vert, r.biomes, fun = "sd", na.rm = TRUE, progress="text")
SD.Biome.stats.vert <- as_tibble(SD.Biome.stats.vert) %>% plyr::rename(c("sd" = "weightedSDBiomeVert"))
# Merging SD and Mean stats and organizing columns
vert.BiomeStats <- SD.Biome.stats.vert %>% left_join(Mean.Biome.stats.vert, by = "zone") %>% left_join(biome, by = c("zone" = "Biome_ID")) %>% select(BIOME_NAME, zone, weightedMeanBiomeVert, weightedSDBiomeVert) %>% distinct()

# vert.CountryStats %>% dplyr::filter(zone == 269)
write.csv(vert.BiomeStats, "weightedBiomeStats.vertebrates.csv")

rm(list=ls())
gc()


# Histogram Not Used ----
#library(rasterVis)
#png("InvertHist.png")
#densityplot(r.invert, main = "Invertabrate's landscape variation")
#dev.off()

#png("VertHist.png")
#densityplot(r.vert, main = "Vertabrate's landscape variation")
#dev.off()

# install.packages('tmap')
#library(tmap)
#country <- read_sf("../Data/Countries_original.shp")
#country <- country %>% right_join(statsAll, by = c("ID_Country" = "zone"))
#tm_shape(country) +
#  tm_fill(col = "SDVert") +
#  tm_borders() 


# Histo por bioma ----
biomaLayers <- brick("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/Data/biomes.tif")

# overlay(biomaLayers, r.invert2, filename= "./3rdRoundResult/InvertWeightedBiomes.tif", fun = function(x,y){return(x*y)})
InvertBiomes <- stack("./3rdRoundResult/InvertWeightedBiomes.tif")

# overlay(biomaLayers, r.vert2, filename= "./3rdRoundResult/VertWeightedBiomes.tif", fun = function(x,y){return(x*y)})
VertBiomes <- stack("./3rdRoundResult/VertWeightedBiomes.tif")

biomes.ref <- read_csv("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/R/BiomeStats.vertebrates.csv")[c("BIOME_NAME","zone")]

# data extract fct
extct.fct <- function(r.biomes = InvertBiomes, biomes.ref, suffix = "Invert", ...){
  library(raster)
  library(tibble)
  result <- tibble()
  for (a in 1:length(r.biomes@layers)){
    # a = 1
    BandFreqTable <- as_tibble(
      freq( r.biomes[[a]], ...)) %>% 
      mutate(class = paste(biomes.ref[a,"BIOME_NAME"]), zone = paste(biomes.ref[a,"zone"]), group = suffix)
    
    result <- dplyr::bind_rows(result, BandFreqTable)
  }
  return(result)
}

# Using fct ----
# Invertebrates
# Invert <- extct.fct(InvertBiomes, biomes.ref, suffix = "Invertebrades", digits = 4, useNA='no', progress = "text", merge = TRUE)
# write_csv(Invert, "WeightedLandscapeVarBiomes_Invertabrates.csv")

Invert <- read_csv("./WeightedLandscapeVarBiomes_Invertabrates.csv")
unique(Invert$zone)
max(Invert$value, na.rm = T)
max(Invert$count, na.rm = T)

# Vertebrates
# Vert <- extct.fct(VertBiomes, biomes.ref, suffix = "Vertebrades", digits = 4, useNA='no', progress = "text", merge = TRUE)
# write_csv(Vert, "WeightedLandscapeVarBiomes_Vertabrates.csv")

Vert <- read_csv("WeightedLandscapeVarBiomes_Vertabrates.csv")
unique(Vert$zone)
max(Vert$value, na.rm = T)
max(Vert$count, na.rm = T)

all <- bind_rows(Vert, Invert)

# plot -----
library(ggplot2)
all %>% filter(zone %in% c(1:3)) %>% ggplot(aes(x = value, group = group, color = group, fill = group)) + geom_density(alpha = 0.5) + facet_wrap(.~class) + theme_bw()

#install.packages("ggridges")
library(ggridges)
ggplot(Invert, aes(x = value, y = class, #fill = ..x..
                   )) +
  geom_density_ridges_gradient(scale = 1.5, rel_min_height = 0.01, na.rm = TRUE) +
  scale_y_discrete(expand = c(0.01, 1.2)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  labs(
    title = 'Invertebrates',
    subtitle = 'teste'
  ) +
  theme_ridges(font_size = 13, grid = TRUE) + theme(axis.title.y = element_blank())
