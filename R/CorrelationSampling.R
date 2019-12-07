library(raster)
library(readr)
library(dplyr)

# Ou seja, entre riqueza e abundância do msm grupo, entre riqueza de grupos diferentes, entre abundância de grupos diferentes e tb entre riqueza e abundância de grupos diferentes. Os pontos são para resgatar os valores preditos dos modelos.

# Getting all results
indexLayers <- list.files("../Data/Raster/Results", pattern = "Abundance_Norm.tif$|ness_Norm.tif$", recursive = TRUE, full.names = TRUE)

# stacking
stackedIndex <- stack(indexLayers)

# sampling over all layers
set.seed(031219)
samp <- sampleRandom(stackedIndex, 50000, xy = TRUE, sp=FALSE, na.rm = TRUE)
head(samp)
dim(samp)
samp <- as_tibble(samp)
write_csv(samp, "../Data/CSV/Results/Rastersamples.csv")

library(tmap)
library(sf)
samples_sf <- st_as_sf(samp, coords = c("x", "y"), crs = 4326)

tm_shape(stackedIndex[[1]]) +
  tm_raster( legend.show = FALSE) +
  tm_shape(samples_sf) + 
  tm_dots()


# riqueza e abundância do msm grupo ---
stackedIndex <- stack(indexLayers)

# sampling over all layers
# Flora ----
set.seed(031219)

sampFlora <- sampleRandom(stackedIndex[[c(1:2)]], 50000, xy = TRUE, sp=FALSE, na.rm = TRUE)
head(sampFlora)
dim(sampFlora)
sampFlora <- as_tibble(sampFlora)
write_csv(sampFlora, "../Data/CSV/Results/FloraRastersamples.csv")

#install.packages("corrplot")
library(corrplot)
cor <- cor(sampFlora[,3:ncol(sampFlora)], method="pearson")
corrplot(cor, method="circle", type="upper", diag=F, order = "hclust")
