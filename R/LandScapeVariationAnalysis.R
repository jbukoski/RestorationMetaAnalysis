library(raster)
library(readr)
library(dplyr)
library(ggplot2)

# Analysis Variation
grupos <- list.files("../Data/Raster/Results", pattern = "_Merged.tif$", recursive = TRUE, full.names = TRUE)
grupos <- grupos[-c(1,3,4)]
landscapeVarResults <- stack(grupos)
BiomesLayer <- raster("../Data/Raster/ForestBiomesRaster.tif")
biomes.ref <- read_csv("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/Data/CSV/BiomesReference.csv")

do_biome <- FALSE # must set TRUE to analyse per biome or other region
result <- tibble()
for (a in 1:nlayers(landscapeVarResults)){
  # a = 1
  landscape <- landscapeVarResults[[a]]
  suffix <- dplyr::last(strsplit(grupos[a], split = "/")[[1]])
  suffix <- paste(strsplit(suffix, split = "_")[[1]][1:2], collapse = "_")
  if (do_biome){
    for (biome in 1:5){
      # biome = 1
      # plot(BiomesLayer == biome)
      r.biome <- BiomesLayer == biome
      ResultsBiomes <- landscape * r.biome 
      #ResultsBiomes <- mask(landscape, r.biome, maskvalue = 0) 
      # plot(ResultsBiomes)
      BandFreqTable <- as_tibble(
        freq( ResultsBiomes,
              digits = 4, useNA='no', progress = "text", merge = TRUE)
              ) %>% 
        dplyr::mutate(class = paste(biomes.ref[biome,"BIOME_NAME"]), 
                      zone = paste(biomes.ref[a,"zone"]), 
                      group = suffix)
      
      result <- dplyr::bind_rows(result, BandFreqTable)
      
    }
    # Landscape Variation plot----
    result %>%
      filter(zone %in% c(1:3)) %>% 
      ggplot(aes(x = value, y = count, group = group, color = group, fill = group)) + geom_col(alpha = 0.5) + 
      #geom_density(alpha = 0.5) + 
      #facet_wrap(.~class) + 
      theme_bw()
    ggsave(paste0(suffix,"_LandscapeVar.png"))
  } else {
    BandFreqTable <- as_tibble(
      freq( landscape,
            digits = 4, useNA='no', progress = "text", merge = TRUE)
    ) %>% 
      dplyr::mutate( group = suffix )
    
    result <- dplyr::bind_rows(result, BandFreqTable)
    
    # Landscape Variation plot----
    result %>%
      #filter(zone %in% c(1:3)) %>% 
      ggplot(aes(x = value, y = count, group = group, color = group, fill = group)) + geom_col(alpha = 0.5) + 
      #facet_wrap(.~class) + 
      theme_bw()
    ggsave(paste0(suffix,"_LandscapeVar.png"))
  }
  
  write_csv(result, paste0("result_", suffix, ".csv"))
  }
