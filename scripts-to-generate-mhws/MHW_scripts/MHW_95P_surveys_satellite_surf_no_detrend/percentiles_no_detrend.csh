#!/bin/csh -f

cdo -O timmin survey/all.nc survey/all.MIN.nc
cdo -O timmax survey/all.nc survey/all.MAX.nc
cdo -O timpctl,95 survey/all.nc survey/all.MIN.nc survey/all.MAX.nc  survey/all.95P.nc

exit
