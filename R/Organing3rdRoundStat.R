library(sf)
library(tidyverse)

## Loading datasets ----
# loading Pablo data
load("dados.RF.CIFOR.RDat(a") # Dataset sent by Pablo

head(dados.plantas)
head(dados.invertebrados)
head(dados.vertebrados)

# idenityfying Sites id
sites <- unique(dados.plantas$Site)
sites <- c(sites, dados.invertebrados$Site)
sites <- c(sites, dados.vertebrados$Site)
allsites <- unique(sites)
length(sites)

# loading original dataset
# Preparing KML to send to GEE ----
bd <- read_csv("./Database_18_06_01.csv")
bd$Longitude <- as.numeric(bd$Longitude)
sf.plantas <- bd %>% filter(
  Site %in% unique(dados.plantas$Site), !is.na(Latitude) | !is.na(Longitude)) %>% st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)
st_write(sf.plantas, "flora.kml", driver = "KML")

sf.vertebrados <- bd %>% filter(
  Site %in% unique(dados.vertebrados$Site), !is.na(Latitude) | !is.na(Longitude)) %>% st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)
st_write(sf.vertebrados, "vertebrates.kml", driver = "KML")

sf.invertebrados <- bd %>% filter(
  Site %in% unique(dados.invertebrados$Site), !is.na(Latitude) | !is.na(Longitude)) %>% st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)
st_write(sf.invertebrados, "invertebrates.kml", driver = "KML")

sf.all <- bd %>% filter(
  Site %in% unique(sites), !is.na(Latitude) | !is.na(Longitude)) %>% st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)
st_write(sf.all, "AllGroupSite.kml", driver = "KML")

paste(sf.all[1:10,]$Site, collapse = ", ")
paste(sf.all[11:20,]$Site, collapse = ", ")
paste(sf.all[21:30,]$Site, collapse = ", ")
paste(sf.all[31:40,]$Site, collapse = ", ")
paste(sf.all[41:50,]$Site, collapse = ", ")
paste(sf.all[51:60,]$Site, collapse = ", ")
paste(sf.all[61:70,]$Site, collapse = ", ")
paste(sf.all[71:80,]$Site, collapse = ", ")
paste(sf.all[81:90,]$Site, collapse = ", ")

# Loading results ----
listfiles <- list.files("./3rdRoundResult", full.names = TRUE)
library(data.table)
AllData <- rbindlist(lapply(listfiles, read_csv))
colnames(AllData)[1] <- "Site"
summary(AllData)
write_csv(AllData, "3rdRoundTrain.csv")
