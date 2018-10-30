Economic and Ecological Restoration Meta Analysis Project

### Repository created to host all scripts used in Socio Economic and Ecological Restoration Meta Analysis

**General information:**  

 - [X] [Analysis validation](https://github.com/FelipeSBarros/RestorationMetaAnalysis#analysis-validation): Reproduce the same analysis done in Google Earth Engine on R to check the if results match;  
 - [X] [First Round Analysis](https://github.com/FelipeSBarros/RestorationMetaAnalysis#First-Round-Analysis): extract dataset values for different buffer sizes around study areas;  
 - [X] [Second Round Analysis](https://github.com/FelipeSBarros/RestorationMetaAnalysis#Second-Round-Analysis): as first round was done missing few datasets, the second round should be the final one and with all layers expected; :warning: **Updated on 29/10//2018**  

# Analysis Validation  

To certify all analysis have been done correctly, a random study site was selected to run same analysis using R stats.
For results, [click here](https://felipesbarros.github.io/RestorationMetaAnalysis/R/AnalysisValidation.html)  

# First Round Analysis

The statistics used for Ecological data where *mean* (\*_mean) and *standard deviation* (\*_stdDev);
The dataset were composed by:

* [Net Primary Production](http://dx.doi.org/10.5067/MODIS/MOD17A3H.006)  
  * **NPP0010** =  2000 - 2010
  * **NPP03** = 2003
* [Water Deficit](https://www.nature.com/articles/sdata2017191)  
  * **WDeficit8910** = 1989 - 2010
  * **WDeficit03** = 2003
  * **WDeficit99** = 1999
* [Hansen v:1.5](http://earthenginepartners.appspot.com/science-2013-global-forest)
  * **treecover2000** = Tree Cover Density year 2000  
* [World Clim](http://www.worldclim.org/version1)  
  * **YrlPrec** = Mean Precipitation
  * **DriestQuartes** = Driest Quarter (*bio 17*)
  * **PrecSeanslty** = Precipitation Seasonality (*bio 15*)
* [Soil Grid](https://soilgrids.org/)  
  * **CEC** = Cation Exchange (see [cec](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0169748))
* Opportunity Cost  
  * **OppCost** = Created by
* [ESA Globe Cover](http://due.esrin.esa.int/page_globcover.php)  
  * Urban Areas 2009

[Link to GEE analysis script](https://code.earthengine.google.com/d180ea0cdd8d61de0880a2ef0a297422)

### 1st Round Results  
 :arrow_double_down: [Buffer 5Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer5.csv)  
 :arrow_double_down: [Buffer 10Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer10.csv)  
 :arrow_double_down: [Buffer 25Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer25.csv)  
 :arrow_double_down: [Buffer 50Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer50.csv)  
 :arrow_double_down: [Buffer 100Km](https://felipesbarros.github.io/RestorationMetaAnalysis/R/results_Buffer100.csv)  

 # Second Round Analysis

 where added to the analysis the variables:

 * [Human Foot Print](http://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-footprint-geographic)  
    * **HFPrint** = 1995 - 2004
 * [Urban Area - ESA Globe Cover](http://due.esrin.esa.int/page_globcover.php)  
    * **PercUrbArea** = 2009  
 * [Rural poverty distribution](http://www.ciesin.columbia.edu/povmap/ds_global.html)  
    *   **RuralPvty** = ?  
  *This layer had its pixels with negative values (e.g. -998) reclasifyed to 0 as it seems to be indicating nodata areas = Urban Area*;
 * [ Rural population distribution (persons per pixel), 2000 (FGGD)](http://www.worldclim.org/version1)  
    * **RuralPop** = 2007  
 * [ Hansen tree cover](http://earthenginepartners.appspot.com/science-2013-global-forest)  
    * **f2003** = 2003
    * **ForestUntl10** = 2000 - 2010
 * [ Global Roads Inventory Project - GRIP - version 4](https://doi.org/10.1088/1748-9326/aabd42)  
    * **TotalRoadDensity** = density for all roads, equally weighted  
    * **T1RoadDensity** = density for GRIP type 1 - highways  
    * **T2RoadDensity** = density for GRIP type 2 - primary roads  
    * **T3RoadDensity** = density for GRIP type 3 - secondary roads  
    * **T4RoadDensity** = density for GRIP type 4 - tertiary roads  
    * **T5RoadDensity** = density for GRIP type 5 - local roads  

## Workshop updates (29/10/2018)  
* [IDH](https://datadryad.org/resource/doi:10.5061/dryad.dk1j0)  
   * **IDH03** = IDH value for 2003
   * **IDH9017** = mean IDH value between 1990 - 2017  
* Normalized Burn Ratio  
#GEE - LANDSAT/LC8_L1T_ANNUAL_NBRT  
    * **NBR1317** = mean NBR value between 2013 - 2017
* Burn Area Index  
#GEE - LANDSAT/LC8_L1T_ANNUAL_BAI  
    * **BAI1317** = mean BAI value between 2013 - 2017  
* [CropLands](https://geography.wr.usgs.gov/science/croplands/
)  
    * **CropLands** = Percentage of cropland;
* [Croplands & Pastures](http://sedac.ciesin.columbia.edu/data/set/aglands-pastures-2000)  
    * **PastAgric** = Percentage of cropland OR agriculture;
* [Elevation SRTM 30m](https://lpdaac.usgs.gov/sites/default/files/public/measures/docs/SRTM%20Quick%20Guide.pdf)  
    * **Elevation** = mean elevation in meters;
* [Slope](https://developers.google.com/earth-engine/api_docs#eeterrainslope)  
    * **Slope** = mean slope in degrees  
* [Curtis et al. (**Commodities**)](http://science.sciencemag.org/content/suppl/2018/09/12/361.6407.1108.DC1)  
    * **Commodity-driven Deforestation: cdd** = Perc Commidity driven deforestation  
    * **Shifting Agriculture: sa** =  Perc Argriculture driven deforestation  
    * **Forestry: fty** =  Perc Forestry driven deforestation  
    * **Wildfire: wfire** = Perc Wildfire driven deforestation  
    * **Urbanization: urb** = Perc Urban driven deforestation  

 [Link to GEE analysis script](https://code.earthengine.google.com/7c7625b76428269c24c5f00c919f8473)

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
* **Global Road Density Rasters::** [Meijer et al 2018 Environ. Res. Lett](https://doi.org/10.1088/1748-9326/aabd42)  
