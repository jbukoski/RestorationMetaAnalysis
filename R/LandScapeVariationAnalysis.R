# Analysis Variation
grupos <- list.files("../Data/Raster/Results", pattern = "_Merged.tif$", recursive = TRUE, full.names = TRUE)
landscapeVarResults <- stack(grupos)
BiomesLayer <- raster("../Data/Raster/ForestBiomesRaster.tif")
biomes.ref <- read_csv("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/Data/CSV/BiomesReference.csv")

library(raster)
library(tibble)

result <- tibble()
for (a in 1:nlayers(landscapeVarResults)){
  # a = 1
  landscape <- landscapeVarResults[[a]]
  suffix <- dplyr::last(strsplit(grupos[a], split = "/")[[1]])
  suffix <- paste(strsplit(suffix, split = "_")[[1]][1:2], collapse = "_")
  for (biome in 1:5){
    # biome = 1
    # plot(BiomesLayer == biome)
    r.biome <- BiomesLayer == biome
    ResultsBiomes <- mask(landscape, r.biome, maskvalue = 0) 
    # plot(ResultsBiomes)
    BandFreqTable <- as_tibble(
      freq( ResultsBiomes)#, ...)
            ) %>% 
      dplyr::mutate(class = paste(biomes.ref[biome,"BIOME_NAME"]), 
                    zone = paste(biomes.ref[a,"zone"]), 
                    group = suffix)
    
    result <- dplyr::bind_rows(result, BandFreqTable)
    
  }
  write_csv(result, "result_teste.csv")
    }
