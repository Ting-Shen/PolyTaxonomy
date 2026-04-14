# Species Identification Analysis of R. dubia and R. indica

Created by Jun-Xian Lv (13769823649@163.com), Ting-Shen Han (hantingshen@xtbg.ac.cn)

## Kernel Density Analysis

### Issues to Address:

How are the specimens distributed before and after secondary identification, and what are their actual distribution areas?

### Principles of Kernel Density Analysis

[Kernel Density Analysis](https://pro.arcgis.com/zh-cn/pro-app/3.2/tool-reference/spatial-analyst/kernel-density.htm) is used to calculate the density of features in their surrounding neighborhoods. It can be applied to both point and line features. It is also used to **calculate the density of point features around each output raster cell**. A smooth surface is overlaid on each point, with the highest value at the point's location, gradually decreasing as the distance from the point increases, and reaching zero at the search radius distance. The neighborhood can only be circular. The volume enclosed by the surface and the underlying plane equals the value of the point's Population field. If this field is set to NONE, the volume is 1. The density of each output raster cell is the sum of the values of all kernel surfaces overlapping the center of the raster cell. The density units for point and line features can be manually adjusted by selecting the appropriate factor. To set the density unit to meters/square meters (instead of the default kilometers/square kilometers), set the area unit to square meters. Similarly, to set the output density unit to miles/square miles, set the area unit to square miles. For the current analysis, the unit area is set to 2 square miles. (Reference: **Silverman, B. W. *Density Estimation for Statistics and Data Analysis*. New York: Chapman and Hall, 1986.**)

### Steps for Kernel Density Analysis

1. Prepare GPS coordinate data for R.dubia and R.indica before and after identification. 

2. Import the basemap (China map, with the study area being China; further subdivision of the study area may be needed) into ArcMap 10.8. 

3. Set the coordinate system and display the XY coordinates of the GPS data.

4. In ArcToolBox → Spatial Analyst → Density Analysis → Kernel Density Analysis → Select the file → Set the output cell size (using the smallest value among the five datasets as the baseline, with consistent parameters for all four files) → Environment → Advanced Geodatabase → XY Domain (specify the study area for analysis) → Raster Analysis → Mask (specify the study area for analysis) → Search radius of 2 miles → Confirm (run).

5. There are four datasets in total: two for R.dubia before and after identification, and two for R.indica before and after identification. To ensure comparable and high-precision output results, the output cell size must be set to the smallest value among the five datasets.

6. Adjust the output gradient, beautify the results, and generate the final map. 

## MaxEnt Distribution Area Prediction

### Issues to Address:

1. Clarify the impact of identification results on ecological niches and distribution areas.

2. Screen the main environmental factors influencing the spatial distribution of R.dubia and R.indica.

3. Predict future distribution areas.

### Analysis Principles

#### 1. Environmental Factor Correlation Analysis

To screen environmental factors and avoid overfitting in subsequent prediction models, correlation analysis is performed on the cleaned Worldclim climate data (using latitude and longitude data to match Worldclim climate data). The principle of Pearson correlation analysis is as follows: Correlation analysis uses correlation coefficients to study whether there is a relationship between data and the strength of that relationship. Correlation analysis is often used before regression analysis, as a correlation relationship generally precedes a regression influence relationship. Correlation coefficients can generally be divided into Pearson correlation coefficients and Spearman correlation coefficients, with the Pearson correlation coefficient being the most commonly used. The Pearson correlation coefficient ranges from [-1, 1]. When r > 0, it indicates a positive correlation between the two variables; when r < 0, it indicates a negative correlation. Generally, the interpretation of the correlation coefficient is as follows: |r| = 1 indicates a perfect correlation; |r| ≥ 0.8 indicates a high correlation; 0.5 ≤ |r| < 0.8 indicates a moderate correlation; 0.3 ≤ |r| < 0.5 indicates a low correlation; |r| < 0.3 indicates essentially no correlation.

#### 2. Spatial Thinning and Nearest Neighbor Analysis

The [Spatial Autocorrelation (Global Moran's I)](https://desktop.arcgis.com/zh-cn/arcmap/10.3/tools/spatial-statistics-toolbox/spatial-autocorrelation.htm) tool measures spatial autocorrelation based on both feature locations and feature values. Given a set of features and their associated attributes, the tool evaluates whether the expressed pattern is clustered, dispersed, or random. The tool calculates the Moran's I index value, [z-score, and p-value](https://desktop.arcgis.com/zh-cn/arcmap/10.3/tools/spatial-statistics-toolbox/what-is-a-z-score-what-is-a-p-value.htm) to assess the significance of the index. The [p-value](https://desktop.arcgis.com/zh-cn/arcmap/10.3/tools/spatial-statistics-toolbox/what-is-a-z-score-what-is-a-p-value.htm) is an approximate area derived from a known distribution curve (limited by the test statistic). Spatial thinning (removing spatial autocorrelation) is applied to species occurrence datasets. A randomization algorithm (thinning algorithm) is used to ensure that all occurrence locations are separated by at least the thinning distance. Spatial thinning helps reduce the impact of uneven or biased species occurrence collections on spatial model results.

Average Nearest Neighbor Analysis: Estimates the clustering degree of points by comparing the average distance of each point to its nearest neighbor with the expected average distance under random distribution. For species distribution modeling, we aim to find data with randomly distributed points, i.e., data simulated by spThin. We use the Average Nearest Neighbor Index (ANNI) to evaluate the degree of spatial autocorrelation in the data.

ANNI (Average Nearest Neighbor Ratio) is expressed as the ratio of the "average observed distance" to the "expected average distance." The expected average distance is the average distance between neighbors under the assumption of random distribution.

* ANNI > 1: Dispersed point distribution.

* ANNI = 1: Random point distribution.

* ANNI < 1: Clustered point distribution.

For details on Average Nearest Neighbor Analysis, see: https://pro.arcgis.com/zh-cn/pro-app/latest/tool-reference/spatial-statistics/h-how-average-nearest-neighbor-distance-spatial-st.htm.

#### 3. MaxEnt Parameter Optimization (R Language ENMeval Package ENMevaluate Function)

The R language ENMeval package's ENMevaluate function is used to run MaxEnt models with a series of modified parameters. The optimal model is selected based on the **AICc value** and **rm value** (**Regularization multiplier: Multiply all automatic regularization parameters by this number. A higher number gives a more spread-out distribution**). ENMevaluate automatically executes MaxEnt under various settings and returns a data frame of evaluation metrics to help determine the settings that balance model fit and predictive performance. For details, see https://cran.r-project.org/web/packages/ENMeval/ENMeval.pdf.

#### 4. MaxEnt Model Construction

The MaxEnt model is a species distribution model based on the principle of maximum entropy. It combines known actual species distributions with corresponding environmental variables to predict the most probable distribution of the species under certain ecological niche constraints, i.e., the state of maximum entropy. The MaxEnt model provides accurate predictions even for species with limited sample sizes, small geographic ranges, and restricted environmental tolerance.

#### 5. Future Distribution Prediction

The best model data selected by the MaxEnt model and Worldclim CMIP5 2.5-minute data for the years 2041–2060 are used. Future climate change scenarios and different atmospheric model resolutions are also considered.

1. CMIP5 Future Climate Change Scenarios (The Representative Concentration Pathways (RCPs) for CMIP5:

| Scenario            | Radiative Forcing (2010–2100)                                                     | Greenhouse Gas Emissions |
| ------------------- | :-------------------------------------------------------------------------------- | ------------------------ |
| RCP2.6 (Mitigation) | Peaks at 3 W/m² (equivalent to 490 ppm CO₂) and then declines to 2.6 W/m² by 2100 | Very Low                 |
| RCP4.5 (Medium)     | Stabilizes at 4.5 W/m² (equivalent to 650 ppm CO₂) by 2100                        | Low                      |
| RCP6.0 (Medium)     | Stabilizes at 6.0 W/m² (equivalent to 850 ppm CO₂) by 2100                        | Medium                   |
| RCP8.5 (Severe)     | Increases to 8.5 W/m² (equivalent to 1370 ppm CO₂) by 2100                        | High                     |

**Selected Scenarios: RCP4.5, RCP6.0, RCP8.5**

**Resolution: 2.5 minutes**

2. Global Climate Models (GCMs):

Three types of simulation experiments are conducted based on different atmospheric model resolutions, which correspond to different future climate predictions. Generally, they are divided into three categories:

* Long-term simulations (over 100 years) using low-to-medium resolution models.

* **Short-term simulations (decadal climate predictions) using medium-resolution models.**

* High-resolution atmospheric model experiments, which require significant computational resources.

**Models and Their Corresponding Resolutions:**

| GCMs           | Institution               | Atmospheric Resolution | RCP4.5 | RCP6.0 | RCP8.5 |
| -------------- | ------------------------- | ---------------------- | ------ | ------ | ------ |
| MPI-CGCM3      | MRI (Japan)               | 0.6°×0.6°              | bi     | bi     | bi     |
| CCSM4          | NCAR (USA)                | 0.9°×1.3°              | bi     | bi     | bi     |
| ACCESS1-0      | CSIRO-BOM (Australia)     | 1.3°×1.9°              | bi     |        | bi     |
| HadGEM2-CC     | Hadley Center (UK)        | 1.3°×1.9°              | bi     |        | bi     |
| **MIROC5**     | AORI-NIES-JAMSTEC (Japan) | 1.4°×1.4°              | bi     | bi     | bi     |
| inmcm4         | INM (Russia)              | 1.5°×2.0°              | bi     |        | bi     |
| MPI-ESM-LR     | MPI-M (Germany)           | 1.9°×1.9°              | bi     |        | bi     |
| **NorESM1-M**  | NCC (Norway)              | 1.9°×2.5°              | bi     | bi     | bi     |
| IPSL-CM5A-LR   | IPSL (France)             | 1.9°×3.8°              | bi     | bi     | bi     |
| GFDL-CM3       | GFDL (USA)                | 2.0°×2.5°              | bi     |        | bi     |
| **GISS-E2-R**  | GISS (USA)                | 2.0°×2.5°              | bi     | bi     | bi     |
| BCC_CSM1.1     | BCC (China)               | 2.8°×2.8°              | bi     | bi     | bi     |
| MIROC-ESM      | AORI-NIES-JAMSTEC (Japan) | 2.8°×2.8°              | bi     | bi     | bi     |
| MIROC-ESM-CHEM | AORI-NIES-JAMSTEC (Japan) | 2.8°×2.8°              | bi     | bi     | bi     |

3. The selected bioclimatic variables (bio1, bio2, bio3, bio7, bio8, bio12, bio15) remain consistent with the previous model. Multiple models are generated due to different GCMs and RCPs. The average of the same RCP concentrations is calculated as the final model.

4. References:

ZHOU Tianjun, ZOU Liwei, WU Bo, JIN Chenxi, SONG Fengfei, CHEN Xiaolong, ZHANG Lixia. 2014. Development of earth/climate system models in China: A review from the Coupled Model Intercomparison Project perspective. Acta Meteorologica Sinica, 72(5): 892-907.

Address: [Review of Earth/Climate System Model Development in China: A 20-Year Retrospective of CMIP (rhhz.net)](http://html.rhhz.net/qxxb_cn/html/2014083.htm#outline_anchor_18)

### SDM Analysis

1. Correlation Analysis

Code adapted from Ting-Shen Han.

```R
# 1. Cleaning Worldclim climate data:
# Data preparation: Species GPS data and 19 bioclimatic variables downloaded from Worldclim.
# R code for fitting the two datasets:

setwd("~") # Set working directory

library(raster)
library(stringr)

loc = read.csv('first_rd.csv') # Read GPS file (only one dataset is shown here; the code is the same for others)
coordinates(loc) = c("lon", "lat") # Rename latitude and longitude
colnames(loc)

# Read downloaded Worldclim data
bio1 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_1.tif') 
bio2 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_2.tif')
bio3 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_3.tif')
bio4 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_4.tif')
bio5 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_5.tif')
bio6 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_6.tif')
bio7 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_7.tif')
bio8 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_8.tif')
bio9 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_9.tif')
bio10 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_10.tif')
bio11 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_11.tif')
bio12 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_12.tif')
bio13 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_13.tif')
bio14 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_14.tif')
bio15 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_15.tif')
bio16 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_16.tif')
bio17 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_17.tif')
bio18 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_18.tif')
bio19 <- raster('~/MaxEnt analyse/correlation analysis/worldclim_data/wc2.1_2.5m_bio_19.tif')

# Clean Worldclim data using latitude and longitude data
res_bio1 <- extract(x = bio1, y = loc) 
res_bio2 <- extract(x = bio2, y = loc)
res_bio3 <- extract(x = bio3, y = loc)
res_bio4 <- extract(x = bio4, y = loc)
res_bio5 <- extract(x = bio5, y = loc)
res_bio6 <- extract(x = bio6, y = loc)
res_bio7 <- extract(x = bio7, y = loc)
res_bio8 <- extract(x = bio8, y = loc)
res_bio9 <- extract(x = bio9, y = loc)
res_bio10 <- extract(x = bio10, y = loc)
res_bio11 <- extract(x = bio11, y = loc)
res_bio12 <- extract(x = bio12, y = loc)
res_bio13 <- extract(x = bio13, y = loc)
res_bio14 <- extract(x = bio14, y = loc)
res_bio15 <- extract(x = bio15, y = loc)
res_bio16 <- extract(x = bio16, y = loc)
res_bio17 <- extract(x = bio17, y = loc)
res_bio18 <- extract(x = bio18, y = loc)
res_bio19 <- extract(x = bio19, y = loc)

# Merge cleaned data
res <- data.frame(loc, res_bio1, res_bio2, res_bio3, res_bio4, res_bio5,
                  res_bio6, res_bio7, res_bio8, res_bio9, res_bio10, res_bio11,
                  res_bio12, res_bio13, res_bio14, res_bio15, res_bio16, res_bio17, res_bio18, res_bio19)

# Output cleaned data
write.xlsx(res, "first_rd_output1.xlsx") 

# 2. Perform Pearson correlation analysis on cleaned Worldclim data

setwd("~/MaxEnt analyse/correlation analysis/input&output data") # Set working directory

ro <- read.csv("first_rd_output1.csv") # Read cleaned Worldclim data
var <- ro[, 3:21] 
cor(var, method = "pearson", use = "complete.obs") # Perform Pearson correlation analysis
pcar <- cor(var, method = "pearson", use = "complete.obs") 

write.csv(pcar, file = "first_rd_output2.csv") # Output correlation analysis results

# Perform correlation analysis on five datasets: first_rd, first_ri, second_rd, second_rh, second_ri. Analyze and screen the main environmental factors influencing R.dubia and R.indica based on the results.

```

2. Spatial Thinning (Removing Spatial Autocorrelation) and Average Nearest Neighbor Analysis (Evaluating Spatial Autocorrelation Degree)

Code adapted from Ting-Shen Han. 

```R
# Spatial thinning (spThin) of GPS data
# spThin: spatial thinning of species occurrence records
# Remove all other things

rm(list = ls()) # Clear workspace

# Load the library
library(spThin)

# Set the working directory
setwd("~/MaxEnt analyse/spThin and nearest neighbor analysis/spThin/input data") # Set working directory

# Load dataset
thin.data <- read.csv("1strd.csv") # Read file

# Spatially thin species occurrence data
# Use "thin.par = ?" to set the distance (in kilometers, ?) that you want your records to be separated by.
# Use "reps = ?" to set the number of times to repeat the thinning process.

thin(thin.data, lat.col = "Latitude", long.col = "Longitude", spec.col = "VCF_ID", thin.par = 2, reps = 1, max.files = 1, out.dir = "~/MaxEnt analyse/spThin and nearest neighbor analysis/spThin/input data/1strd") # Perform spatial thinning and output results

# Seven datasets: 1strd, 1stri, 2ndrd, 2ndrh, 2ndri, rc, rg. Each dataset is spatially thinned at intervals of 0–150 km in 5 km increments. The dataset with the Average Nearest Neighbor Index (ANNI) closest to 1 is selected, while the original unthinned data is retained.
```

Average Nearest Neighbor Analysis:

1. Prepare spatially thinned data. Import into ArcMap, display XY data, set the geographic coordinate system (all analyzed data should use the same geographic coordinate system), and export as a .shp file.

2. Re-add the exported .shp file to the layer. Click ArcToolbox → Data Management Tools → Projections and Transformations → Project, select the added layer, transform it to the projected coordinate system (all analyzed data should use the same projected coordinate system), and output the projected coordinate system.

3. Re-add the projected coordinate system to the layer. Click ArcToolbox → Spatial Statistics Tools → Analyzing Patterns → Average Nearest Neighbor, select the projected layer, generate a report, and confirm the output .

4. Compile all Average Nearest Neighbor Indices. For each dataset, select three spatially thinned datasets to build the MaxEnt model.

3) MaxEnt Parameter Optimization (R Package ENMeval, ENMevaluate() Function)

```R
# MaxEnt parameter optimization
library(dismo)
library(ENMeval)
library(raster)
library(sp)
library(sf)
library(dplyr)
library(rJava)

setwd("~/MaxEnt analyse/maxent parameter tuning and results/enmed_maxent_choose1/1strd")

occs <- read.csv("1strd_70km.csv") # Latitude and longitude data after removing spatial autocorrelation. Column names: species-Lon-Lat (adjust if the order is reversed).
occs <- occs[, 2:3] # Extract the second and third columns (Lon, Lat)
colnames(occs) <- c("x", "y") # Rename columns to match background points (bg)
files = dir(pattern = "*.asc") # List all .asc format files (can be .tiff files)
clim = list() # Create an empty list

for (i in 1:length(files)) {
  t_texture <- raster::stack(files[i]) # Import .asc files
  clim[i] <- t_texture
} # Loop to create a list (clim) of all .asc files

bg <- dismo::randomPoints(clim[[1]], n = 10000) %>% as.data.frame() # Generate background points (default: 10,000)

result <- ENMevaluate(occs = occs[, 1:2], # Latitude and longitude data
                      envs = clim, # Environmental layers
                      bg = bg[, 1:2], # Background points
                      partitions = 'checkerboard2', # Five options: "randomkfold", "jackknife", "block", "checkerboard1", and "checkerboard2"
                      tune.args = list(fc = c("L", "LQ", "H", "LQH", "LQHP", "LQHPT"), rm = c(0.1, seq(0.5, 6, 0.5))),
                      algorithm = 'maxent.jar') 

delta_AICc3 <- evalplot.stats(e = result,
                              stats = c("delta.AICc"),
                              color = "fc",
                              x.var = "rm",
                              error.bars = FALSE) # Plot delta_AICc curve

pdf('1strd_70km.pdf', width = 5, height = 4) # Generate PDF

print(1strd_70km) # Print PDF
dev.off() # Save PDF file

# Perform MaxEnt parameter optimization on all data screened by spThin and Average Nearest Neighbor Analysis. Each dataset requires different parameters.
```

4. Run the MaxEnt Model

Each dataset is spatially thinned into 10 subsets. For each thinned dataset, there are **six fc parameters ("L", "LQ", "H", "LQH", "LQHP", "LQHPT")** and **13 rm values (0.1, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6)**. Seventy-five percent of the data is used as the training set, and 25% is used as the test set. The model is run once, resulting in 78 models. The **optimal fc parameter and rm value** are selected. 

5. Future Distribution Prediction

Use the four best MaxEnt distribution prediction models (file location: `~/MaxEnt analyse/future delimitation/input_data`). Set MaxEnt model parameters to match the previous models. Download CMIP5 future bioclimatic variables from Worldclim ([WorldClim](https://worldclim.org/)). Crop the downloaded climate variables to the study area (`~/MaxEnt analyse/future delimitation/input_data\worldclim_data`). Perform model prediction (`~/MaxEnt analyse/future delimitation/input_data\worldclim_data`). Process the prediction results by dividing the probability range into 0–0.8 and 0.8–1 (`~/MaxEnt analyse\future delimitation/output_data/1strd/arcmap_result/image analyst`). Complete the future distribution prediction.

### Result Outputs

1. Environmental Factor Correlation Analysis 

2. Spatial Thinning and Average Nearest Neighbor Analysis — spThin 

3. MaxEnt Parameter Optimization (**R** Language ENMeval Package ENMevaluate Function) 

4. Run MaxEnt Model and Screen Models

5. Current and Future MaxEnt Distribution Prediction Results

## Niche Overlap Analysis

### Issues to Address

The impact of identification results on distribution areas and ecological niches (distribution areas, ecological niches).

### Analysis Principles

The ecological niche (***ecological niche***) not only reflects the actual outcomes of interspecific relationships in communities but also serves as the driving force behind community characteristics, interspecific competition, and evolution. Niche metrics include niche width and niche overlap, which are based on population distribution data across a range of resource states. Niche overlap reflects the efficiency of resource utilization and the degree of resource sharing between two species, with higher overlap values indicating stronger competition. Niche overlap analysis typically involves dividing samples into plots and counting the number of individuals within each plot. Here, we use China's administrative divisions at the municipal level to define plots. GPS data is imported, and the number of individuals per plot is counted ([Spatial Join (Analysis)—ArcGIS Pro | Documentation](https://pro.arcgis.com/zh-cn/pro-app/latest/tool-reference/analysis/spatial-join.htm)). Reference: Zhang Jinlong, Ma Keping (2014). Interspecific Association and Niche Overlap Calculation: spaa Package. In Ma Keping (Ed.), *Advances in Biodiversity Conservation and Research in China*. Beijing: Meteorological Press, 165–174.

### Analysis Steps

1. Import China's municipal administrative division basemap. Import raw data and GPS data for MaxEnt modeling into ArcGIS. Set a unified coordinate system. Display XY data for GPS and export as .shp files.

2. ArcToolbox → Analysis Tools → Overlay → Spatial Join → Input target features as China's municipal administrative division basemap, join features as GPS data in .shp format. Match option: COMPLETELY_CONTAINS → Export result layer → Open layer attribute table → Select all options and copy to a new table → FID is the plot number, Join_Count is the number of species individuals per plot. 

3. Merge all species plots and individual counts. Use the R language spaa package to calculate niche overlap indices. 

```R
# Example data format: Plot-Species-Species...
# Two or more species and n plots with species counts per plot.

# R code
library(spaa)

# Read data, where rows are species names and columns are plot IDs.
mydata <- read.csv(file.choose(), header = T, row.names = 1)
niche.overlap(mydata, method = c("levins"))
niche.overlap(mydata, method = c("schoener"))
niche.overlap(mydata, method = c("petraitis"))
niche.overlap(mydata, method = c("pianka"))
niche.overlap(mydata, method = c("czech"))
niche.overlap(mydata, method = c("morisita"))
```

4. Organize niche overlap indices and perform niche t-tests. 

```R
setwd("~")
data <- read.csv('*.csv')
t.test(data$a, mu = 1)
t.test(data$b, mu = 1)
t.test(data$c, mu = 1)
t.test(data$d, mu = 1)
t.test(data$e, mu = 1)
t.test(data$f, mu = 1)
```

## Decision Tree Analysis

### Problems to be Solved

1. Identify influencing factors on identification results (phenotype, collection information).
2. Trace back the identification process and analyze reasons for identification errors.

### Analysis Principle

Decision Trees are models using tree-like structures to represent decision rules and classification outcomes. As an inductive learning algorithm, they focus on converting seemingly unordered and chaotic known data into a tree-structured model capable of predicting unknown data. Each path from the root node (attribute contributing most to final classification) to leaf nodes (final classification outcome) represents a decision rule. By constructing a decision tree, the specimen identification process can be retraced to explore the influence of phenotypic traits on identification outcomes.

Conditional inference trees:
- Advantages: Do not require pruning as complexity is controlled by threshold values, producing unique results from the same dataset.
- Disadvantages: Do not allow missing data, resulting in information loss.

Classification and regression tree (CART) algorithm:
- Advantages: Allow missing data, minimizing information loss through pruning to select the optimal tree model.
- Disadvantages: Generates diverse tree models, necessitating selection from multiple models.

### Analysis Operation Steps

Prepare two datasets: one without missing values for constructing conditional inference trees, and one allowing missing values for the CART algorithm.

Use the following pipelines to perform decision tree analyses.

#### Conditional inference tree (R code source: [Decision tree analysis - cnblogs.com](https://www.cnblogs.com/YY-zhang/p/15152971.html))

```R

setwd("~/Decision Tree analysis/data")

traindata <- read.csv("~.csv")

names(traindata) <- c("id", "results", "Phenology", "Petal", "Fruit", "Leaf", "Seed")

traindata$y <- as.factor(traindata$results)

set.seed(1234)

ind <- sample(2, nrow(traindata), replace=TRUE, prob=c(0.7, 0.3))

trainData <- traindata[ind==1,]

testData <- traindata[ind==2,]

myFormula <- y ~ Phenology + Petal + Fruit + Leaf + Seed

library(party)
rorippa_ctree <- ctree(myFormula, data=trainData)
table(predict(rorippa_ctree), trainData$y)
plot(rorippa_ctree)
```

#### Classification and Regression Tree

```R
# Using R's rpart package (100 iterations)
# Load training dataset
traindata <- read.csv(file.choose())

# Rename original columns
names(traindata) = c("id", "results", "Phenology", "Petal", "Fruit", "Leaf", "Seed")

# Convert results to factor format
traindata$y = as.factor(traindata$results)
head(traindata)

# Randomly select 70% of data
select <- sample(1:nrow(traindata), length(traindata$id)*0.7)

# Use 70% as training set
train = traindata[select,]

# Use remaining 30% as test set
test = traindata[-select,]

library(rpart)
# Set pruning parameters:
# minsplit: minimum number of observations to split a node (if <50, stop splitting)
# minbucket: minimum number of observations in a terminal node
# maxdepth: maximum tree depth
# xval: number of cross-validations (10-fold here)
# cp: complexity parameter (threshold for improvement at each split)

tc <- rpart.control(minsplit = 50, minbucket = 20, maxdepth = 30, xval = 10, cp = 0.001)

# Define formula
formular = results ~ Phenology + Petal + Fruit + Leaf + Seed

# Build model parameters:
# formula: y ~ x1 + x2 + x3
# data: data frame containing variables
# na.action: how to handle missing values (default removes cases with missing values)
# method: splitting method ("class" for classification)
# parms: parameters including:
#   - prior: class probabilities (0.6, 0.4)
#   - loss: loss matrix (misclassification costs)
#   - split: splitting criterion ("gini" for Gini index)

rpart.mod = rpart(formular, data = train, method = "class",
                parms = list(prior=c(0.6,0.4), loss=matrix(c(0,1,2,0),nrow=2), split="gini"),
                control = tc)

# Pruning process:
# rpart provides complexity parameter table (rpart.mod$cp)
# Shows cp value, average error, cross-validation error (xerror), and standard deviation (xstd) at each split
# Optimal pruning: select cp where xerror is minimized within 1 standard error of minimum

rpart.mod$cp
plotcp(rpart.mod) # Save plot to: D:/Specimen analysis work/Decision Tree analysis/Decision Tree analysis result/rpart/result/1st/1st_1.pdf
rpart.mod.pru <- prune(rpart.mod, cp=0.002606572)
rpart.mod.pru$cp

# Plot tree
library(rpart.plot)
library(rattle)
library(tibble)
library(bitops)
rpart.plot(rpart.mod.pru, branch=1, extra = 102, under = TRUE, faclen = 0, cex = 0.7, main="CART")

# Variable importance
rpart.mod.pru$variable.importance

# Make predictions on test set
rpart.pred <- predict(rpart.mod.pru, test)
setwd("~")
write.csv(rpart.pred, file = "1st_1")

# Plot ROC curve
library(pROC)
test.pre <- predict(rpart.mod.pru, test)
plot(roc(test$y, test.pre[,2]), print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)
     
# Save ROC plot

# Merge predictions with original data
names(test.pre) = c("id","0","1")
library(dplyr)
result <- merge(traindata, test.pre, by="id")
setwd("D:/Specimen analysis work/Decision Tree analysis/Decision Tree analysis result/rpart/roc/1st")
write.csv(result, "1st_test_output_1")

# Combine ROC curves from multiple runs and filter models
all <- read.csv(file.choose())
selected <- read.csv(file.choose())
names(selected) = c("id", "pred_0_prob", "pred_1_prob")
result <- merge(all, selected, by="id")

# ROC analysis
library(pROC)
result$y = as.factor(result$results)
plot(roc(result$y, result[,9]), print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)

# Multiple ROC curve plotting
dfroc1 <- roc(result$pred_0_prob, result$pred_1_prob)
dfroc2 <- roc(result$y, result[,9])
dfroc3 <- roc(result$y, result[,9])

plot(dfroc1, col="red", grid=c(0.2,0.2), grid.col=c("blue","yellow"))
plot(dfroc2, add=TRUE, col="green")
plot(dfroc3, add=TRUE, col="pink")
legend("bottomright", legend=c("A","B","C"),
       col=c("red","green","pink"), lty=1)

# [Additional ROC curve plotting code for 100 iterations...]

# Confusion matrix
setwd("~")
a <- read.csv("1st_test_output_1")
names(a) = c("name", "id", "results", "pre_0", "pre_1")
a$y = as.factor(a$results) # Convert actual results to factor
a$pre = 0
a$pre[which(a$pre_1 > 0.280)] = 1 # Set threshold from ROC analysis
a$pre = as.factor(a$pre) # Convert predictions to factor
library(caret)
confusionMatrix(a$pre, a$y, positive='1') # Generate confusion matrix
```
