#! /bin/csh -f
cdo -O gt survey/all_bottom_detrend.nc survey/all_bottom_detrend.95P.nc survey/all_bottom_detrend.GT.95P.nc 
cdo -O -sub survey/all_bottom_detrend.nc survey/all_bottom_detrend.95P.nc survey/all_bottom_detrend.95P_tmp.nc 
cdo -O ifthen survey/all_bottom_detrend.GT.95P.nc survey/all_bottom_detrend.95P_tmp.nc  survey/all_bottom.GT.95P.EXC_ANOM_detrend.nc 
exit
