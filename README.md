# Marine heatwave effects on temperate fish biomass

### A project of the FISHGLOB working group that harmonized trawl surveys from around the world 

## What's in this repository, and in what order should things be run?

1. `prep_survey_extent_nc.R` generates a netcdf file with the spatial footprints of trawl surveys used in the analysis, for merging with marine heatwave data. It also generates a .csv file with a "key" to translate the integer survey ID codes in the netcdf to their real names. This does not need to be re-run, but all the scripts below this should be re-run in order if anything is updated.
1. `prep_trawl_data.Rmd` takes the public trawl data records from (FISHGLOB)[https://github.com/AquaAuma/fishglob], processes them into a standardized format with columns for survey, year, species, and CPUE in kg, and writes them out as .csv files in the `processed-data` folder. 
1. `prep_MHWs.R` merges those trawl records with the appropriate MHW and CTI data and writes out the joined dataframes as .csv files in the `processed-data` folder.
1. `temporal_beta_diversity.R` pulls in `biomass_time.csv` and calculates inner annual changes in richness and beta diversity (calculated as the turnover component of bray-curtis dissimilarity) and writes out the populated dataframe as `survey_temporal_beta_diversity.csv` in the `processed-data` folder.
1. `temporal_beta_diversity_with_MHWs.R` is where we are currently exploring possible figures to share information on alpha and beta diversity calculations between heat wave and non-heat wave years. This script will likely be archived once we decide which final figures will be included. 
1. `MHW_stats_and_figures_main_text.R` analyzes the data and makes figures. 
1. `MHW_stats_and_figures_supplement.Rmd` generates the entire supplement as a PDF. 

## Notes

* Large files are not on GitHub. The code should contain instructions for how to download files that are missing from the version controlled repository. 
* The `raw-data` folder is not version controlled due to its size. It contains all of the data products that were handed to A. Fredston for this project (so they are not technically raw data, but not processed in this repository). 
* The code makes extensive use of "the tidyverse" and associated packages like `here`. If you aren't familiar with them, just let me (Alexa) know and I can provide base-R translations. 