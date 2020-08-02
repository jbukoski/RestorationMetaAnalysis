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

corrType = "spearman"

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
  
  testResults <- cor.test(dat[, 1], dat[, 2], method = corrType)
  
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
  select("v1", "v2", corr, p.val)

# Build matrix for correlations

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

# Build matrix for correlation p-values

var1 <- sum_dat$v1
var2 <- sum_dat$v2
r <- sum_dat$p.val

var <- unique(c(var1,var2))
pval <- matrix(1, nrow=6, ncol=6, byrow = T) # a matrix with 1s
pval[lower.tri(pval, diag = FALSE)] <- r # lower triangular matrix to be r
pval <- Matrix::forceSymmetric(pval, uplo="L")
pval <- as.matrix(pval)
pval <- as.data.frame(pval) # formatting
row.names(pval) <- var # row names
colnames(pval) <- var # column names

pval

# Write out summary results to file.
# summaryResults.csv = simple table of summary statistics
# corrMatrix.csv = correlations between variables formatted as a correlation matrix.

write_csv(summary, paste0("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/processed/summaryResults_", corrType, ".csv"))
write_csv(corr, paste0("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/processed/corrMatrix_", corrType, ".csv"))
write_csv(pval, paste0("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/data/processed/pvalMatrix_", corrType, ".csv"))


#-------------------------------------------------
# Build a histogram plot using shapefiles of 5,000 pts


library(ggthemes)
library(ggpubr)
library(gtable)
library(grid)
library(gridExtra)
library(sf)
library(tidyverse)

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
  "Flora Richness",
  "Invertebrate Abundance",
  "Invertebrate Richness",
  "Vertebrate Abundance",
  "Vertebrate Richness"
)

dist_dat2 <- dist_dat %>%
  separate(var, into = c("taxa", "metric")) %>%
  mutate(metric_alpha = ifelse(metric == "Abundance", 0.2, 0.1),
         metric = ifelse(metric == "Abundance", "Species Abundance", "Species Richness")) %>%
  group_by(taxa, metric) %>%
  mutate(avg_est = mean(estimate),
         med_est = median(estimate))

dat_text <- data.frame(
  label = c("A"),
  metric = c("Abundance")
)

legPlot <- dist_dat2 %>%
  ggplot() +
  geom_histogram(aes(estimate, col = taxa), fill = "white", alpha = 1) +
  scale_color_manual(values = c("#009E73", "#D55E00", "#0072B2"),
                     breaks = c("Flora", "Vertebrate", "Invertebrate"),
                     labels = c("Plants", "Vertebrates", "Invertebrates")) +
  theme_bw() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(family = "serif", size = 10))

leg <- get_legend(legPlot)

flora_text <- dist_dat2 %>%
  select(taxa, metric, med_est) %>%
  distinct() %>%
  mutate(metric = factor(metric, levels = c("Species Abundance", "Species Richness")),
         x =  med_est + 0.6, y = 2000,
         lab = round(med_est, 2))


flora <- dist_dat2 %>%
  filter(taxa == "Flora") %>%
  ggplot() +
  facet_wrap(. ~ metric, scales = "fixed", ncol = 2) +
  geom_histogram(aes(estimate), fill = NA, col = "#009E73", bins = 10) +
  scale_x_continuous(limits = c(0, 3)) +
  geom_vline(aes(xintercept = med_est), col = "#009E73", linetype = "dashed") +
  #annotate("text", x = 1, y = 2000, label = "poots") +
  geom_text(data = filter(flora_text, taxa == "Flora"), 
            aes(x = x -0.05, y = y, label = lab), family = "serif") +
  ylab("Frequency") +
  xlab("Deviation in Biodiversity Recovery") +
  theme_bw() +
  theme(legend.position = "none",
        strip.background = element_blank(),
        strip.text = element_text(family = "serif", size = 12),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(size = 10),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_blank())

verts <- dist_dat2 %>%
  filter(taxa == "Vertebrate") %>%
  ggplot() +
  facet_wrap(. ~ metric, scales = "fixed", ncol = 2) +
  geom_histogram(aes(estimate), col="#D55E00", fill = NA, bins = 10) +
  #scale_y_continuous(limits = c(0, 1000)) +
  scale_x_continuous(limits = c(0, 3)) +
  #geom_vline(aes(xintercept = avg_est), col = "orange", linetype = "solid") +
  geom_vline(aes(xintercept = med_est), col = "#D55E00", linetype = "dashed") +
  geom_text(data = filter(flora_text, taxa == "Vertebrate"), 
            aes(x = x + 0.05, y = 1800, label = lab), family = "serif") +
  #ggtitle("Vertebrates") +
  ylab("Frequency") +
  xlab("Deviation in Biodiversity Recovery") +
  theme_bw() +
  theme(legend.position = "none",
        strip.background = element_blank(), 
        strip.text = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(size = 10),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_blank())

inverts <- dist_dat2 %>%
  filter(taxa == "Invertebrate") %>%
  ggplot() +
  facet_wrap(. ~ metric, scales = "fixed", ncol = 2) +
  geom_histogram(aes(estimate), fill = "NA", col= "#0072B2", bins = 10) +
  scale_x_continuous(limits = c(0, 3)) +
  geom_vline(aes(xintercept = med_est), col = "#0072B2", linetype = "dashed") +
  geom_text(data = filter(flora_text, taxa == "Invertebrate"), 
            aes(x = x - 0.15, y = 2500, label = lab), family = "serif") +
  ylab("Frequency") +
  xlab("Deviation in Biodiversity Recovery") +
  theme_bw() +
  #annotation_custom(grob = leg, xmin = 1.5, xmax=3, ymin = 500, ymax = 2500) +
  theme(legend.position = "bottom",
        strip.background = element_blank(), 
        strip.text = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.title = element_text(size = 12),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_blank())


wo_leg <- grid.arrange(flora, verts, inverts,
             nrow = 3,
             left = textGrob("Frequency", rot = 90, vjust = 1, gp = gpar(fontfamily = "serif", fontsize = 12)),
             bottom = textGrob("Deviation in Biodiversity Recovery", gp = gpar(fontfamily = "serif", fontsize = 12)))

w_leg <- grid.arrange(wo_leg, leg, 
                      nrow = 2, heights = c(10, 1))


ggsave("~/Dropbox/manuscripts/RestorationMetaAnalysis/jacob/figs/fig3_draft4.jpg", w_leg, device = "jpeg", width = 4.5, height = 6, units = "in")


#------------------------------------------------------------------

##################################
## Autocorrelation tests & code ##
##################################

#------------------------------------------------------------------
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
