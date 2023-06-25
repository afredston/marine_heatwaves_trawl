# Marine heatwaves are not a dominant driver of change in demersal fishes

*Alexa L. Fredston, William W. L. Cheung, Thomas L. Frölicher, Zoë J. Kitchel, Aurore A. Maureaud, James T. Thorson, Arnaud Auber, Bastien Mérigot, Juliano Palacios-Abrantes, Maria Lourdes D. Palomares, Laurène Pecuchet, Nancy Shackell, Malin L. Pinsky*

Please contact [A. Fredston](https://www.alexafredston.com/) with questions about this project. Please cite the manuscript for all references to this project and its results, as well as the OSF DOI if data or code are reused. The results are fully reproducible from the scripts and all data files are either in this GitHub repository or (if they are too large) hosted on [OSF](https://osf.io/) (as described below). 

## Where do the raw data come from?

We used of a number of datasets that are already publicly available and/or published with this project. These are fully described and cited in the manuscript, but we also list them here for ease of download, access, and attribution. 

* Trawl data from [FISHGLOB](https://github.com/AquaAuma/FishGlob_data), a project to harmonize publicly available trawl survey records from federal agencies around the globe. The raw data files from FISHGLOB are too big to host on GitHub but they are available on [OSF](https://osf.io/). 
* Sea bottom temperature data from [GLORYS](https://www.mercator-ocean.eu/en/ocean-science/glorys/), an ocean reanalysis data product by the European Copernicus Marine Environment Modeling Service available beginning in 1993. The GLORYS12 sea bottom temperature data were downloaded from https://data.marine.copernicus.eu/product/GLOBAL_MULTIYEAR_PHY_001_030/description (accessed November 2, 2022). 
* Sea surface temperature data from [OISST](https://www.ncei.noaa.gov/products/optimum-interpolation-sst), a historical satellite temperature record from the U.S. National Oceanic and Atmospheric Administration beginning in 1982. The NOAA OISST data were downloaded from https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/ (accessed June 17, 2020). 
* Historical fishing pressure estimates from [Sea Around Us](https://www.seaaroundus.org/).
* Species-specific realized thermal niche estimates from [Burrows et al. 2018](https://figshare.com/articles/dataset/Species_Temperature_Index_and_thermal_range_information_forNorth_Pacific_and_North_Atlantic_plankton_and_bottom_trawl_species/6855203/1).
* Species traits from [Beukhof et al. 2019](https://doi.org/10.5061/dryad.ttdz08kt8).

## What's in this repository?

The repository is organized as follows:

* `scripts-to-generate-mhws` includes the `.csh` scripts used to process OISST and GLORYS data into the files found in `raw-data`. 
* `raw-data` contains raw datasets obtained from other sources (described above).
* `processed-data` contains outputs of scripts that filter, clean, summarize, or analyze data.
* `figures` contains image files generated by scripts for the main text figures.
* `extended` contains image files generated by scripts for the extended data figures. 

## What's not in the repository? 

The following files are too big to host on GitHub and are available on [OSF](https://osf.io/) only:

- The raw FISHGLOB data (a slightly earlier version of the dataset described in [Maureaud et al. 2023](https://doi.org/10.31219/osf.io/2bcjw)), `FISHGLOB_public_v1.5_clean(1).csv`. This should be downloaded from [OSF](https://osf.io/) and moved to `raw-data` to reproduce analyses.
- The outputs of power analyses: `pwrout_yrs_glorys.rds`, `pwrout_yrs_oisst.rds`, `pwrout_gamma_glorys.rds`, and `pwrout_gamma_oisst.rds`. These should be downloaded from [OSF](https://osf.io/) and moved to `processed-data` to reproduce analyses.

## In what order should things be run?

To reproduce the analysis, run these scripts in order:

1. `prep_survey_extent_nc.R` generates a netcdf file with the spatial footprints of trawl surveys used in the analysis, for merging with marine heatwave data. It also generates a .csv file with a "key" to translate the integer survey ID codes in the netcdf to their real names. This does not need to be re-run, but all the scripts below this should be re-run in order if the spatial footprints are updated.
1. `prep_trawl_data.R` takes the public trawl data records from version 1.5 of [FISHGLOB](https://github.com/AquaAuma/FishGlob_data) (see above note about downloading the data file from [OSF](https://osf.io/)), processes them into a standardized format with columns for survey, year, species, and CPUE in kg, and writes them out as .csv files in the `processed-data` folder. This was run on a computing server (see Notes below). If you skip this step, the rest of the code will still run, using processed data files hosted on GitHub. 
1. `prep_MHWs.R` merges those trawl records with the appropriate MHW and CTI data.
1. `temporal_beta_diversity.R` calculates interannual changes in richness and beta diversity (both total dissimilarity and individual components of nestedness and turnover for occurrence metrics and biomass gradient and balanced variation for biomass metrics).
1. `power_analysis.R` conducts a power analysis. This was run on a computing server (see Notes below) and if you download the output files from [OSF](https://osf.io/) (see above) you can skip this step.
1. `MHW_stats_and_figures_main_text.R` analyzes the data and makes figures and statistics for the main text. 
1. `MHW_stats_and_figures_supplement.Rmd` generates the SI tables as a PDF and writes out all the extended data figures. 

## Notes

* Software versions used in this analysis are captured by `renv` and listed [in the lockfile](https://github.com/afredston/marine_heatwaves_trawl/blob/main/renv.lock). Here is [a summary of how renv works](https://rstudio.github.io/renv/articles/renv.html). 
* Most of these analyses were run on a personal computer, and should be easy to reproduce, except `prep_trawl_data.R` and `power_analysis.R`, which were conducted in R 3.6.0 on a machine with the following specifications: Windows Server 2019 2-Intel 6154 Xeon 3.0Ghz 18cores(36 threads) each 512 GB memory 6TB- SSD storage 18TB- HDD storage NVIDIA P4000 8Gb 10Gb ethernet
