library(raster)
library(readr)
library(dplyr)

# Getting all results
indexLayers <- list.files("../Data/Raster/Results", pattern = "Abundance_Norm.tif$|ness_Norm.tif$", recursive = TRUE, full.names = TRUE)

# stackin
stackedIndex <- stack(indexLayers)

# sampling
set.seed(031219)
samp <- sampleRandom(stackedIndex, 50000, xy = TRUE, sp=FALSE, na.rm = TRUE)
head(samp)
dim(samp)
as_tibble(samp)
write_csv(as_tibble(samp), "../Data/CSV/Results/Rastersamples.csv")
