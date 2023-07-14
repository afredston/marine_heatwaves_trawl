#!/bin/csh -f
ncrcat -d TIME,1095,3284 survey/all_no_detrend.nc survey/all_1985_1990_wo_leap.nc 
cdo -O ymonmean survey/all_1985_1990_wo_leap.nc  survey/all_1985_1990_wo_leap_seasonal_cycle.nc
cdo -O addc,1 survey/all_1985_1990_wo_leap_seasonal_cycle.nc  survey/all_1985_1990_wo_leap_seasonal_cycle_plus1.nc
cdo yearmax survey/all_1985_1990_wo_leap_seasonal_cycle_plus1.nc  survey/all_1985_1990_wo_leap_seasonal_cycle_plus1_maximum.nc 
cdo -O gt  survey/all_no_detrend.nc survey/all_1985_1990_wo_leap_seasonal_cycle_plus1_maximum.nc  survey/all_no_detrend_dhd_1985_1990_baseline_bin.nc
cdo -O ifthen survey/all_no_detrend_dhd_1985_1990_baseline_bin.nc   -sub survey/all_no_detrend.nc  survey/all_1985_1990_wo_leap_seasonal_cycle_plus1_maximum.nc  survey/all_no_detrend_dhd_1985_1990_baseline.nc 
exit

