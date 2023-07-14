#!/bin/csh -f

cat >! carbon_flux_plot.jnl <<EOF
set mem/size =2048
set region/x=0E:360E
CANCEL MODE LOGO
use "oisst-avhrr-v02r01.1982-2019_wo_leap_des.nc"
use "survey_extent.nc"

sh da

define grid/like=sst[d=1] new_grid
let/d=2 survey_regrid = survey[gxy=new_grid]

let baltic_sea_1 = if survey_regrid[L=1,d=2] eq 1 then sst[d=1]
let baltic_sea = baltic_sea_1[I=@ave,J=@ave]

let british_columbia_1 = if survey_regrid[L=1,d=2] eq 2 then sst[d=1]
let british_columbia = british_columbia_1[I=@ave,J=@ave]  

let eastern_bering_sea_1 = if survey_regrid[L=1,d=2] eq 3 then sst[d=1]
let eastern_bering_sea = eastern_bering_sea_1[I=@ave,J=@ave]  

let evhoe_1 = if survey_regrid[L=1,d=2] eq 4 then sst[d=1] 
let evhoe = evhoe_1[I=@ave,J=@ave]

let fr_cgfs_1 = if survey_regrid[L=1,d=2] eq 5 then sst[d=1] 
let fr_cgfs = fr_cgfs_1[I=@ave,J=@ave]

let gulf_of_alaska_1 = if survey_regrid[L=1,d=2] eq 7 then sst[d=1] 
let gulf_of_alaska = gulf_of_alaska_1[I=@ave,J=@ave] 

let gulf_of_mexico_1 = if survey_regrid[L=1,d=2] eq 6 then sst[d=1]  
let gulf_of_mexico = gulf_of_mexico_1[I=@ave,J=@ave]

let gsl_s_1 = if survey_regrid[L=1,d=2] eq 8 then sst[d=1]  
let gsl_s = gsl_s_1[I=@ave,J=@ave] 

let ie_igfs_1 = if survey_regrid[L=1,d=2] eq 9 then sst[d=1]   
let ie_igfs = ie_igfs_1[I=@ave,J=@ave] 

let neus_1 = if survey_regrid[L=1,d=2] eq 10 then sst[d=1]  
let neus = neus_1[I=@ave,J=@ave]

let nigfs_1 = if survey_regrid[L=1,d=2] eq 11 then sst[d=1] 
let nigfs = nigfs_1[I=@ave,J=@ave] 

let nor_bts_1 = if survey_regrid[L=1,d=2] eq 12 then sst[d=1]  
let nor_bts = nor_bts_1[I=@ave,J=@ave] 

let ns_ibts_1 = if survey_regrid[L=1,d=2] eq 13 then sst[d=1]  
let ns_ibts = ns_ibts_1[I=@ave,J=@ave] 

let pt_ibts_1 = if survey_regrid[L=1,d=2] eq 14 then sst[d=1]  
let pt_ibts = pt_ibts_1[I=@ave,J=@ave]   

let scotian_shelf_1 = if survey_regrid[L=1,d=2] eq 15 then sst[d=1]      
let scotian_shelf = scotian_shelf_1[I=@ave,J=@ave]

let southeast_1 = if survey_regrid[L=1,d=2] eq 16 then sst[d=1] 
let southeast = southeast_1[I=@ave,J=@ave] 

let swc_ibts_1 = if survey_regrid[L=1,d=2] eq 17 then sst[d=1]
let swc_ibts = swc_ibts_1[I=@ave,J=@ave]

let west_coast_1 = if survey_regrid[L=1,d=2] eq 18 then sst[d=1]  
let west_coast = west_coast_1[I=@ave,J=@ave]


spawn rm survey/all.nc
repeat/L=1:13870 (save/file="survey/all.nc"/append  baltic_sea,british_columbia,eastern_bering_sea,evhoe,fr_cgfs,gulf_of_mexico,gulf_of_alaska,gsl_s,ie_igfs,neus,nigfs,nor_bts,ns_ibts,pt_ibts,scotian_shelf,southeast,swc_ibts,west_coast)

exit
EOF

ferret -unmapped  <<EOF
    go carbon_flux_plot.jnl 
    exit
EOF
rm carbon_flux_plot.jnl
rm ferret.jnl*
rm metafile*
rm tmp*.nc


exit

