################################################################
## Calculation of Pearson's Correlation for biodiversity data ##
################################################################

# This scripts calculates Pearson's correlation for the different biodiversity
# prediction layers as well as various tests and visualizations of the data.
# The correlations are calculated using 1,000 pts randomly sampled from all 
# unique pairings of 6 variables:

# 1. flora abundance
# 2. flora richness
# 3. invertebrate abundance
# 4. invertebtrate richness
# 5. vertebrate abundance
# 6. vertebrate richness

# The script contains the following sections:
  
# 1. Calculation of Pearson's Correlation.
# 2. Visualization of distributions of the 6 response variables.
# 3. Examination of spatial autocorrelation and biases in the correlation scores.

#--------------------------------------------------------

#############################################
## 1. Calculation of Pearson's Correlation ##
#############################################

# Load libraries, set directories, and write a function to compute correlations for all csvs

library(tidyverse)

dir <- "~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/csv/"

files <- list.files(dir)

summary = data.frame(
  'pair' = character(),
  'corr' = double(),
  't-stat' = double(),
  'p-val' = double()
)

for(file in files) {

  set.seed(9999)
  
  dat <- read_csv(paste0(dir, file)) %>%
    select(-"system:index", -".geo") %>%
    as.data.frame() %>%
    sample_n(1000)   # Randomly sample 1000 pts
  
  testResults <- cor.test(dat[, 1], dat[, 2], method = c("pearson"))
  
  dat <- data.frame(
    pair = gsub('.csv', '', file),
    corr = testResults$estimate,
    't-stat' = testResults$statistic,
    'p-val' = testResults$p.value
    )
  
  summary <- summary %>%
    bind_rows(dat)

}

# Format as a correlation matrix.

sum_dat <- summary %>% 
  separate(pair, sep = "_vs_", into = c("v1", "v2")) %>%
  select("v1", "v2", corr)

var1 <- sum_dat$v1
var2 <- sum_dat$v2
r <- sum_dat$corr

var <- unique(c(var1,var2))
corr <- matrix(1, nrow=6, ncol=6, byrow = T) # a matrix with 1s
corr[lower.tri(corr,diag = FALSE)] <- r # lower triangular matrix to be r
corr <- Matrix::forceSymmetric(corr, uplo="L")
corr <- as.matrix(corr)
corr <- as.data.frame(corr) # formatting
row.names(corr) <- var # row names
colnames(corr) <- var # column names

corr

# Write out summary results to file.
# summaryResults.csv = simple table of summary statistics
# corrMatrix.csv = correlations between variables formatted as a correlation matrix.

write_csv(summary, "~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/processed/summaryResults.csv")
write_csv(corr, "~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/processed/corrMatrix.csv")


#-------------------------------------------------
# Build a histogram plot using shapefiles of 5,000 pts

library(sf)

indir <- "~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/shp/"

fa <- read_sf(paste0(indir, "fa_pts_distribution.shp")) %>% rename(fa = first) %>% st_set_geometry(NULL) 
fr <- read_sf(paste0(indir, "fr_pts_distribution.shp")) %>% rename(fr = first) %>% st_set_geometry(NULL) 
ia <- read_sf(paste0(indir, "ia_pts_distribution.shp")) %>% rename(ia = first) %>% st_set_geometry(NULL) 
ir <- read_sf(paste0(indir, "ir_pts_distribution.shp")) %>% rename(ir = first) %>% st_set_geometry(NULL) 
va <- read_sf(paste0(indir, "va_pts_distribution.shp")) %>% rename(va = first) %>% st_set_geometry(NULL) 
vr <- read_sf(paste0(indir, "vr_pts_distribution.shp")) %>% rename(vr = first) %>% st_set_geometry(NULL) 

dist_dat <- bind_cols(fa, fr, ia, ir, va, vr) %>%
  gather(key = "var", value = "estimate") %>%
  mutate(var = factor(var))

levels(dist_dat$var) <- c(
  "Flora Abundance",
  "Flora Richeness",
  "Invertebrate Abundance",
  "Invertebrate Richness",
  "Vertebrate Abundance",
  "Vertebrate Richness"
)


fixed <- ggplot(dist_dat) +
  facet_wrap(. ~ var, scales = "fixed", nrow = 3) +
  geom_histogram(aes(estimate), bins = 50) +
  ylab("Frequency") +
  xlab("ln(Response Ratio)") +
  theme_bw()

free <- ggplot(dist_dat) +
  facet_wrap(. ~ var, scales = "free", nrow = 3) +
  geom_histogram(aes(estimate), bins = 50) +
  ylab("Frequency") +
  xlab("ln(Response Ratio)") +
  theme_bw()

ggsave("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/figs/fixed_scales.jpg", fixed, device = "jpeg", width = 6, height = 8, units = "in")
ggsave("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/figs/free_scales.jpg", free, device = "jpeg", width = 6, height = 8, units = "in")

#------------------------------------------------------------------

##################################
## Autocorrelation tests & code ##
##################################

# Examine how the significance changes with the number of points

dat <- read_csv("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/csv/fa_vs_fr.csv")

ns <- seq(20, 1000, 20)

summary <- data.frame(
  "n" = double(),
  "estimate" = double(),
  "t-value" = double(),
  "p-value" = double()
)

for(n in ns) {
  
  dat_new <- dat %>%
    select(-"system:index", -".geo") %>%
    sample_n(n) %>%
    as.data.frame()
  
  testResults <- cor.test(dat_new[, 1], dat_new[, 2], method = c("pearson"))
  
  outData <- data.frame(
    "n" = n,
    "estimate" = testResults$estimate,
    't-value' = testResults$statistic,
    'p-value' = testResults$p.value
  )
  
  summary <- summary %>%
    bind_rows(outData)
  
}

ggplot(data = summary) +
  geom_point(aes(x = n, y = p.value)) +
  geom_smooth(aes(x = n, y = p.value)) +
  theme_bw()

#-------------------------------------
# Spatial autocorrelation

library(ape)
library(gstat)
library(sf)
library(spdep)
library(tidyverse)

shp <- read_sf("~/Desktop/corr_data/shapefiles/fa_pts_distribution.shp") %>%
  rename(fa = first) %>%
  mutate(long = st_coordinates(.)[, 1],
         lat = st_coordinates(.)[, 2]) %>%
  select(fa, long, lat) %>%
  sample_n(100)

azimuth_eqdst <- " +proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs"
az_eq <- CRS("+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

shp <- st_transform(shp, az_eq)


shp_knn <- knearneigh(shp, k = 1)  # Only 1 nearest neighbor, can alter later
shp_nb <- knn2nb(shp_knn)
w <- nb2listw(shp_nb)

moran(shp$fa, w, n=length(w$neighbours), S0=Szero(w))
moran.test(shp$fa, w, randomisation=FALSE)

moran.mc(shp$fa, w, nsim=99)

# Compute semivariance and visualize

gs <- gstat(formula = fa~1, data = shp)
v <- variogram(gs, width = 20)

head(v)
plot(v)
