#!/bin/csh -f
cdo -O delete,month=2,day=29 bottomT_1993_2021.nc  bottomT_1993_2021_wo_leap.nc 
cdo -O ydaymean bottomT_1993_2021_wo_leap.nc bottomT_1993_2021_wo_leap_seasonal_cycle.nc  
cdo -O cat bottomT_1993_2021_wo_leap_seasonal_cycle.nc bottomT_1993_2021_wo_leap_seasonal_cycle.nc bottomT_1993_2021_wo_leap_seasonal_cycle.nc bottomT_1993_2021_wo_leap_3seasonal_cycle.nc
cdo -O runmean,30 bottomT_1993_2021_wo_leap_3seasonal_cycle.nc bottomT_1993_2021_wo_leap_3seasonal_cycle_runmean.nc
ncrcat -O -d time,350,714 bottomT_1993_2021_wo_leap_3seasonal_cycle_runmean.nc bottomT_1993_2021_wo_leap_3seasonal_cycle_smoothed.nc
cdo -b F32 -O sub bottomT_1993_2021_wo_leap.nc  bottomT_1993_2021_wo_leap_3seasonal_cycle_smoothed.nc bottomT_1993_2021_wo_leap_des.nc

exit

