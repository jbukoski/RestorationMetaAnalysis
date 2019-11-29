Economic and Ecological Restoration Meta Analysis Project

### Repository created to host all scripts used in Socio Economic and Ecological Restoration Meta Analysis

## General information:  

#### :warning: Abour the analysis rounds:  
**Due to inconsistencies on the process a "fourth round" were done, changing the analysis structures, which were until that point linear, passing on each analysis round, and now all analysis is done in one unique process: the [fourth round](https://github.com/FelipeSBarros/RestorationMetaAnalysis#Fourth-Round)**  

**Historical steps:**  
 - [X] [Analysis validation](https://github.com/FelipeSBarros/RestorationMetaAnalysis#analysis-validation): Reproduce the same analysis done in Google Earth Engine on R to check the if results match;  
 - [X] ~~First Round Analysis: extract dataset values for different buffer sizes around study areas;~~  
 - [X] ~~Second Round Analysis: as first round was done missing few datasets, the second round should be the final one and with all layers expected~~;
 - [X] ~~Workshop update: After second round, an update was done adding more layers considering workshop commets by specialists. :warning: **Updated on 08/12/2018**~~;  
 - [X] ~~Preliminar output~~;  
 - [X] ~~Third round~~;  
 - [X] [Fourth round - Revision](https://github.com/FelipeSBarros/RestorationMetaAnalysis#Fourth-Round)  

## Analysis Validation  

To certify all analysis have been done correctly, a random study site was selected to run same analysis using R stats.
For results, [click here](https://felipesbarros.github.io/RestorationMetaAnalysis/R/AnalysisValidation.html)  

Another validation was done to confirm if focal kenrel were done considering de pixel centroid:
A variable was selectect and sampled its values for a points. With the same point we sampled the pixel value after a focal kernel with radius equals the pixel size. As the result was the same, qe qill disconsider the radius for the focal kernel with the same pixel size.

[GEE script](https://code.earthengine.google.com/3f54b3bd1eee02f061045fc3b4a45b16)  

## Covariate layers  

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
  * **UrbArea2019** = Urban Areas 2009  
* [Human Foot Print](http://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-footprint-geographic)  
  * **HFPrint** = 1995 - 2004
* [Urban Area - ESA Globe Cover](http://due.esrin.esa.int/page_globcover.php)  
  * **PercUrbArea09** = Percentual de area urbana 2009  
* [Rural poverty distribution](http://www.fao.org/geonetwork/srv/en/main.home#)  
  *   **RuralPvty** = ?  
  :warning: *Search for "Global distribution of rural poor population" on the search window*;  
  :warning: *This layer had its pixels with negative values (e.g. -998) reclasifyed to 0 as it seems to be indicating nodata areas = Urban Area*;  
* [ Rural population distribution (persons per pixel), 2000 (FGGD)](http://www.fao.org:80/geonetwork/srv/en/resources.get?id=14031&fname=Map_2_1.zip&access=private)  
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
* [IDH](https://datadryad.org/resource/doi:10.5061/dryad.dk1j0)  
  * **IDH03** = IDH value for 2003
  * **IDH9017** = mean IDH value between 1990 - 2017  
* Normalized Burn Ratio  
  * GEE - LANDSAT/LC8_L1T_ANNUAL_NBRT*  
  * **NBR1317** = mean NBR value between 2013 - 2017
* Burn Area Index  
  * GEE - LANDSAT/LC8_L1T_ANNUAL_BAI  
  * **BAI1317** = mean BAI value between 2013 - 2017  
* [CropLands](https://geography.wr.usgs.gov/science/croplands/
)  
  * **CropLands** = crop/non cropland;  
* [Croplands & Pastures](http://sedac.ciesin.columbia.edu/data/set/aglands-pastures-2000)  
  * **PastAgric** = Percentage of cropland OR agriculture;  
:warning: Seems to be wrong. As the link shows, the layer is just for pasture;  
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
* **IIS Opportunity cost**  
  * OpCostIISmasked  
  * OpCostIIS  
* **IIS Landuse**  
  * cropIIS  
  * pastoIIS  
  * croppastureIIS  
* [Governance](http://www.govindicators.org)
  * govrnce = governance  
  Government Effectiveness captures perceptions of the quality of public services, the quality of the civil service and the degree of its independence from political pressures, the quality of policy formulation and implementation, and the credibility of the government's commitment to such policies
* [Migration]  
  * deltaGHSL9015 [1990 - 2015]:  Migration estimated from [GHSL: Global Human Settlement Layers](http://ghsl.jrc.ec.europa.eu/ghs_pop.php)   
  * deltaGPWCount0010 [2000 - 2010]: [GPWv4: Population Count](https://doi.org/10.7927/H4X63JVC)  
  * deltaGPWDensity0010: Migration estimated from [GPWv4: Population Density](https://doi.org/10.7927/H4NP22DQ)  
* [WDPA: World Database on Protected Areas](http://pp-import-production.s3.amazonaws.com/WDPA_Manual_1_5.pdf):  
  * strictlyPA: Strictly Protected Areas  
  * SustainablePA: Sustainable Protected Areas  
* Gross Deforestation (Hansen based)  
  * GrossDef: Total deforested until 2010  
* Mean Temperature [World Clim](http://www.worldclim.org/version1)  
  * AnualTemp: Anual mean temperature  
* [Soil Data](https://soilgrids.org/)  
  * bldfie = bulkdensity  
  * phihox = phihox  
  * phikcl  
  * sndppt: Sand   

## Preliminary Output  
**Several preliminary results were done. You can filn the historical process on older commits;**  
After predictive selection done using randomForest algorithm on R, a preliminar predictive of the Landscape Variation were ran by biodiversity group (i.e. flora, vertebrates and invertebrates) on GEE;  
The preliminary result were executed due inconsistency found:  
:warning: The 'inconsistency' above mentioned were discussed and were realized that:  
* The focal process developed on R is quite "different" from expected;
* The focal process on GEE had the expected value;  

According to Hawthorne, the issue with R's focal implementation can be overcome with the code snippet:  
```r
focal(striclyPA, kernel, "sum", na.rm=TRUE) / sum(kernel)
```  

Thus the process to be run will all be done in GEE;  

## Fourth Round:  
All process were done in **GEE**. The script can be found [here](https://code.earthengine.google.com/acb4d16f13226894a0cbe5a18e18bc95);
During the validation process, few changes occured:  

1. Study site 181 was not used due its location doesn't fit the layer resolution;  
1. Layers with orignal resolution lower than 1Km had to be resampled to 1Km so GEE could afford all focal radius (see below a list of those layers);  
1. We are estimating only urban areas from [Globe Cover](http://due.esrin.esa.int/page_globcover.php). The ESA layer presented problem during the process;  
1. The Opportunity Cost layer had to be unmasked. So, non restorable sites present 0 opportunitycost; Also we added a sum of Opportunity Cost.  
1. Pasture layer where removed due conceptual inconsistency.  
1. Sustainabile Protected Area. had problem on estimation.  
1. Study site 75 (**for Flora Abundance**) was not used due its location wasn't right;  

### 4th Round Statistics Results
  :arrow_double_down: [All groups](https://felipesbarros.github.io/RestorationMetaAnalysis/Data/results/Biodiversity_Revision.csv)    

**Layers with rasolution lower than 1Km:**  

**30 m**
* grossdef  
* slope  
* yearMeanUntil10  
* f2003  
* Elevation  
* treeCover  

**250 m**  
* deltaGHSL9015  

**300 m**  
* cropIIS  
* pastoIIS  
* CropPastoIIS  
* UrbCover  

**500 m**  
* MeanNPP0010  
* NPP03  

### Spatial prediction
* **link to GEE spatial prediction:**  
  * [Flora Richness](https://code.earthengine.google.com/f5bd639b380414bb9ba34193d304acf2)  
  * [Flora Abundance](https://code.earthengine.google.com/f23f78296b7066c42744dbeb471151dd)  
  * [Vertebrates Richness](https://code.earthengine.google.com/e1fafc0c1f219de5bf8ce95dcd7f086e)  
  * [Vertebrates Abundance](https://code.earthengine.google.com/8e2051c606730af0f691e9b7b630d695)  
  * [Invertebrates Richness](https://code.earthengine.google.com/22a0d00809424b617a681161a55431df)  
  * [Invertebrates Abundance](https://code.earthengine.google.com/bd284cd63cdb43fc22065e337ff1d009)  

### Forest Areas [Mask]  
* **Link to GEE script:**  
  * [Forest areas mask & Restoration amount](https://code.earthengine.google.com/795f4a83d3b861e12ce51f05f51f1a0c)  

> ~~**Para que saibam:**
Os valores de variação da paisagem estão sendo calculados da seguintre forma:
Após a predição espacial, é mascarada pelas áreas florestais e restauráveis. 
Os valores remanescentes são, então, multiplicados (ponderados) pela quantidade de **área restaurável**. 
Esse dado de **área restaurável** representa o quanto o pixel precisa para chegar a 100% de densidade de cobertura florestal (hansen) multiplicado pela área do pixel.  
> **Exemplo:** Um pixel com 0 de cobertura florestal, precisa restaurar tudo para chegar a 100 (na verdade, 1), logo terá valor 1; Esse valor com a quatidade a ser restaurado foi multiplicado pela área do pixel em questão.  
Ou seja, além da densidade de conbertura florestal estamos trabalhando com a área a ser restaurada para chegar aos 100% de cobertura.~~  

## Final map  

![](./mapas/MapaFinal.png)  

## Pos processing  
1. Download results;
1. [Biomes and Countries data preparation]('./R/DataRasterization.R');  
1. [Mosaicking results]('./R/ResulsMosaicking.R');  
1. [Variation analysis]('./R/LandScapeVariationAnalysis.R')  

## Scripts  

### R  

* [Cation Exchange Capacity](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Calculating_SoilCEC.R)  
* [1st round data organization](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Organizing1stRoundSats.R)  
* [2nd round data organization](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Organizing2ndRoundSats.R)  
* [Buffer VS Moving Window estimates](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/BufferMovingWindow.R)  
* [3rd round data organization](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/R/Organing3rdRoundStat.R)  

### GDAL  

* [pos-processing scripts](https://github.com/FelipeSBarros/RestorationMetaAnalysis/blob/master/Bash/gdal_Scripts)  

## References  

* **Cation Exchange Capacity:** [Hengl et al. 2017](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0169748)  
* **Urban Area:** [ESA global LC maps at 300 m spatial resolution on an annual basis from 1992 to 2015;](http://maps.elie.ucl.ac.be/CCI/viewer/download.php)  
  * [User guide](http://maps.elie.ucl.ac.be/CCI/viewer/download/ESACCI-LC-QuickUserGuide-LC-Maps_v2-0-7.pdf)  
* **Global Road Density Rasters::** [Meijer et al 2018 Environ. Res. Lett](https://doi.org/10.1088/1748-9326/aabd42)  
* **"The Worldwide Governance Indicators:  Methodology and Analytical Issues"**.  World Bank Policy Research Working Paper No. 5430 (http://papers.ssrn.com/sol3/papers.cfm?abstract_id=1682130).  The WGI do not reflect the official views of the Natural Resource Governance Institute, the Brookings Institution, the World Bank, its Executive Directors, or the countries they represent."  
* Center for International Earth Science Information Network - CIESIN - Columbia University. 2016. **Gridded Population of the World, Version 4 (GPWv4): Population Density**. Palisades, NY: NASA Socioeconomic Data and Applications Center (SEDAC). https://doi.org/10.7927/H4NP22DQ. Accessed DAY MONTH YEAR.  
* Center for International Earth Science Information Network - CIESIN - Columbia University. 2016. **Gridded Population of the World, Version 4 (GPWv4): Population Count**. Palisades, NY: NASA Socioeconomic Data and Applications Center (SEDAC). https://doi.org/10.7927/H4X63JVC. Accessed DAY MONTH YEAR.  
* European Commission, Joint Research Centre (JRC); Columbia University, Center for International Earth Science Information Network - CIESIN (2015): **GHS population grid, derived from GPW4, multitemporal (1975, 1990, 2000, 2015)**. European Commission, Joint Research Centre (JRC) [Dataset] PID: http://data.europa.eu/89h/jrc-ghsl-ghs_pop_gpw4_globe_r2015a  
* UNEP-WCMC and IUCN (year), **Protected Planet: The World Database on Protected Areas (WDPA)** [On-line], [insert month/year of the version used], Cambridge, UK: UNEP-WCMC and IUCN Available at: www.protectedplanet.net.  
* http://www.fao.org/docrep/009/a0310e/a0310e00.htm  
