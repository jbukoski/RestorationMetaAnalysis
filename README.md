# Socio Economic and Ecological Restoration Meta Analysis Project

### Repository created to host all scripts used in Socio Economic and Ecological Restoration Meta Analysis

**General information:**  

 - [X] [Analysis validation](https://github.com/FelipeSBarros/RestorationMetaAnalysis#analysis-validation): Reproduce the same analysis done in Google Earth Engine on R to check the if results match;  
 - [X] [First Round Analysis](https://github.com/FelipeSBarros/RestorationMetaAnalysis#First-Round-Analysis): extract dataset values for different buffer sizes around study areas;  
 - [X] [Second Round Analysis](): as first round was done missing few datasets, the second round should be the final one and with all layers expected;  

# Analysis Validation  

To certify all analysis have been done correctly, a random study site was selected to run same analysis using R stats.
For esults, [click here](https://felipesbarros.github.io/RestorationMetaAnalysis/R/AnalysisValidation.html)  

# First Round Analysis

The statistics used for Ecological data where *mean* (\*_mean) and *standard deviation* (\*_stdDev);
The dataset were composed by:

* [Net Primary Production](http://dx.doi.org/10.5067/MODIS/MOD17A3H.006)  
  * 2000 - 2010
  * 2003
* [Water Deficit](https://www.nature.com/articles/sdata2017191)  
  * 1989 - 2010
  * 2003
  * 1999
* [Hansen v:1.5](http://earthenginepartners.appspot.com/science-2013-global-forest)
  * Tree Cover Density year 2000  
* [World Clim](http://www.worldclim.org/version1)  
  * Mean Precipitation
  * Driest Quarter (*bio 17*)
  * Precipitation Seasonality (*bio 15*)
* [Soil Grid](https://soilgrids.org/)  
  * Cation Exchange (see [cec](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0169748))
* Opportunity Cost  
  * Created by
* [ESA Globe Cover](http://due.esrin.esa.int/page_globcover.php)  
  * Urban Areas 2009

[Link to GEE analysis script](https://code.earthengine.google.com/6a978e79a1acb1cd2fb9a3e53a0ea456)

### 1st Round Results  
 :arrow_double_down: [Buffer 5Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer5.csv)  
 :arrow_double_down: [Buffer 10Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer10.csv)  
 :arrow_double_down: [Buffer 25Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer25.csv)  
 :arrow_double_down: [Buffer 50Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer50.csv)  
 :arrow_double_down: [Buffer 100Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer100.csv)  

 # Second Round Analysis

 where added to the analysis the variables:

 * [Human Foot Print](http://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-footprint-geographic)  
   * 1995 - 2004
 * [Urban Area - ESA Globe Cover](http://due.esrin.esa.int/page_globcover.php)  
   * 2009  
 * [Rural poverty distribution](http://www.ciesin.columbia.edu/povmap/ds_global.html)  
   *  
 * [ Rural population distribution (persons per pixel), 2000 (FGGD)](http://www.worldclim.org/version1)  
   * 2007  

 [Link to GEE analysis script](https://code.earthengine.google.com/73c27acb4c39cc3fa00ccfe8d3de5170)

 ### 2nd Round Results  
  :arrow_double_down: [Buffer 5Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/2ndRound_results_Buffer5.csv)  
  :arrow_double_down: [Buffer 10Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/2ndRound_results_Buffer10.csv)  
  :arrow_double_down: [Buffer 25Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/2ndRound_results_Buffer25.csv)  
  :arrow_double_down: [Buffer 50Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/2ndRound_results_Buffer50.csv)  
  :arrow_double_down: [Buffer 100Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/2ndRound_results_Buffer100.csv)  

# Scripts  

## R  

* [Cation Exchange Capacity](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Calculating_SoilCEC.R)  
* [1st round data organization](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Organizing1stRoundSats.R)  
* [2nd round data organization](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Organizing2ndRoundSats.R)  

# References  

* **Cation Exchange Capacity:** [Hengl et al. 2017](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0169748)  
* **Urban Area:** [ESA global LC maps at 300 m spatial resolution on an annual basis from 1992 to 2015;](http://maps.elie.ucl.ac.be/CCI/viewer/download.php)  
  * [User guide](http://maps.elie.ucl.ac.be/CCI/viewer/download/ESACCI-LC-QuickUserGuide-LC-Maps_v2-0-7.pdf)  
