#!/bin/csh -f

cdo -O timmin survey/all_bottom.nc survey/all.MIN.nc
cdo -O timmax survey/all_bottom.nc survey/all.MAX.nc
cdo -O timpctl,95 survey/all_bottom.nc survey/all.MIN.nc survey/all.MAX.nc  survey/all_bottom.95P.nc

exit
