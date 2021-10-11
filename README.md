# Signature of marine heatwaves in trawl surveys 

## A project of the FISHGLOB working group 

## What's in this repository, and in what order should things be run?

1. `prep_survey_extent_nc.R` generates a netcdf file with the spatial footprints of trawl surveys used in the analysis, for merging with marine heatwave data. It also generates a .csv file with a "key" to translate the integer survey ID codes in the netcdf to their real names. This does not need to be re-run, but all the scripts below this should be re-run in order if anything is updated.
1. `prep_trawl_data.Rmd` takes the trawl records from North America (`namer`) and Europe (`eur`), processes them into a standardized format with columns for region, year, species, and CPUE in kg, and writes them out as .csv files in the `processed-data` folder. 
1. `MHW_stats_and_figures.R` analyzes the data and makes figures. 

## Notes

* Large files are not on GitHub. The code should contain instructions for how to download files that are missing from the version controlled repository. 
* The code makes extensive use of "the tidyverse" and associated packages like `here`. If you aren't familiar with them, just let me (Alexa) know and I can provide base-R translations. 