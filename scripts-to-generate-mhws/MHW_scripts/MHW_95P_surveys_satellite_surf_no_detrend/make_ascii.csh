#!/bin/csh -f
cat >! make_ascii.jnl <<EOF
set mem/size =2048
set region/x=0E:360E
CANCEL MODE LOGO
use "all_bottom.GT.95P.EXC_ANOM.nc"

list/clobber/file="MHW_95P_surveys_glorys_surf_no_detrend.txt"/nohead/precision=10 baltic_sea,british_columbia,eastern_bering_sea,evhoe,fr_cgfs,gulf_of_alaska,gulf_of_mexico,gsl_s,ie_igfs,neus,nigfs,nor_bts,ns_ibts,pt_ibts,scotian_shelf,southeast,swc_ibts,west_coast


exit
EOF

ferret -unmapped  <<EOF
    go make_ascii.jnl 
    exit
EOF

exit

