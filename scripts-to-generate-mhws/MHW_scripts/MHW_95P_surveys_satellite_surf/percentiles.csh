#!/bin/csh -f

cdo -O timmin survey/all_detrend.nc survey/all.MIN.nc
cdo -O timmax survey/all_detrend.nc survey/all.MAX.nc
cdo -O timpctl,95 survey/all_detrend.nc survey/all.MIN.nc survey/all.MAX.nc  survey/all.95P_detrend.nc

exit
