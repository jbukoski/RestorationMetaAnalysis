# Script came from Eric on 06/06/2018
# Cation exchange capacity of soil in cmolc/kg on four different soil depth (0,5,15,30 cm)
# install.packages("raster")
library(raster)

# setwd("/home/renatinhoboiolon/Downloads/CEC_250m")
s1 <- raster("CECSOL_M_sl1_250m_clip.tif")
s2 <- raster("CECSOL_M_sl2_250m_clip.tif")
s3 <- raster("CECSOL_M_sl3_250m_clip.tif")
s4 <- raster("CECSOL_M_sl4_250m_clip.tif")

# Calculando a capacidade de troca i?nica de um solo at? 30cm de profundidade (f?rmula tirada de Hengl et al. 2017)
rfinal <- (1/(30*2)*((5-0)*(s1+s2)+(15-5)*(s2+s3)+(30-15)*(s3+s4)))
writeRaster(rfinal, "soil_30cm_250m", format="GTiff", overwrite=TRUE) 
