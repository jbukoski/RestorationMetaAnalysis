library(rgdal)
#stats <- readOGR("../Data/stats2ndRound.geojson", "stats2ndRound")
stats <- readOGR("/media/felipe/DATA/Proyectos/SE_EC_MetaAnalysis/Scripts/Data/stats2ndRound.geojson", "stats2ndRound")
head(stats@data)
summary(stats@data)
colnames(stats@data)[which(colnames(stats@data)=="sum")] = "PercUrbArea"
for (i in unique(stats@data$description)[1]){
  # i = unique(stats@data$description)[1]
  #ncol(stats@data)
  print(i)
  results <- stats@data[
    which(stats@data$description == i), 
    -which(colnames(stats@data)=="geometry")] 
  #nrow(results)
  colnames(results)[which(colnames(results)=="description")] <- "Buffer_Size"
  #write.csv(results, paste0("2ndRound_results_Buffer", i, ".csv"), row.names = FALSE)
#  print(results[which(results$Site == 16),c("slope_mean", "slope_stdDev", "elevation_stdDev", "elevation_mean")])
}
