#!/bin/csh -f
cdo -O ymonmean survey/all_1993_2020_wo_leap_detrend.nc  survey/all_1993_2020_wo_leap_detrend_seasonal_cycle.nc
cdo -O addc,1 survey/all_1993_2020_wo_leap_detrend_seasonal_cycle.nc  survey/all_1993_2020_wo_leap_detrend_seasonal_cycle_plus1.nc
cdo yearmax survey/all_1993_2020_wo_leap_detrend_seasonal_cycle_plus1.nc  survey/all_1993_2020_wo_leap_detrend_seasonal_cycle_plus1_maximum.nc 
cdo -O gt  survey/all_1993_2020_wo_leap_detrend.nc survey/all_1993_2020_wo_leap_detrend_seasonal_cycle_plus1_maximum.nc  survey/all_1993_2020_wo_leap_detrend_dhd_bin.nc
cdo -O ifthen survey/all_1993_2020_wo_leap_detrend_dhd_bin.nc   -sub survey/all_1993_2020_wo_leap_detrend.nc  survey/all_1993_2020_wo_leap_detrend_seasonal_cycle_plus1_maximum.nc  survey/all_1993_2020_wo_leap_detrend_dhd.nc 

exit

