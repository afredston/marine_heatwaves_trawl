#!/bin/csh 
cdo -O delete,month=2,day=29 oisst-avhrr-v02r01.1982-2019.nc oisst-avhrr-v02r01.1982-2019_wo_leap.nc
cdo -O ydaymean oisst-avhrr-v02r01.1982-2019_wo_leap.nc oisst-avhrr-v02r01.1982-2019_wo_leap_seasonal_cycle.nc
cdo -O cat oisst-avhrr-v02r01.1982-2019_wo_leap_seasonal_cycle.nc oisst-avhrr-v02r01.1982-2019_wo_leap_seasonal_cycle.nc oisst-avhrr-v02r01.1982-2019_wo_leap_seasonal_cycle.nc oisst-avhrr-v02r01.1982-2019_wo_leap_3seasonal_cycle.nc
cdo -O runmean,30 oisst-avhrr-v02r01.1982-2019_wo_leap_3seasonal_cycle.nc oisst-avhrr-v02r01.1982-2019_wo_leap_3seasonal_cycle_runmean.nc
ncrcat -O -d time,350,714 oisst-avhrr-v02r01.1982-2019_wo_leap_3seasonal_cycle_runmean.nc oisst-avhrr-v02r01.1982-2019_wo_leap_seasonal_cycle_smoothed.nc 
cdo -O sub oisst-avhrr-v02r01.1982-2019_wo_leap.nc  oisst-avhrr-v02r01.1982-2019_wo_leap_seasonal_cycle_smoothed.nc oisst-avhrr-v02r01.1982-2019_wo_leap_des.nc


exit

