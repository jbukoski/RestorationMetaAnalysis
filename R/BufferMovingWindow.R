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
# Hawthorne consideration
r.focalH <- focal(r, kernel, "sum", na.rm=TRUE) / sum(kernel)

# Raster hipotetico apos reamostragem (aggregate)
#?resample
# resample foi desconsiderado já que depende de uma layer de referencia
#r.resample <- raster::resample(r, fact=10, fun=mean)
?raster::aggregate
r.aggregate <- raster::aggregate(r, fact=10, fun=mean)

#criando um ponto hipotetico:
point1 = st_sf(a=3,st_sfc(st_point(c(0,0))))
# criando um buffer hipotetico no ponto hipotetico :)
b.point1 <- st_buffer(point1, dist = 10)
ext <- extent(st_buffer(point1, dist = 15))

#Identificando valor medio em buffer de 10 pxl
plot(r, ext=extent(ext), main = paste("Valor = ", extract(r, b.point1, fun=mean, na.rm=TRUE)))
plot(st_geometry(b.point1), add=T)

#Identificando valor medio no ponto apos movingwindow de 10 pxl
plot(r.focal, ext=extent(ext), main = paste("Valor = ", extract(r.focal, point1)))
plot(point1, add=T, pch = 19)

# focal Hawtothorne
plot(r.focalH, ext=extent(ext), main = paste("Valor = ", extract(r.focalH, point1)))
plot(point1, add=T, pch = 19)


#Identificando valor medio no ponto apos resample de 10 pxl
plot(r.aggregate, ext=extent(ext), main = paste("Valor = ", extract(r.aggregate, point1)))
plot(point1, add=T, pch = 19)

# tres plots
par(mfrow=c(1,3))
# Original
plot(r, ext=extent(ext), main = paste("Valor = ", extract(r, b.point1, fun=mean, na.rm=TRUE)))
plot(point1, add=T, pch = 19)
plot(st_geometry(b.point1), add=T)
#focal
plot(r.focal, ext=extent(ext), main = paste("Valor = ", extract(r.focal, point1)))
plot(point1, add=T, pch = 19)
plot(st_geometry(b.point1), add=T)
# resample
plot(r.aggregate, ext=extent(ext), main = paste("Valor = ", extract(r.aggregate, point1)))
plot(point1, add=T, pch = 19)
plot(st_geometry(b.point1), add=T)



# Teste:


sim <- function(x, fun, n=100, pause=0.25) {
  for (i in 1:n) {
    x <- fun(x)
    plot(x, legend=FALSE, asp=NA, main=i)
    dev.flush()
    Sys.sleep(pause)
  }
  invisible(x)
}
sim(r, fun=mean)

plot(r)
rasterFromCells(x = r, cells = 1, values = TRUE)
plot(rasterFromCells(x = r, cells = 1, values = T))
rasterFromCells(r, cells = 1, values = F)
plot(rasterFromCells(r, cells = ncell(r)/2, values = T), ext=extent(ext))

xyFromCell(r, cell = ncell(r)/2, spatial = TRUE)
plot(rasterFromCells(r, cells = ncell(r)/2))
plot(xyFromCell(r, cell = ncell(r)/2, spatial = TRUE), add=T)

plot(rasterFromXYZ(r, xyz = xyFromCell(r, cell = 1)))
xyFromCell(r, cell = c(1,20,30))
cbind(1:ncell(r), getValues(r))

d <- r
ChangeFocal <- function(x, fun, n=100, pause=0.25) {
  for (i in 1:n) {
    
    d <- focal(r, kernel, "mean", na.rm=TRUE)
    plot(d, legend=FALSE, asp=NA, main=i)
    dev.flush()
    Sys.sleep(pause)
  }
  invisible(x)
}