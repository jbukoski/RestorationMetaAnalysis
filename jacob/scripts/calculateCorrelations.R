## Calculation of Pearson's Correlation for biodiversity data

library(tidyverse)

dir <- "~/Desktop/corr_data/data/"

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


write_csv(summary, "~/Desktop/corr_data/summaryResults.csv")
write_csv(corr, "~/Desktop/corr_data/corrMatrix.csv")


#---------------------------------
# Examine how the significance changes with the number of points

dat <- read_csv("~/Desktop/corr_data/data/ia_vs_ir.csv")

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

#-------------------------------------------------
# Build a histogram plot using shapefiles of 5,000 pts

library(sf)

indir <- "~/Desktop/corr_data/shapefiles/"

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

ggsave("~/Desktop/corr_data/figs/fixed_scales.jpg", fixed, device = "jpeg", width = 6, height = 8, units = "in")
ggsave("~/Desktop/corr_data/figs/free_scales.jpg", free, device = "jpeg", width = 6, height = 8, units = "in")

  
#--------------------------------

library(sf)
library(ape)

shp <- read_sf("~/Desktop/corr_data/shapefiles/fa_pts_distribution.shp") %>%
  rename(fa = first) %>%
  mutate(long = st_coordinates(.)[, 1],
         lat = st_coordinates(.)[, 2]) %>%
  select(fa, long, lat) %>%
  sample_n(40)

shp_df <- st_set_geometry(shp, NULL)

shp.dists <- as.matrix(dist(cbind(shp_df$long, shp_df$lat)))

shp.dists.inv <- 1/shp.dists
diag(shp.dists.inv) <- 0

Moran.I(shp_df$fa, shp.dists.inv)
