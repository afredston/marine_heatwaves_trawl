#! /bin/csh -f
cdo -O gt survey/all_bottom_detrend.nc survey/all_bottom.95P_detrend.nc survey/all_bottom.GT.95P_detrend.nc 
cdo -O -sub survey/all_bottom_detrened.nc survey/all_bottom.95P_detrend.nc survey/all_bottom.95P_tmp_detrend.nc 
cdo -O ifthen survey/all_bottom.GT.95P_detrend.nc survey/all_bottom.95P_tmp_detrend.nc  survey/all_bottom.GT.95P.EXC_ANOM_detrend.nc 
exit
