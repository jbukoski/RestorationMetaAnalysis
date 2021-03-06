library(rgdal)
stats <- readOGR("../Data/stats1stRound.geojson", "stats1stRound")
head(stats@data)

for (i in unique(stats@data$description)){
  # i = unique(stats@data$description)[2]
  #ncol(stats@data)
  print(i)
  results <- stats@data[
    which(stats@data$description == i), 
    -which(colnames(stats@data)=="geometry")] 
  #nrow(results)
  colnames(results)[which(colnames(results)=="description")] <- "Buffer_Size"
  write.csv(results, paste0("results_Buffer", i, ".csv"), row.names = FALSE)
}
