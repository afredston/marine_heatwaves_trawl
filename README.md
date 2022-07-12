# Marine heatwaves have not emerged as a dominant driver of ecological change

Alexa L. Fredston, William W. L. Cheung, Thomas L. Frölicher, Zoë Kitchel, Aurore A. Maureaud, James T. Thorson, Arnaud Auber, Bastien Mérigot, Juliano Palacios-Abrantes, Maria Lourdes D. Palomares, Laurène Pecuchet, Nancy Shackell, Malin Pinsky

Please contact A. Fredston with questions about this project. A DOI will be associated with this repository when it is published. Please cite it if data and code are reused (cite the manuscript for our results). 

## What's in this repository, and in what order should things be run?

The repository is organized as follows:

* `raw-data` contains raw datasets obtained from other sources that have not been changed in any way. Where possible, data are downloaded within scripts, so future users do not need to have data files. Where that was not possible, scripts using the data files contain instructions to download them. 
* `scripts` contains all code to analyze or transform data. 
* `processed-data` contains outputs of scripts that filter, clean, summarize, or analyze data, e.g., a dataframe with the higher taxonomy of species used in the final analysis. 
* `functions` contains homemade functions called in `scripts`.
* `figure-scripts` contains **code** to produce figures in the manuscript (the outputs are in `results`).
* `results` contains figures, tables, and other outputs that are used in the manuscript. 
To reproduce the analysis, run these scripts in order:

1. `prep_survey_extent_nc.R` generates a netcdf file with the spatial footprints of trawl surveys used in the analysis, for merging with marine heatwave data. It also generates a .csv file with a "key" to translate the integer survey ID codes in the netcdf to their real names. This does not need to be re-run, but all the scripts below this should be re-run in order if anything is updated.
1. `prep_trawl_data.R` takes the public trawl data records from (FISHGLOB)[https://github.com/AquaAuma/fishglob], processes them into a standardized format, and writes them out as .csv files in the `processed-data` folder. This was run on a computing server (see Notes below).
1. `prep_MHWs.R` merges those trawl records with the appropriate MHW and CTI data and writes out the joined dataframes as .csv files in the `processed-data` folder.
1. `temporal_beta_diversity.R` pulls in `biomass_time.csv` and calculates inner annual changes in richness and beta diversity (calculated as the turnover component of bray-curtis dissimilarity) and writes out the populated dataframe as `survey_temporal_beta_diversity.csv` in the `processed-data` folder.
1. `temporal_beta_diversity_with_MHWs.R` is where we are currently exploring possible figures to share information on alpha and beta diversity calculations between heat wave and non-heat wave years. This script will likely be archived once we decide which final figures will be included. 
1. `MHW_stats_and_figures_main_text.R` analyzes the data and makes figures and statistics for the main text. 
1. `MHW_stats_and_figures_supplement.Rmd` generates the entire supplement as a PDF. 
1. `power_analysis.R` conducts the power analysis. This was run on a computing server (see Notes below).

## Notes

* Large files are not on GitHub. The code contains instructions for how to download files that are missing from the version controlled repository. When published, these datasets will be available publicly at another link. 
* The `raw-data` folder is not version controlled due to its size. It contains all of the data products that were used in this project. They are not technically raw data (as some pre-processing happened before they were pulled into this project), but not processed in this repository. 
* The code makes extensive use of "the tidyverse" and associated packages like `here`. If you aren't familiar with them, just let me (Alexa) know and I can provide base-R translations. 
* Software versions used in this analysis are captured by `renv` and listed [in the lockfile](https://github.com/afredston/marine_heatwaves_trawl/blob/main/renv.lock). Here is [a summary of how renv works](https://rstudio.github.io/renv/articles/renv.html). 
* Most of these analyses were run on a personal computer, and should be easy to reproduce, except `prep_trawl_data.R` and `power_analysis.R`, which were conducted in R 3.6.0 on a machine with the following specifications: Windows Server 2019 2-Intel 6154 Xeon 3.0Ghz 18cores(36 threads) each 512 GB memory 6TB- SSD storage 18TB- HDD storage NVIDIA P4000 8Gb 10Gb ethernet