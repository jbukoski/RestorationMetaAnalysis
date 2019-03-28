library(raster)
library(sf)

#Kernel circular
circular.focal.matrix <- function(cellsize, radius){
  n <- (radius / cellsize) * 2 + 1
  m <- matrix(1, nrow=n, ncol=n)
  a <- (radius / cellsize)
  b <- a + 1

  for (i in 1:a){
      for (j in 1:a){
          if (sqrt(i^2 + j^2) > a){
              m[b+i, b+j] <- 0
              m[b+i, b-j] <- 0
              m[b-i, b+j] <- 0
              m[b-i, b-j] <- 0
            }
        }
    }
  return(m)
}

kernel <- circular.focal.matrix(1, 10)

#Raster hipotetico
r <- raster(nrows=180, ncols=360, xmn=-180, xmx=180, ymn=-90, ymx=90)
set.seed(1)
r[] <- runif(ncell(r),0,1)
plot(r)
# Raster hipotetico apos moving window
r.focal <- focal(r, kernel, "mean", na.rm=TRUE)

#criando um ponto hipotetico:
point1 = st_sf(a=3,st_sfc(st_point(c(0,0))))
# criando um buffer hipotetico no ponto hipotetico :)
b.point1 <- st_buffer(point1, dist = 10)
ext <- extent(st_buffer(point1, dist = 15))

#Identificando valor medio em buffer de 10 pxl
plot(r, ext=extent(ext), main = paste("Valor = ", extract(r, b.point1, fun=mean, na.rm=TRUE)))
plot(st_geometry(b.point1), add=T)

#Identificando valor medio no ponto apos movingwindow de 10 pxl
plot(r.focal, ext=extent(ext), main = paste("Valor = ", extract(r.focal, p)))
plot(point1, add=T, pch = 19)
