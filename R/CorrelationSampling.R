library(raster)
library(readr)
library(dplyr)
# library(ggplot2)

# Getting all results
AbundanceGrupos <- list.files("../Data/Raster/Results", pattern = "Abundance_Norm.tif$", recursive = TRUE, full.names = TRUE)
RichnessGrupos <- list.files("../Data/Raster/Results", pattern = "ness_Norm.tif$", recursive = TRUE, full.names = TRUE)
# stacking
AbundanceLandscapeVarResults <- stack(AbundanceGrupos)
RichnessLandscapeVarResults <- stack(RichnessGrupos)
# stacking II
stackedIndex <- stack(RichnessLandscapeVarResults, AbundanceLandscapeVarResults)

# sampling
set.seed(031219)
samp <- sampleRandom(stackedIndex, 25000, xy = TRUE, sp=FALSE, na.rm = TRUE)
head(samp)
dim(samp)
as_tibble(samp)
write_csv(as_tibble(samp), "../Data/CSV/Results/Rastersamples.csv")
