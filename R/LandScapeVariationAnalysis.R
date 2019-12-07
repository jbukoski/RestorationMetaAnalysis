library(raster)
library(readr)
library(dplyr)
# library(ggplot2)

# Analysis Variation
AbundanceGrupos <- list.files("../Data/Raster/Results", pattern = "Abundance_Norm.tif$", recursive = TRUE, full.names = TRUE)
RichnessGrupos <- list.files("../Data/Raster/Results", pattern = "ness_Norm.tif$", recursive = TRUE, full.names = TRUE)
#grupos <- grupos[-grep("OOTR|Restorable", grupos)]
AbundanceLandscapeVarResults <- stack(AbundanceGrupos)
RichnessLandscapeVarResults <- stack(RichnessGrupos)

png("./plots/AbundanceLandscapeVariation.png")
rasterVis::densityplot(AbundanceLandscapeVarResults)
dev.off()
#png("./plots/AbundanceLandscapeVariationHist.png")
#rasterVis::histogram(AbundanceLandscapeVarResults)
#dev.off()

png("./plots/RichnessLandscapeVariation.png")
rasterVis::densityplot(RichnessLandscapeVarResults)
dev.off()
#png("./plots/RichnessLandscapeVariationHist.png")
#rasterVis::histogram(RichnessLandscapeVarResults)
#dev.off()


# Not done -----
BiomesLayer <- raster("../Data/Raster/ForestBiomesRaster.tif")
biomes.ref <- read_csv("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/Data/CSV/BiomesReference.csv")

do_biome <- FALSE # must set TRUE to analyse per biome or other region
result <- tibble()
for (a in 1:nlayers(AbundanceLandscapeVarResults)){
  # a = 1
  
  # Organizing raster layer
  landscape <- AbundanceLandscapeVarResults[[a]]
  
  # creating name "group_metric"
  suffix <- dplyr::last(strsplit(landscape@file@name, split = "/")[[1]])
  suffixGroup <- strsplit(suffix, split = "_")[[1]][1]
  suffix <- strsplit(suffix, split = "_")[[1]][2]
  
  
  # in case the analysis should be done by biome:
  if (do_biome){
    cat("starting biome analysis\n")
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
    cat("Estimating frequency table for", suffix, "\n")
    BandFreqTable <- as_tibble(
      freq( 
        landscape,
            digits = 4, useNA='no', progress = "text", merge = TRUE)
    ) %>% 
      dplyr::mutate( group = suffixGroup )
    BandFreqTable <- as_tibble(
      na.omit(
        as.data.frame(
          landscape,
          digits = 4, useNA='no', progress = "text", merge = TRUE)
      )
      ) %>% 
      dplyr::mutate( group = suffixGroup )
    write_csv(BandFreqTable, paste0("../Data/CSV/Results/result_", suffix, "_", suffixGroup, ".csv"))
    
    result <- dplyr::bind_rows(result, BandFreqTable)
    }
  
  write_csv(result, paste0("../Data/CSV/Results/result_", suffix, ".csv"))
  }
