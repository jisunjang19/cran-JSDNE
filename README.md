
# JSDNE

<!-- badges: start -->
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.12708779.svg)](https://doi.org/10.5281/zenodo.12708779)
<!-- badges: end -->

## Contents

📂 [vignettes](/vignettes) has vignettes of the package\

📂 [man](/man) contains the description and example of the code and data\
  ⊢ 📄 [Apex.Rd](/man/Apex.Rd)\
  ⊢ 📄 [WholeSurface.Rd](/man/WholeSurface.Rd)\
  ⊢ 📄 [RawData.Rd](/man/RawData.Rd)\
  ⊢ 📄 [PCLR_Test.Rd](/man/PCLR_Test.Rd)\
  ⊢ 📄 [PCLR_Train.Rd](/man/PCLR_Train.Rd)\
  ⊢ 📄 [PCLR_result.Rd](/man/PCLR_result.Rd)\
  ⊢ 📄 [PCR_Test.Rd](/man/PCR_Test.Rd)\
  ⊢ 📄 [PCR_Train.Rd](/man/PCR_Train.Rd)\
  ⊢ 📄 [PCR_result.Rd](/man/PCR_result.Rd)\
  ⊢ 📄 [PCQDA_Test.Rd](/man/PCQDA_Test.Rd)\
  ⊢ 📄 [PCQDA_Train.Rd](/man/PCQDA_Train.Rd)\
  ⊢ 📄 [PCQDA_result.Rd](/man/PCQDA_result.Rd)\

📂 [data](/data) contains the raw data to develop the models and obtain the findings in the manuscript, and example 3D models\
  ⊢ 📄 [Apex.rda](/data/Apex.rda) is the loaded example data of apex\
  ⊢ 📄 [WholeSurface.rda](/data/WholeSurface.rda)is loaded example data of Whole surface\
  ⊢ 📄 [RawData.rda](/data/RawData.rda)\
  ⊢ 📄 [PCLR_Test.rda](/data/PCLR_Test.rda)\
  ⊢ 📄 [PCLR_Train.rda](/data/PCLR_Train.rda)\
  ⊢ 📄 [PCR_Test.rda](/data/PCR_Test.rda)\ 
  ⊢ 📄 [PCR_Train.rda](/data/PCR_Train.rda)\
  ⊢ 📄 [PCQDA_Test.rda](/data/PCQDA_Test.rda)\
  ⊢ 📄 [PCQDA_Train.rda](/data/PCQDA_Train.rda)\
  ⊢ 📄 [PCQDA_Test.rda](/data/PCQDA_Test.rda)\
  ⊢ 📄 [PCLR_Train.rda](/data/PCLR_Train.rda)\


📂 [R](/R) contains code for developing the age estimation models, the example 3D models, and raw data to develop the estimation models\
  ⊢ 📄 [Apex.R](/R/Apex.R)\
  ⊢ 📄 [WholeSurface.R](/R/WholeSurface.R)\
  ⊢ 📄 [PCLR_Test.R](/R/PCLR_Test.R)\
  ⊢ 📄 [PCLR_Train.R](/R/PCLR_Train.R)\
  ⊢ 📄 [PCR_Test.R](/R/PCR_Test.R)\ 
  ⊢ 📄 [PCR_Train.R](/R/PCR_Train.R)\ 
  ⊢ 📄 [PCQDA_Test.R](/R/PCQDA_Test.R)\ 
  ⊢ 📄 [PCQDA_Train.R](/R/PCQDA_Train.R)\ 
  ⊢ 📄 [PCQDA_Test.R](/R/PCQDA_Test.R)\
  ⊢ 📄 [PCLR_Train.R](/R/PCLR_Train.R)\
  ⊢ 📄 [PCLR_result.R](/R/PCLR_result.R) is the PCLR model for age estimation\
  ⊢ 📄 [PCR_result.R](/R/PCR_result.R) is the PCR model for age estimation
  ⊢ 📄 [PCQDA_result.R](/R/PCQDA_result.R) is the PCQDA model for age estimation\

## Abstract

The goal of JSDNE is to estimate the age with the auricular surface. Widely-used traditional age estimation methods involving macroscopic observation suffer from subjectivity. The present package aims to minimize both issues by applying computational and mathematical approaches. Dirichlet Normal Energy (DNE) was applied to assess the curvature of the 3D reconstructed auricular surface models. Ten DNE variables had high correlations, including total DNE per Total polygon faces, Mean value of DNE on apex, proportion of polygon faces with DNE of less than 0.0001 and proportion of polygon faces with DNE of over 0.6. JSDNE includes three functions: principal component quadratic discriminant analysis (PCQDA), principal component regression analysis (PCR), and principal component logistic regression analysis (PCLR), which were developed based on the DNE variables. JSDNE predicts age mathematically, objectively, and user-independently. The PCQDA function involves four age phases: phase 1(22-44yrs), phase 2(31-74yrs), phase 3(63-93yrs), and phase 4 (Over 76). The function provides an output of estimated age phase and the age range.The PCR function provides an output of estimated age in years and the standard error (8.8yrs).Finally, the PCLR function has two age phases: phase 1 (under 67), phase 2(over 63)). It offers an output of estimated age phase and the age range. 

## Data availability

The raw data obtained the findings of this study are openly available at https://github.com/jisunjang19/cran-JSDNE, doi: 10.5281/zenodo.12708779 or ‘JSDNE’ package

## Replicate analysis

The raw datas of this study (RawData, PCLR_Train, PCLR_Test, PCQDA_Test, PCQDA_Train, PCR_Train, and PCR_Test) could be loaded with JSDNE package. For example,

```r
library(JSDNE)
data(RawData)
```

All of the data preparation and anlysis in the source code_Manuscript could be re-runed. For example, 

```r
PCQDA_data <-
  subset(
    RawData,
    select = c(
      Cluster2,
      Age,
      MeanDNE.Apex,
      TotalDNE.TotalPolygonFaces,
      Proportion.DNEunder0.0001,
      Proportion.DNEover0.6
    )
  )
model_PCQDA <- subset(PCQDA_Train, select = -c(Cluster2, Age))
PCQDA_df <- scale(model_PCQDA)
PCQDA_df.pca <- prcomp(PCQDA_df)
PCQDA_pca <- PCQDA_df.pca$x[, 1:2]
PCQDA_df2 <- data.frame(Cluster = PCQDA_Train$Cluster2, PCQDA_pca)
PCQDA <- MASS::qda(Cluster ~ ., data = PCQDA_df2)
```

## Installation of JSDNE package

You can install the development version of JSDNE like so: install.packages("JSDNE")

## Example of using JSDNE package

```r
library(JSDNE)
PCQDA_result(WholeSurface,Apex)
PCLR_result(WholeSurface,Apex)
PCR_result(WholeSurface,Apex)
```

1. When importing the .ply files, I highly recommend use the vcgPlyRead function. If use different function to import the ply files, the function might not be able to read correctly. 

2. After importing the .ply files with the vcgPlyRead function, the auricular surface .ply file should be replaced with x and the apical area with y. If oppositely applied, incorrect results will be calculated. It is recommended to check the location of both ply file.



