#!/bin/csh -f

cat >! make_ascii_surface.jnl <<EOF
set mem/size =2048
set region/x=0E:360E
CANCEL MODE LOGO
use "all_1993_2020_wo_leap_detrend_dhd.nc"

list/clobber/file="all_1993_2020_wo_leap_detrend_dhd.txt"/nohead/precision=10 baltic_sea,british_columbia,eastern_bering_sea,evhoe,fr_cgfs,gulf_of_alaska,gulf_of_mexico,gsl_s,ie_igfs,neus,nigfs,nor_bts,ns_ibts,pt_ibts,scotian_shelf,southeast,swc_ibts,west_coast


exit
EOF

ferret -unmapped  <<EOF
    go make_ascii_surface.jnl 
    exit
EOF

exit

