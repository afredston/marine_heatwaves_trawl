Analyzing MHW effects on fish abundance in trawl surveys
================
Alexa Fredston
3/23/2021

# North America

Note that as of 05-20-2021, I’ve updated the analysis such that every
survey is compared to MHW data from the 12 months preceding the earliest
start month of the survey. Different seasons in a region are pooled, so
e.g., the spring and fall NEUS surveys are compared to data from the 365
days before February 1 of each survey-year.

## Plots

### Net changes in biomass

Let’s plot several marine heatwave indices against several CPUE indices,
to see how similar patterns are across metrics. I’m also looking for
whether we see effects of major known MHW events: 2012 in the Northeast,
the 2014-2015 “warm blob” on the West Coast, and the 2014-2016 heatwave
and partially sea ice-free period in the Eastern Bering Sea. (The other
such event in the Eastern Bering Sea was 2001-2005, which also appears
to show up here.)

In addition to summing all CPUE (which will be driven by common species)
I’ve calculated proportional change first at the single-species level
and then averaged across all species in a region. This gives all species
equal weight while also standardizing and centering catch values. This
is shown below both as an absolute value (magnitude of change only) and
from averaging across true units of single-species values.

![MHW Metrics vs. Sum CPUE
Change](analyze_MHWs_files/figure-gfm/namer-mhw-cpue-metrics-1.png)

![Biomass Change vs
MHW-Years](analyze_MHWs_files/figure-gfm/namer-mhw-years-cpue-scatter-1.png)

![Biomass Change vs
MHW-Years](analyze_MHWs_files/figure-gfm/namer-mhw-years-cpue-hist-1.png)

### Species-level

![Species Proportional CPUE Anomaly vs. MHW
Intensity](analyze_MHWs_files/figure-gfm/namer-spp-anom-mhw-scatter-1.png)

![Species Proportional CPUE Year-Over-Year Change vs. MHW
Intensity](analyze_MHWs_files/figure-gfm/namer-spp-diff-mhw-scatter-1.png)

![Species Proportional CPUE Year-Over-Year Change in MHW and Non-MHW
Years](analyze_MHWs_files/figure-gfm/namer-spp-diff-mhwYesNo-boxplot-1.png)

## Models

### Region as random effect

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtDiffProp ~ anomIntC + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 194.8
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.7963 -0.5948 -0.1820  0.3820  6.0116 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr
    ##  region   (Intercept) 0.000e+00 0.000e+00     
    ##           anomIntC    4.158e-11 6.448e-06  NaN
    ##  Residual             1.580e-01 3.975e-01     
    ## Number of obs: 192, groups:  region, 8
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  0.06975    0.02868   2.432
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtAnomProp ~ anomIntC + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 139.7
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.9003 -0.6234 -0.1635  0.4072  4.0209 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr 
    ##  region   (Intercept) 3.250e-10 1.803e-05      
    ##           anomIntC    6.226e-09 7.891e-05 -1.00
    ##  Residual             1.163e-01 3.410e-01      
    ## Number of obs: 197, groups:  region, 8
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  0.00611    0.02429   0.252
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtDiffProp ~ mhwYesNo + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 194.8
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.7963 -0.5948 -0.1820  0.3820  6.0116 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr
    ##  region   (Intercept) 0.000e+00 0.000e+00     
    ##           mhwYesNoyes 1.141e-20 1.068e-10  NaN
    ##  Residual             1.580e-01 3.975e-01     
    ## Number of obs: 192, groups:  region, 8
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  0.06975    0.02868   2.432
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtAnomProp ~ mhwYesNo + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 139.7
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.9003 -0.6234 -0.1635  0.4072  4.0209 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr 
    ##  region   (Intercept) 6.150e-11 7.842e-06      
    ##           mhwYesNoyes 7.862e-11 8.867e-06 -1.00
    ##  Residual             1.163e-01 3.410e-01      
    ## Number of obs: 197, groups:  region, 8
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  0.00611    0.02429   0.252
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

### MHW yes/no

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ mhwYesNo, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.70427 -0.23161 -0.06323  0.16083  2.39913 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)  0.08590    0.04694   1.830   0.0688 .
    ## mhwYesNoyes -0.02584    0.05938  -0.435   0.6639  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3983 on 190 degrees of freedom
    ##   (5 observations deleted due to missingness)
    ## Multiple R-squared:  0.0009959,  Adjusted R-squared:  -0.004262 
    ## F-statistic: 0.1894 on 1 and 190 DF,  p-value: 0.6639

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ mhwYesNo, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.6760 -0.2309 -0.0440  0.1549  1.4186 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)
    ## (Intercept) -0.04152    0.03978  -1.044    0.298
    ## mhwYesNoyes  0.07567    0.05014   1.509    0.133
    ## 
    ## Residual standard error: 0.3398 on 195 degrees of freedom
    ## Multiple R-squared:  0.01155,    Adjusted R-squared:  0.006477 
    ## F-statistic: 2.278 on 1 and 195 DF,  p-value: 0.1329

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.64832 -0.22020 -0.05423  0.12334  1.38460 
    ## 
    ## Coefficients:
    ##                                      Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                          -0.17697    0.17530  -1.009    0.314
    ## mhwYesNoyes                           0.24775    0.20742   1.194    0.234
    ## regioneastern_bering_sea              0.13575    0.19127   0.710    0.479
    ## regiongulf_of_alaska                  0.17535    0.21976   0.798    0.426
    ## regiongulf_of_mexico                  0.14074    0.30364   0.464    0.644
    ## regionnortheast                       0.05408    0.21470   0.252    0.801
    ## regionscotian_shelf                   0.16589    0.20047   0.828    0.409
    ## regionsoutheast                       0.15097    0.22632   0.667    0.506
    ## regionwest_coast                      0.16942    0.20242   0.837    0.404
    ## mhwYesNoyes:regioneastern_bering_sea -0.13110    0.23890  -0.549    0.584
    ## mhwYesNoyes:regiongulf_of_alaska     -0.24452    0.27955  -0.875    0.383
    ## mhwYesNoyes:regiongulf_of_mexico     -0.11152    0.34620  -0.322    0.748
    ## mhwYesNoyes:regionnortheast          -0.10459    0.25056  -0.417    0.677
    ## mhwYesNoyes:regionscotian_shelf      -0.21359    0.24152  -0.884    0.378
    ## mhwYesNoyes:regionsoutheast          -0.21526    0.26198  -0.822    0.412
    ## mhwYesNoyes:regionwest_coast         -0.20612    0.25386  -0.812    0.418
    ## 
    ## Residual standard error: 0.3506 on 181 degrees of freedom
    ## Multiple R-squared:  0.0235, Adjusted R-squared:  -0.05743 
    ## F-statistic: 0.2904 on 15 and 181 DF,  p-value: 0.9958

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.83031 -0.22458 -0.06921  0.16219  2.36549 
    ## 
    ## Coefficients:
    ##                                       Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                           0.239499   0.235876   1.015    0.311
    ## mhwYesNoyes                          -0.117789   0.268940  -0.438    0.662
    ## regioneastern_bering_sea             -0.215028   0.252162  -0.853    0.395
    ## regiongulf_of_alaska                 -0.243031   0.281926  -0.862    0.390
    ## regiongulf_of_mexico                  0.078167   0.372952   0.210    0.834
    ## regionnortheast                      -0.169936   0.276589  -0.614    0.540
    ## regionscotian_shelf                  -0.163900   0.261681  -0.626    0.532
    ## regionsoutheast                      -0.202663   0.288888  -0.702    0.484
    ## regionwest_coast                     -0.024379   0.263717  -0.092    0.926
    ## mhwYesNoyes:regioneastern_bering_sea  0.129322   0.302331   0.428    0.669
    ## mhwYesNoyes:regiongulf_of_alaska      0.135648   0.352125   0.385    0.701
    ## mhwYesNoyes:regiongulf_of_mexico     -0.285648   0.423827  -0.674    0.501
    ## mhwYesNoyes:regionnortheast           0.103267   0.314887   0.328    0.743
    ## mhwYesNoyes:regionscotian_shelf       0.119988   0.305150   0.393    0.695
    ## mhwYesNoyes:regionsoutheast           0.161485   0.327726   0.493    0.623
    ## mhwYesNoyes:regionwest_coast         -0.003635   0.320826  -0.011    0.991
    ## 
    ## Residual standard error: 0.4085 on 176 degrees of freedom
    ##   (5 observations deleted due to missingness)
    ## Multiple R-squared:  0.02645,    Adjusted R-squared:  -0.05652 
    ## F-statistic: 0.3188 on 15 and 176 DF,  p-value: 0.993

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##   -22.5   -12.8    -4.7    -2.2 20602.9 
    ## 
    ## Coefficients:
    ##                                      Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                            6.3178    10.9895   0.575    0.565
    ## mhwYesNoyes                            0.9001    12.4403   0.072    0.942
    ## regioneastern_bering_sea              15.1725    11.6981   1.297    0.195
    ## regiongulf_of_alaska                  -1.9772    12.4988  -0.158    0.874
    ## regiongulf_of_mexico                  -4.5361    14.1895  -0.320    0.749
    ## regionnortheast                       -4.2561    13.8377  -0.308    0.758
    ## regionscotian_shelf                   -5.5657    15.1367  -0.368    0.713
    ## regionsoutheast                       -4.9806    13.9939  -0.356    0.722
    ## regionwest_coast                       7.1538    12.1258   0.590    0.555
    ## mhwYesNoyes:regioneastern_bering_sea  -8.7221    13.8928  -0.628    0.530
    ## mhwYesNoyes:regiongulf_of_alaska       1.3787    15.1942   0.091    0.928
    ## mhwYesNoyes:regiongulf_of_mexico       5.9398    16.0820   0.369    0.712
    ## mhwYesNoyes:regionnortheast            0.2012    15.6778   0.013    0.990
    ## mhwYesNoyes:regionscotian_shelf       -0.1979    18.1879  -0.011    0.991
    ## mhwYesNoyes:regionsoutheast           -0.1402    15.7881  -0.009    0.993
    ## mhwYesNoyes:regionwest_coast         -10.8202    14.5734  -0.742    0.458
    ## 
    ## Residual standard error: 231.8 on 25524 degrees of freedom
    ## Multiple R-squared:  0.0008083,  Adjusted R-squared:  0.0002211 
    ## F-statistic: 1.376 on 15 and 25524 DF,  p-value: 0.1486

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.0917 -0.7308 -0.2928  0.2872 30.1611 
    ## 
    ## Coefficients:
    ##                                       Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)                          -0.058904   0.048017  -1.227  0.21994   
    ## mhwYesNoyes                           0.082465   0.056815   1.451  0.14666   
    ## regioneastern_bering_sea              0.051251   0.052465   0.977  0.32865   
    ## regiongulf_of_alaska                  0.056695   0.057174   0.992  0.32139   
    ## regiongulf_of_mexico                  0.150633   0.068356   2.204  0.02756 * 
    ## regionnortheast                      -0.182322   0.065974  -2.764  0.00572 **
    ## regionscotian_shelf                   0.002751   0.073965   0.037  0.97033   
    ## regionsoutheast                      -0.148123   0.066934  -2.213  0.02691 * 
    ## regionwest_coast                      0.100922   0.055023   1.834  0.06664 . 
    ## mhwYesNoyes:regioneastern_bering_sea -0.060024   0.065578  -0.915  0.36004   
    ## mhwYesNoyes:regiongulf_of_alaska     -0.078047   0.071794  -1.087  0.27700   
    ## mhwYesNoyes:regiongulf_of_mexico     -0.107915   0.078655  -1.372  0.17007   
    ## mhwYesNoyes:regionnortheast           0.214079   0.076583   2.795  0.00519 **
    ## mhwYesNoyes:regionscotian_shelf       0.018524   0.091392   0.203  0.83938   
    ## mhwYesNoyes:regionsoutheast           0.176405   0.077116   2.288  0.02217 * 
    ## mhwYesNoyes:regionwest_coast         -0.120280   0.069141  -1.740  0.08193 . 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.267 on 27967 degrees of freedom
    ## Multiple R-squared:  0.002639,   Adjusted R-squared:  0.002104 
    ## F-statistic: 4.933 on 15 and 27967 DF,  p-value: 8.884e-10

### Net change in biomass

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.7305 -0.2202 -0.0679  0.1471  2.4034 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)  0.11528    0.03812   3.024  0.00284 **
    ## anomIntC    -0.23634    0.13129  -1.800  0.07343 . 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3952 on 190 degrees of freedom
    ##   (5 observations deleted due to missingness)
    ## Multiple R-squared:  0.01677,    Adjusted R-squared:  0.01159 
    ## F-statistic:  3.24 on 1 and 190 DF,  p-value: 0.07343

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomIntC, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.69222 -0.21929 -0.05445  0.13917  1.38791 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)
    ## (Intercept) -0.01086    0.03254  -0.334    0.739
    ## anomIntC     0.08869    0.11306   0.785    0.434
    ## 
    ## Residual standard error: 0.3413 on 195 degrees of freedom
    ## Multiple R-squared:  0.003146,   Adjusted R-squared:  -0.001966 
    ## F-statistic: 0.6155 on 1 and 195 DF,  p-value: 0.4337

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.81442 -0.22484 -0.06427  0.14614  2.33375 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                        0.197467   0.199781   0.988    0.324
    ## anomIntC                          -0.211822   0.720143  -0.294    0.769
    ## regioneastern_bering_sea          -0.123005   0.214779  -0.573    0.568
    ## regiongulf_of_alaska              -0.142156   0.244101  -0.582    0.561
    ## regiongulf_of_mexico               0.012663   0.275950   0.046    0.963
    ## regionnortheast                   -0.132985   0.224512  -0.592    0.554
    ## regionscotian_shelf               -0.094382   0.220883  -0.427    0.670
    ## regionsoutheast                   -0.070092   0.227911  -0.308    0.759
    ## regionwest_coast                   0.001767   0.227450   0.008    0.994
    ## anomIntC:regioneastern_bering_sea -0.102619   0.773728  -0.133    0.895
    ## anomIntC:regiongulf_of_alaska     -0.168972   0.957535  -0.176    0.860
    ## anomIntC:regiongulf_of_mexico     -0.577602   0.884299  -0.653    0.514
    ## anomIntC:regionnortheast           0.183860   0.799159   0.230    0.818
    ## anomIntC:regionscotian_shelf       0.098408   0.771229   0.128    0.899
    ## anomIntC:regionsoutheast          -0.059461   0.817677  -0.073    0.942
    ## anomIntC:regionwest_coast         -0.081417   0.872244  -0.093    0.926
    ## 
    ## Residual standard error: 0.4054 on 176 degrees of freedom
    ##   (5 observations deleted due to missingness)
    ## Multiple R-squared:  0.04154,    Adjusted R-squared:  -0.04014 
    ## F-statistic: 0.5086 on 15 and 176 DF,  p-value: 0.9338

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.66371 -0.19832 -0.05402  0.15423  1.35874 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                       -0.21589    0.15279  -1.413   0.1594  
    ## anomIntC                           1.01385    0.57156   1.774   0.0778 .
    ## regioneastern_bering_sea           0.21356    0.16693   1.279   0.2024  
    ## regiongulf_of_alaska               0.21553    0.19137   1.126   0.2615  
    ## regiongulf_of_mexico               0.39768    0.21941   1.812   0.0716 .
    ## regionnortheast                    0.06111    0.17600   0.347   0.7288  
    ## regionscotian_shelf                0.24088    0.17263   1.395   0.1646  
    ## regionsoutheast                    0.24848    0.17863   1.391   0.1659  
    ## regionwest_coast                   0.23420    0.17842   1.313   0.1910  
    ## anomIntC:regioneastern_bering_sea -0.94620    0.62039  -1.525   0.1290  
    ## anomIntC:regiongulf_of_alaska     -1.01104    0.78345  -1.290   0.1985  
    ## anomIntC:regiongulf_of_mexico     -1.43464    0.71975  -1.993   0.0477 *
    ## anomIntC:regionnortheast          -0.36925    0.64340  -0.574   0.5667  
    ## anomIntC:regionscotian_shelf      -1.07881    0.61812  -1.745   0.0826 .
    ## anomIntC:regionsoutheast          -1.17279    0.66004  -1.777   0.0773 .
    ## anomIntC:regionwest_coast         -1.05715    0.70809  -1.493   0.1372  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3456 on 181 degrees of freedom
    ## Multiple R-squared:  0.051,  Adjusted R-squared:  -0.02765 
    ## F-statistic: 0.6484 on 15 and 181 DF,  p-value: 0.8315

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.73711 -0.20041 -0.05331  0.13460  1.36734 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                       -0.1255453  0.1230260  -1.020   0.3089  
    ## anomDays                           0.0079173  0.0052650   1.504   0.1344  
    ## regioneastern_bering_sea           0.1275979  0.1381275   0.924   0.3568  
    ## regiongulf_of_alaska               0.1590611  0.1613402   0.986   0.3255  
    ## regiongulf_of_mexico               0.3867858  0.1948885   1.985   0.0487 *
    ## regionnortheast                   -0.0067472  0.1423533  -0.047   0.9622  
    ## regionscotian_shelf                0.1339660  0.1410306   0.950   0.3434  
    ## regionsoutheast                    0.2315290  0.1464065   1.581   0.1155  
    ## regionwest_coast                   0.1352572  0.1457049   0.928   0.3545  
    ## anomDays:regioneastern_bering_sea -0.0075398  0.0056182  -1.342   0.1813  
    ## anomDays:regiongulf_of_alaska     -0.0096173  0.0058945  -1.632   0.1045  
    ## anomDays:regiongulf_of_mexico     -0.0181610  0.0078382  -2.317   0.0216 *
    ## anomDays:regionnortheast          -0.0009949  0.0058430  -0.170   0.8650  
    ## anomDays:regionscotian_shelf      -0.0078149  0.0057798  -1.352   0.1780  
    ## anomDays:regionsoutheast          -0.0158069  0.0064431  -2.453   0.0151 *
    ## anomDays:regionwest_coast         -0.0078029  0.0054595  -1.429   0.1547  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3381 on 181 degrees of freedom
    ## Multiple R-squared:  0.09194,    Adjusted R-squared:  0.01668 
    ## F-statistic: 1.222 on 15 and 181 DF,  p-value: 0.2589

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.81835 -0.20432 -0.05451  0.14403  2.27109 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                        0.2119580  0.1562203   1.357    0.177
    ## anomDays                          -0.0036931  0.0064424  -0.573    0.567
    ## regioneastern_bering_sea          -0.1369038  0.1729795  -0.791    0.430
    ## regiongulf_of_alaska              -0.1657378  0.2015945  -0.822    0.412
    ## regiongulf_of_mexico               0.0585408  0.2481973   0.236    0.814
    ## regionnortheast                   -0.1374692  0.1777076  -0.774    0.440
    ## regionscotian_shelf               -0.1940807  0.1762261  -1.101    0.272
    ## regionsoutheast                   -0.0947446  0.1829427  -0.518    0.605
    ## regionwest_coast                  -0.0087994  0.1822422  -0.048    0.962
    ## anomDays:regioneastern_bering_sea  0.0004553  0.0068471   0.066    0.947
    ## anomDays:regiongulf_of_alaska      0.0016176  0.0071652   0.226    0.822
    ## anomDays:regiongulf_of_mexico     -0.0097876  0.0095485  -1.025    0.307
    ## anomDays:regionnortheast           0.0027632  0.0071054   0.389    0.698
    ## anomDays:regionscotian_shelf       0.0074688  0.0070327   1.062    0.290
    ## anomDays:regionsoutheast           0.0003192  0.0077993   0.041    0.967
    ## anomDays:regionwest_coast          0.0018097  0.0066652   0.272    0.786
    ## 
    ## Residual standard error: 0.3999 on 176 degrees of freedom
    ##   (5 observations deleted due to missingness)
    ## Multiple R-squared:  0.06727,    Adjusted R-squared:  -0.01223 
    ## F-statistic: 0.8462 on 15 and 176 DF,  p-value: 0.6253

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.70432 -0.19681 -0.05551  0.13353  1.36676 
    ## 
    ## Coefficients:
    ##                                  Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                      -0.14412    0.12154  -1.186   0.2373  
    ## anomSev                           0.03207    0.01813   1.769   0.0786 .
    ## regioneastern_bering_sea          0.14935    0.13530   1.104   0.2711  
    ## regiongulf_of_alaska              0.17755    0.15675   1.133   0.2588  
    ## regiongulf_of_mexico              0.32109    0.17368   1.849   0.0661 .
    ## regionnortheast                   0.05405    0.13709   0.394   0.6938  
    ## regionscotian_shelf               0.16011    0.13952   1.148   0.2527  
    ## regionsoutheast                   0.21731    0.14026   1.549   0.1230  
    ## regionwest_coast                  0.15441    0.14313   1.079   0.2821  
    ## anomSev:regioneastern_bering_sea -0.03180    0.01828  -1.740   0.0836 .
    ## anomSev:regiongulf_of_alaska     -0.03679    0.01902  -1.934   0.0547 .
    ## anomSev:regiongulf_of_mexico     -0.04505    0.01977  -2.279   0.0238 *
    ## anomSev:regionnortheast          -0.02020    0.01866  -1.082   0.2805  
    ## anomSev:regionscotian_shelf      -0.03297    0.01896  -1.739   0.0838 .
    ## anomSev:regionsoutheast          -0.04635    0.01925  -2.407   0.0171 *
    ## anomSev:regionwest_coast         -0.03186    0.01833  -1.738   0.0839 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3375 on 181 degrees of freedom
    ## Multiple R-squared:  0.09539,    Adjusted R-squared:  0.02043 
    ## F-statistic: 1.272 on 15 and 181 DF,  p-value: 0.2235

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.80939 -0.21852 -0.06045  0.14707  2.27169 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                       0.206046   0.155208   1.328    0.186
    ## anomSev                          -0.011809   0.022308  -0.529    0.597
    ## regioneastern_bering_sea         -0.142545   0.170610  -0.836    0.405
    ## regiongulf_of_alaska             -0.149112   0.198074  -0.753    0.453
    ## regiongulf_of_mexico             -0.076952   0.221367  -0.348    0.729
    ## regionnortheast                  -0.134182   0.172630  -0.777    0.438
    ## regionscotian_shelf              -0.157474   0.175368  -0.898    0.370
    ## regionsoutheast                  -0.100171   0.176948  -0.566    0.572
    ## regionwest_coast                 -0.011840   0.180451  -0.066    0.948
    ## anomSev:regioneastern_bering_sea  0.007617   0.022485   0.339    0.735
    ## anomSev:regiongulf_of_alaska      0.004885   0.023351   0.209    0.835
    ## anomSev:regiongulf_of_mexico     -0.002487   0.024255  -0.103    0.918
    ## anomSev:regionnortheast           0.009754   0.022924   0.426    0.671
    ## anomSev:regionscotian_shelf       0.016114   0.023272   0.692    0.490
    ## anomSev:regionsoutheast           0.005247   0.023614   0.222    0.824
    ## anomSev:regionwest_coast          0.008475   0.022545   0.376    0.707
    ## 
    ## Residual standard error: 0.402 on 176 degrees of freedom
    ##   (5 observations deleted due to missingness)
    ## Multiple R-squared:  0.05726,    Adjusted R-squared:  -0.02309 
    ## F-statistic: 0.7126 on 15 and 176 DF,  p-value: 0.7697

### Species-level models using region\*year predictors

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC + anomIntC * ref_year, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##  -205.9    -5.3    -2.3    -0.9 20496.2 
    ## 
    ## Coefficients: (192 not defined because of singularities)
    ##                                             Estimate Std. Error t value
    ## (Intercept)                                  6.91820   16.37995   0.422
    ## anomIntC                                   -21.96600  139.74059  -0.157
    ## ref_yearaleutian_islands-5-1991             -0.66801   28.18486  -0.024
    ## ref_yearaleutian_islands-5-1994              9.49522   39.35433   0.241
    ## ref_yearaleutian_islands-5-1997              1.73048   31.58701   0.055
    ## ref_yearaleutian_islands-5-2000              4.23393   24.12690   0.175
    ## ref_yearaleutian_islands-5-2002             -1.54495   30.88047  -0.050
    ## ref_yearaleutian_islands-5-2004              0.53256   31.15859   0.017
    ## ref_yearaleutian_islands-5-2006             36.42088   38.38657   0.949
    ## ref_yearaleutian_islands-5-2010             -5.36648   24.08906  -0.223
    ## ref_yearaleutian_islands-5-2012              4.24069   53.61892   0.079
    ## ref_yearaleutian_islands-5-2014             11.19989   72.83442   0.154
    ## ref_yearaleutian_islands-5-2016              2.29002   40.58381   0.056
    ## ref_yearaleutian_islands-5-2018              1.94731   34.00417   0.057
    ## ref_yeareastern_bering_sea-5-1983            4.02825   26.41188   0.153
    ## ref_yeareastern_bering_sea-5-1984           55.65198   50.61799   1.099
    ## ref_yeareastern_bering_sea-5-1985           17.25163   56.91865   0.303
    ## ref_yeareastern_bering_sea-5-1986            3.34896   24.40289   0.137
    ## ref_yeareastern_bering_sea-5-1987           10.57126   23.30117   0.454
    ## ref_yeareastern_bering_sea-5-1988           15.16890   23.07080   0.657
    ## ref_yeareastern_bering_sea-5-1989           -5.24193   24.24275  -0.216
    ## ref_yeareastern_bering_sea-5-1990           31.28337   24.48552   1.278
    ## ref_yeareastern_bering_sea-5-1991           -5.18414   24.56993  -0.211
    ## ref_yeareastern_bering_sea-5-1992           -3.57090   24.83441  -0.144
    ## ref_yeareastern_bering_sea-5-1993           -5.42415   24.97340  -0.217
    ## ref_yeareastern_bering_sea-5-1994            1.07144   25.32435   0.042
    ## ref_yeareastern_bering_sea-5-1995           -6.34028   24.97340  -0.254
    ## ref_yeareastern_bering_sea-5-1996           -4.35354   24.88022  -0.175
    ## ref_yeareastern_bering_sea-5-1997           -4.02016   24.56993  -0.164
    ## ref_yeareastern_bering_sea-5-1998            6.93417   71.61680   0.097
    ## ref_yeareastern_bering_sea-5-1999           -4.73754   24.44399  -0.194
    ## ref_yeareastern_bering_sea-5-2000           -4.18723   24.32199  -0.172
    ## ref_yeareastern_bering_sea-5-2001           19.28829   23.35325   0.826
    ## ref_yeareastern_bering_sea-5-2002           -2.68087   22.48831  -0.119
    ## ref_yeareastern_bering_sea-5-2003            1.82332   23.69145   0.077
    ## ref_yeareastern_bering_sea-5-2004            4.74978   38.26319   0.124
    ## ref_yeareastern_bering_sea-5-2005           53.64492   68.53286   0.783
    ## ref_yeareastern_bering_sea-5-2006            6.38323   64.89871   0.098
    ## ref_yeareastern_bering_sea-5-2007            1.41971   24.36223   0.058
    ## ref_yeareastern_bering_sea-5-2008           -5.93173   24.48552  -0.242
    ## ref_yeareastern_bering_sea-5-2009           -5.72828   24.48552  -0.234
    ## ref_yeareastern_bering_sea-5-2010          198.00090   24.44399   8.100
    ## ref_yeareastern_bering_sea-5-2011          121.26835   24.44399   4.961
    ## ref_yeareastern_bering_sea-5-2012            1.75587   24.48552   0.072
    ## ref_yeareastern_bering_sea-5-2013           -3.90399   24.52750  -0.159
    ## ref_yeareastern_bering_sea-5-2014           -5.61683   24.32199  -0.231
    ## ref_yeareastern_bering_sea-5-2015           10.55834   88.72761   0.119
    ## ref_yeareastern_bering_sea-5-2016            3.39722   36.71920   0.093
    ## ref_yeareastern_bering_sea-5-2017           14.49923  128.51180   0.113
    ## ref_yeareastern_bering_sea-5-2018            1.83473   24.48552   0.075
    ## ref_yeargulf_of_alaska-5-1987               -3.92798   23.13285  -0.170
    ## ref_yeargulf_of_alaska-5-1990               -1.51051   24.36223  -0.062
    ## ref_yeargulf_of_alaska-5-1993                0.68795   23.53149   0.029
    ## ref_yeargulf_of_alaska-5-1996                0.46055   22.58356   0.020
    ## ref_yeargulf_of_alaska-5-1999               -4.76034   22.26383  -0.214
    ## ref_yeargulf_of_alaska-5-2003                9.73927   25.36780   0.384
    ## ref_yeargulf_of_alaska-5-2005                8.38998   57.24815   0.147
    ## ref_yeargulf_of_alaska-5-2007               14.48507   48.00508   0.302
    ## ref_yeargulf_of_alaska-5-2009               -5.16348   22.26383  -0.232
    ## ref_yeargulf_of_alaska-5-2011               -4.20926   22.26383  -0.189
    ## ref_yeargulf_of_alaska-5-2013               -2.38001   22.32948  -0.107
    ## ref_yeargulf_of_alaska-5-2015                0.75422   26.15495   0.029
    ## ref_yeargulf_of_alaska-5-2017                4.79565   61.49004   0.078
    ## ref_yeargulf_of_mexico-1-2009               46.85609   26.57640   1.763
    ## ref_yeargulf_of_mexico-1-2010               -0.07262   26.88292  -0.003
    ## ref_yeargulf_of_mexico-1-2011                4.00527   50.18808   0.080
    ## ref_yeargulf_of_mexico-1-2012               -2.54850   21.36644  -0.119
    ## ref_yeargulf_of_mexico-1-2013               16.90020  121.26209   0.139
    ## ref_yeargulf_of_mexico-1-2014               -5.37951   20.73478  -0.259
    ## ref_yeargulf_of_mexico-1-2015               -4.89568   20.69984  -0.237
    ## ref_yeargulf_of_mexico-1-2016                0.58725   38.38758   0.015
    ## ref_yeargulf_of_mexico-1-2017                0.66463   24.41918   0.027
    ## ref_yearnortheast-2-1983                    -1.33487   34.30979  -0.039
    ## ref_yearnortheast-2-1984                    -0.28579   33.59833  -0.009
    ## ref_yearnortheast-2-1985                     2.62917   43.70832   0.060
    ## ref_yearnortheast-2-1986                    -2.67498   30.86429  -0.087
    ## ref_yearnortheast-2-1987                    -2.08383   32.12948  -0.065
    ## ref_yearnortheast-2-1988                    -2.40526   28.86435  -0.083
    ## ref_yearnortheast-2-1989                    -1.24771   27.78867  -0.045
    ## ref_yearnortheast-2-1990                    -2.32719   30.34652  -0.077
    ## ref_yearnortheast-2-1991                     2.77395   37.93591   0.073
    ## ref_yearnortheast-2-1992                     9.24078   85.28767   0.108
    ## ref_yearnortheast-2-1993                    -6.55399   29.07401  -0.225
    ## ref_yearnortheast-2-1994                     7.95443   27.74486   0.287
    ## ref_yearnortheast-2-1995                     2.92935   38.18682   0.077
    ## ref_yearnortheast-2-1996                    -6.52728   28.66190  -0.228
    ## ref_yearnortheast-2-1997                    -5.28206   27.77528  -0.190
    ## ref_yearnortheast-2-1998                    -4.20013   28.96825  -0.145
    ## ref_yearnortheast-2-1999                    -2.01744   28.86435  -0.070
    ## ref_yearnortheast-2-2000                    -2.69049   30.29022  -0.089
    ## ref_yearnortheast-2-2001                    -0.62043   39.10474  -0.016
    ## ref_yearnortheast-2-2002                     8.43546   35.77532   0.236
    ## ref_yearnortheast-2-2003                    20.00944   55.97480   0.357
    ## ref_yearnortheast-2-2004                    -6.71620   28.76225  -0.234
    ## ref_yearnortheast-2-2005                    -5.51629   28.96825  -0.190
    ## ref_yearnortheast-2-2006                     1.07051   36.14990   0.030
    ## ref_yearnortheast-2-2007                     2.85557   55.94505   0.051
    ## ref_yearnortheast-2-2008                    -4.89612   28.76225  -0.170
    ## ref_yearnortheast-2-2009                     0.77033   29.26405   0.026
    ## ref_yearnortheast-2-2010                    -2.71895   32.02444  -0.085
    ## ref_yearnortheast-2-2011                     9.65222   88.45321   0.109
    ## ref_yearnortheast-2-2012                     6.76878   76.08137   0.089
    ## ref_yearnortheast-2-2013                     7.99492   81.45225   0.098
    ## ref_yearnortheast-2-2014                     5.50549   66.00931   0.083
    ## ref_yearnortheast-2-2015                     0.35359   32.37338   0.011
    ## ref_yearnortheast-2-2016                     3.28269   57.99339   0.057
    ## ref_yearnortheast-2-2017                    -1.53779   40.18247  -0.038
    ## ref_yearnortheast-2-2018                     0.35107   31.79418   0.011
    ## ref_yearscotian_shelf-6-1983                -0.81744   52.04662  -0.016
    ## ref_yearscotian_shelf-6-1984                 4.40242   57.73150   0.076
    ## ref_yearscotian_shelf-6-1985                 8.44312   92.30795   0.091
    ## ref_yearscotian_shelf-6-1987                -5.49016   40.99296  -0.134
    ## ref_yearscotian_shelf-6-1988                -4.52757   40.54373  -0.112
    ## ref_yearscotian_shelf-6-1989                 0.56742   54.92646   0.010
    ## ref_yearscotian_shelf-6-1990                -6.56373   40.99296  -0.160
    ## ref_yearscotian_shelf-6-1991                 3.90019   49.85666   0.078
    ## ref_yearscotian_shelf-6-1992                -6.69031   40.99296  -0.163
    ## ref_yearscotian_shelf-6-1993                -5.99929   41.45586  -0.145
    ## ref_yearscotian_shelf-6-1994                -5.51864   40.54891  -0.136
    ## ref_yearscotian_shelf-6-1995                12.73872  102.81461   0.124
    ## ref_yearscotian_shelf-6-1996                -7.01898   40.54891  -0.173
    ## ref_yearscotian_shelf-6-1997                -6.31931   40.54891  -0.156
    ## ref_yearscotian_shelf-6-1998                -6.42035   42.44363  -0.151
    ## ref_yearscotian_shelf-6-1999                -0.54855   48.37762  -0.011
    ## ref_yearscotian_shelf-6-2000                 8.72976   95.96941   0.091
    ## ref_yearscotian_shelf-6-2001                -6.29835   40.54891  -0.155
    ## ref_yearscotian_shelf-6-2002                -6.78048   40.54891  -0.167
    ## ref_yearscotian_shelf-6-2003                -5.09702   40.94503  -0.124
    ## ref_yearscotian_shelf-6-2004                 1.46086   57.87442   0.025
    ## ref_yearscotian_shelf-6-2005                -4.51577   40.54891  -0.111
    ## ref_yearscotian_shelf-6-2006                 1.80537   59.10697   0.031
    ## ref_yearscotian_shelf-6-2007                -6.58160   41.45586  -0.159
    ## ref_yearscotian_shelf-6-2008                -6.00703   40.54891  -0.148
    ## ref_yearscotian_shelf-6-2009                -2.44084   39.87167  -0.061
    ## ref_yearscotian_shelf-6-2010                 6.48565   48.92412   0.133
    ## ref_yearscotian_shelf-6-2011                12.74309  115.69112   0.110
    ## ref_yearscotian_shelf-6-2012                 7.99274   95.04472   0.084
    ## ref_yearscotian_shelf-6-2013                 1.67691   58.08310   0.029
    ## ref_yearscotian_shelf-6-2014                 4.11697   70.52918   0.058
    ## ref_yearscotian_shelf-6-2015                -2.61691   42.56411  -0.061
    ## ref_yearscotian_shelf-6-2016                -2.36907   42.69909  -0.055
    ## ref_yearscotian_shelf-6-2017                 1.25141   46.10987   0.027
    ## ref_yearsoutheast-4-1990                     2.78570   52.04905   0.054
    ## ref_yearsoutheast-4-1991                    -2.53215   28.34229  -0.089
    ## ref_yearsoutheast-4-1992                    -5.08017   25.14507  -0.202
    ## ref_yearsoutheast-4-1993                     4.23451   59.39616   0.071
    ## ref_yearsoutheast-4-1994                    -0.42454   35.09183  -0.012
    ## ref_yearsoutheast-4-1995                    -2.78958   25.79542  -0.108
    ## ref_yearsoutheast-4-1996                    -6.29664   26.74835  -0.235
    ## ref_yearsoutheast-4-1997                     8.82370   90.91615   0.097
    ## ref_yearsoutheast-4-1998                    -4.87826   26.88965  -0.181
    ## ref_yearsoutheast-4-1999                     7.13334   77.49156   0.092
    ## ref_yearsoutheast-4-2000                    -4.82387   25.01364  -0.193
    ## ref_yearsoutheast-4-2001                     1.07155   36.75802   0.029
    ## ref_yearsoutheast-4-2002                     0.25871   33.31910   0.008
    ## ref_yearsoutheast-4-2003                    -3.52370   25.56723  -0.138
    ## ref_yearsoutheast-4-2004                    -4.73329   25.38262  -0.186
    ## ref_yearsoutheast-4-2005                    -3.46003   25.75672  -0.134
    ## ref_yearsoutheast-4-2006                     0.55916   42.59994   0.013
    ## ref_yearsoutheast-4-2007                    -5.55269   26.67918  -0.208
    ## ref_yearsoutheast-4-2008                    -3.13330   26.46359  -0.118
    ## ref_yearsoutheast-4-2009                    -4.34370   26.74835  -0.162
    ## ref_yearsoutheast-4-2010                    -5.89151   26.88965  -0.219
    ## ref_yearsoutheast-4-2011                     0.37372   29.24985   0.013
    ## ref_yearsoutheast-4-2012                    14.03354   73.72237   0.190
    ## ref_yearsoutheast-4-2013                     1.58840   38.84616   0.041
    ## ref_yearsoutheast-4-2014                    -6.52460   26.81850  -0.243
    ## ref_yearsoutheast-4-2015                     1.84298   26.12648   0.071
    ## ref_yearsoutheast-4-2016                     4.03795   59.86880   0.067
    ## ref_yearsoutheast-4-2017                     3.05468   26.57477   0.115
    ## ref_yearsoutheast-4-2018                     0.85729   48.96738   0.018
    ## ref_yearwest_coast-5-1986                   -5.77353   27.41772  -0.211
    ## ref_yearwest_coast-5-1989                   -4.36860   27.57900  -0.158
    ## ref_yearwest_coast-5-1992                    0.77891   33.06716   0.024
    ## ref_yearwest_coast-5-1995                   -0.50722   34.13946  -0.015
    ## ref_yearwest_coast-5-1998                    8.30929   70.43599   0.118
    ## ref_yearwest_coast-5-2001                   -2.42806   27.41772  -0.089
    ## ref_yearwest_coast-5-2003                  137.69626   29.07401   4.736
    ## ref_yearwest_coast-5-2004                    4.13087   21.85594   0.189
    ## ref_yearwest_coast-5-2005                   -3.04698   23.42313  -0.130
    ## ref_yearwest_coast-5-2006                   -2.38661   23.16475  -0.103
    ## ref_yearwest_coast-5-2007                    7.08945   23.13592   0.306
    ## ref_yearwest_coast-5-2008                    3.55670   46.34418   0.077
    ## ref_yearwest_coast-5-2009                    0.60597   23.13592   0.026
    ## ref_yearwest_coast-5-2010                   -2.49603   22.96808  -0.109
    ## ref_yearwest_coast-5-2011                    5.78355   23.07900   0.251
    ## ref_yearwest_coast-5-2012                   -0.58896   23.02307  -0.026
    ## ref_yearwest_coast-5-2013                    1.86858   23.02307   0.081
    ## ref_yearwest_coast-5-2014                    4.64412   33.56083   0.138
    ## ref_yearwest_coast-5-2015                    9.30542   67.41732   0.138
    ## ref_yearwest_coast-5-2016                    2.39837   44.06003   0.054
    ## ref_yearwest_coast-5-2017                    0.67225   38.42126   0.017
    ## ref_yearwest_coast-5-2018                         NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-1991          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-1994          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-1997          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2000          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2002          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2004          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2006          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2010          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2012          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2014          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2016          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2018          NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1983        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1984        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1985        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1986        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1987        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1988        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1989        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1990        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1991        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1992        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1993        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1994        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1995        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1996        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1997        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1998        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1999        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2000        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2001        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2002        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2003        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2004        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2005        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2006        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2007        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2008        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2009        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2010        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2011        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2012        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2013        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2014        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2015        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2016        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2017        NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2018        NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1987            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1990            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1993            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1996            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1999            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2003            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2005            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2007            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2009            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2011            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2013            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2015            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2017            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2009            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2010            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2011            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2012            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2013            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2014            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2015            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2016            NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-1-2017            NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1983                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1984                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1985                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1986                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1987                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1988                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1989                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1990                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1991                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1992                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1993                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1994                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1995                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1996                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1997                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1998                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1999                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2000                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2001                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2002                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2003                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2004                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2005                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2006                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2007                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2008                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2009                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2010                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2011                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2012                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2013                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2014                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2015                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2016                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2017                 NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2018                 NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1983             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1984             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1985             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1987             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1988             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1989             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1990             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1991             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1992             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1993             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1994             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1995             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1996             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1997             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1998             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1999             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2000             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2001             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2002             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2003             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2004             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2005             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2006             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2007             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2008             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2009             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2010             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2011             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2012             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2013             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2014             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2015             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2016             NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2017             NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1990                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1991                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1992                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1993                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1994                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1995                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1996                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1997                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1998                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1999                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2000                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2001                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2002                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2003                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2004                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2005                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2006                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2007                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2008                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2009                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2010                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2011                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2012                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2013                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2014                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2015                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2016                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2017                 NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2018                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1986                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1989                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1992                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1995                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1998                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2001                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2003                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2004                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2005                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2006                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2007                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2008                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2009                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2010                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2011                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2012                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2013                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2014                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2015                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2016                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2017                NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2018                NA         NA      NA
    ##                                            Pr(>|t|)    
    ## (Intercept)                                  0.6728    
    ## anomIntC                                     0.8751    
    ## ref_yearaleutian_islands-5-1991              0.9811    
    ## ref_yearaleutian_islands-5-1994              0.8093    
    ## ref_yearaleutian_islands-5-1997              0.9563    
    ## ref_yearaleutian_islands-5-2000              0.8607    
    ## ref_yearaleutian_islands-5-2002              0.9601    
    ## ref_yearaleutian_islands-5-2004              0.9864    
    ## ref_yearaleutian_islands-5-2006              0.3427    
    ## ref_yearaleutian_islands-5-2010              0.8237    
    ## ref_yearaleutian_islands-5-2012              0.9370    
    ## ref_yearaleutian_islands-5-2014              0.8778    
    ## ref_yearaleutian_islands-5-2016              0.9550    
    ## ref_yearaleutian_islands-5-2018              0.9543    
    ## ref_yeareastern_bering_sea-5-1983            0.8788    
    ## ref_yeareastern_bering_sea-5-1984            0.2716    
    ## ref_yeareastern_bering_sea-5-1985            0.7618    
    ## ref_yeareastern_bering_sea-5-1986            0.8908    
    ## ref_yeareastern_bering_sea-5-1987            0.6501    
    ## ref_yeareastern_bering_sea-5-1988            0.5109    
    ## ref_yeareastern_bering_sea-5-1989            0.8288    
    ## ref_yeareastern_bering_sea-5-1990            0.2014    
    ## ref_yeareastern_bering_sea-5-1991            0.8329    
    ## ref_yeareastern_bering_sea-5-1992            0.8857    
    ## ref_yeareastern_bering_sea-5-1993            0.8281    
    ## ref_yeareastern_bering_sea-5-1994            0.9663    
    ## ref_yeareastern_bering_sea-5-1995            0.7996    
    ## ref_yeareastern_bering_sea-5-1996            0.8611    
    ## ref_yeareastern_bering_sea-5-1997            0.8700    
    ## ref_yeareastern_bering_sea-5-1998            0.9229    
    ## ref_yeareastern_bering_sea-5-1999            0.8463    
    ## ref_yeareastern_bering_sea-5-2000            0.8633    
    ## ref_yeareastern_bering_sea-5-2001            0.4088    
    ## ref_yeareastern_bering_sea-5-2002            0.9051    
    ## ref_yeareastern_bering_sea-5-2003            0.9387    
    ## ref_yeareastern_bering_sea-5-2004            0.9012    
    ## ref_yeareastern_bering_sea-5-2005            0.4338    
    ## ref_yeareastern_bering_sea-5-2006            0.9216    
    ## ref_yeareastern_bering_sea-5-2007            0.9535    
    ## ref_yeareastern_bering_sea-5-2008            0.8086    
    ## ref_yeareastern_bering_sea-5-2009            0.8150    
    ## ref_yeareastern_bering_sea-5-2010          5.73e-16 ***
    ## ref_yeareastern_bering_sea-5-2011          7.06e-07 ***
    ## ref_yeareastern_bering_sea-5-2012            0.9428    
    ## ref_yeareastern_bering_sea-5-2013            0.8735    
    ## ref_yeareastern_bering_sea-5-2014            0.8174    
    ## ref_yeareastern_bering_sea-5-2015            0.9053    
    ## ref_yeareastern_bering_sea-5-2016            0.9263    
    ## ref_yeareastern_bering_sea-5-2017            0.9102    
    ## ref_yeareastern_bering_sea-5-2018            0.9403    
    ## ref_yeargulf_of_alaska-5-1987                0.8652    
    ## ref_yeargulf_of_alaska-5-1990                0.9506    
    ## ref_yeargulf_of_alaska-5-1993                0.9767    
    ## ref_yeargulf_of_alaska-5-1996                0.9837    
    ## ref_yeargulf_of_alaska-5-1999                0.8307    
    ## ref_yeargulf_of_alaska-5-2003                0.7010    
    ## ref_yeargulf_of_alaska-5-2005                0.8835    
    ## ref_yeargulf_of_alaska-5-2007                0.7629    
    ## ref_yeargulf_of_alaska-5-2009                0.8166    
    ## ref_yeargulf_of_alaska-5-2011                0.8500    
    ## ref_yeargulf_of_alaska-5-2013                0.9151    
    ## ref_yeargulf_of_alaska-5-2015                0.9770    
    ## ref_yeargulf_of_alaska-5-2017                0.9378    
    ## ref_yeargulf_of_mexico-1-2009                0.0779 .  
    ## ref_yeargulf_of_mexico-1-2010                0.9978    
    ## ref_yeargulf_of_mexico-1-2011                0.9364    
    ## ref_yeargulf_of_mexico-1-2012                0.9051    
    ## ref_yeargulf_of_mexico-1-2013                0.8892    
    ## ref_yeargulf_of_mexico-1-2014                0.7953    
    ## ref_yeargulf_of_mexico-1-2015                0.8130    
    ## ref_yeargulf_of_mexico-1-2016                0.9878    
    ## ref_yeargulf_of_mexico-1-2017                0.9783    
    ## ref_yearnortheast-2-1983                     0.9690    
    ## ref_yearnortheast-2-1984                     0.9932    
    ## ref_yearnortheast-2-1985                     0.9520    
    ## ref_yearnortheast-2-1986                     0.9309    
    ## ref_yearnortheast-2-1987                     0.9483    
    ## ref_yearnortheast-2-1988                     0.9336    
    ## ref_yearnortheast-2-1989                     0.9642    
    ## ref_yearnortheast-2-1990                     0.9389    
    ## ref_yearnortheast-2-1991                     0.9417    
    ## ref_yearnortheast-2-1992                     0.9137    
    ## ref_yearnortheast-2-1993                     0.8217    
    ## ref_yearnortheast-2-1994                     0.7743    
    ## ref_yearnortheast-2-1995                     0.9389    
    ## ref_yearnortheast-2-1996                     0.8199    
    ## ref_yearnortheast-2-1997                     0.8492    
    ## ref_yearnortheast-2-1998                     0.8847    
    ## ref_yearnortheast-2-1999                     0.9443    
    ## ref_yearnortheast-2-2000                     0.9292    
    ## ref_yearnortheast-2-2001                     0.9873    
    ## ref_yearnortheast-2-2002                     0.8136    
    ## ref_yearnortheast-2-2003                     0.7207    
    ## ref_yearnortheast-2-2004                     0.8154    
    ## ref_yearnortheast-2-2005                     0.8490    
    ## ref_yearnortheast-2-2006                     0.9764    
    ## ref_yearnortheast-2-2007                     0.9593    
    ## ref_yearnortheast-2-2008                     0.8648    
    ## ref_yearnortheast-2-2009                     0.9790    
    ## ref_yearnortheast-2-2010                     0.9323    
    ## ref_yearnortheast-2-2011                     0.9131    
    ## ref_yearnortheast-2-2012                     0.9291    
    ## ref_yearnortheast-2-2013                     0.9218    
    ## ref_yearnortheast-2-2014                     0.9335    
    ## ref_yearnortheast-2-2015                     0.9913    
    ## ref_yearnortheast-2-2016                     0.9549    
    ## ref_yearnortheast-2-2017                     0.9695    
    ## ref_yearnortheast-2-2018                     0.9912    
    ## ref_yearscotian_shelf-6-1983                 0.9875    
    ## ref_yearscotian_shelf-6-1984                 0.9392    
    ## ref_yearscotian_shelf-6-1985                 0.9271    
    ## ref_yearscotian_shelf-6-1987                 0.8935    
    ## ref_yearscotian_shelf-6-1988                 0.9111    
    ## ref_yearscotian_shelf-6-1989                 0.9918    
    ## ref_yearscotian_shelf-6-1990                 0.8728    
    ## ref_yearscotian_shelf-6-1991                 0.9376    
    ## ref_yearscotian_shelf-6-1992                 0.8704    
    ## ref_yearscotian_shelf-6-1993                 0.8849    
    ## ref_yearscotian_shelf-6-1994                 0.8917    
    ## ref_yearscotian_shelf-6-1995                 0.9014    
    ## ref_yearscotian_shelf-6-1996                 0.8626    
    ## ref_yearscotian_shelf-6-1997                 0.8762    
    ## ref_yearscotian_shelf-6-1998                 0.8798    
    ## ref_yearscotian_shelf-6-1999                 0.9910    
    ## ref_yearscotian_shelf-6-2000                 0.9275    
    ## ref_yearscotian_shelf-6-2001                 0.8766    
    ## ref_yearscotian_shelf-6-2002                 0.8672    
    ## ref_yearscotian_shelf-6-2003                 0.9009    
    ## ref_yearscotian_shelf-6-2004                 0.9799    
    ## ref_yearscotian_shelf-6-2005                 0.9113    
    ## ref_yearscotian_shelf-6-2006                 0.9756    
    ## ref_yearscotian_shelf-6-2007                 0.8739    
    ## ref_yearscotian_shelf-6-2008                 0.8822    
    ## ref_yearscotian_shelf-6-2009                 0.9512    
    ## ref_yearscotian_shelf-6-2010                 0.8945    
    ## ref_yearscotian_shelf-6-2011                 0.9123    
    ## ref_yearscotian_shelf-6-2012                 0.9330    
    ## ref_yearscotian_shelf-6-2013                 0.9770    
    ## ref_yearscotian_shelf-6-2014                 0.9535    
    ## ref_yearscotian_shelf-6-2015                 0.9510    
    ## ref_yearscotian_shelf-6-2016                 0.9558    
    ## ref_yearscotian_shelf-6-2017                 0.9783    
    ## ref_yearsoutheast-4-1990                     0.9573    
    ## ref_yearsoutheast-4-1991                     0.9288    
    ## ref_yearsoutheast-4-1992                     0.8399    
    ## ref_yearsoutheast-4-1993                     0.9432    
    ## ref_yearsoutheast-4-1994                     0.9903    
    ## ref_yearsoutheast-4-1995                     0.9139    
    ## ref_yearsoutheast-4-1996                     0.8139    
    ## ref_yearsoutheast-4-1997                     0.9227    
    ## ref_yearsoutheast-4-1998                     0.8560    
    ## ref_yearsoutheast-4-1999                     0.9267    
    ## ref_yearsoutheast-4-2000                     0.8471    
    ## ref_yearsoutheast-4-2001                     0.9767    
    ## ref_yearsoutheast-4-2002                     0.9938    
    ## ref_yearsoutheast-4-2003                     0.8904    
    ## ref_yearsoutheast-4-2004                     0.8521    
    ## ref_yearsoutheast-4-2005                     0.8931    
    ## ref_yearsoutheast-4-2006                     0.9895    
    ## ref_yearsoutheast-4-2007                     0.8351    
    ## ref_yearsoutheast-4-2008                     0.9058    
    ## ref_yearsoutheast-4-2009                     0.8710    
    ## ref_yearsoutheast-4-2010                     0.8266    
    ## ref_yearsoutheast-4-2011                     0.9898    
    ## ref_yearsoutheast-4-2012                     0.8490    
    ## ref_yearsoutheast-4-2013                     0.9674    
    ## ref_yearsoutheast-4-2014                     0.8078    
    ## ref_yearsoutheast-4-2015                     0.9438    
    ## ref_yearsoutheast-4-2016                     0.9462    
    ## ref_yearsoutheast-4-2017                     0.9085    
    ## ref_yearsoutheast-4-2018                     0.9860    
    ## ref_yearwest_coast-5-1986                    0.8332    
    ## ref_yearwest_coast-5-1989                    0.8741    
    ## ref_yearwest_coast-5-1992                    0.9812    
    ## ref_yearwest_coast-5-1995                    0.9881    
    ## ref_yearwest_coast-5-1998                    0.9061    
    ## ref_yearwest_coast-5-2001                    0.9294    
    ## ref_yearwest_coast-5-2003                  2.19e-06 ***
    ## ref_yearwest_coast-5-2004                    0.8501    
    ## ref_yearwest_coast-5-2005                    0.8965    
    ## ref_yearwest_coast-5-2006                    0.9179    
    ## ref_yearwest_coast-5-2007                    0.7593    
    ## ref_yearwest_coast-5-2008                    0.9388    
    ## ref_yearwest_coast-5-2009                    0.9791    
    ## ref_yearwest_coast-5-2010                    0.9135    
    ## ref_yearwest_coast-5-2011                    0.8021    
    ## ref_yearwest_coast-5-2012                    0.9796    
    ## ref_yearwest_coast-5-2013                    0.9353    
    ## ref_yearwest_coast-5-2014                    0.8899    
    ## ref_yearwest_coast-5-2015                    0.8902    
    ## ref_yearwest_coast-5-2016                    0.9566    
    ## ref_yearwest_coast-5-2017                    0.9860    
    ## ref_yearwest_coast-5-2018                        NA    
    ## anomIntC:ref_yearaleutian_islands-5-1991         NA    
    ## anomIntC:ref_yearaleutian_islands-5-1994         NA    
    ## anomIntC:ref_yearaleutian_islands-5-1997         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2000         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2002         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2004         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2006         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2010         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2012         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2014         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2016         NA    
    ## anomIntC:ref_yearaleutian_islands-5-2018         NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1983       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1984       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1985       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1986       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1987       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1988       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1989       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1990       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1991       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1992       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1993       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1994       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1995       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1996       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1997       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1998       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-1999       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2000       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2001       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2002       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2003       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2004       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2005       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2006       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2007       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2008       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2009       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2010       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2011       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2012       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2013       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2014       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2015       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2016       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2017       NA    
    ## anomIntC:ref_yeareastern_bering_sea-5-2018       NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-1987           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-1990           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-1993           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-1996           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-1999           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2003           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2005           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2007           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2009           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2011           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2013           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2015           NA    
    ## anomIntC:ref_yeargulf_of_alaska-5-2017           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2009           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2010           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2011           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2012           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2013           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2014           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2015           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2016           NA    
    ## anomIntC:ref_yeargulf_of_mexico-1-2017           NA    
    ## anomIntC:ref_yearnortheast-2-1983                NA    
    ## anomIntC:ref_yearnortheast-2-1984                NA    
    ## anomIntC:ref_yearnortheast-2-1985                NA    
    ## anomIntC:ref_yearnortheast-2-1986                NA    
    ## anomIntC:ref_yearnortheast-2-1987                NA    
    ## anomIntC:ref_yearnortheast-2-1988                NA    
    ## anomIntC:ref_yearnortheast-2-1989                NA    
    ## anomIntC:ref_yearnortheast-2-1990                NA    
    ## anomIntC:ref_yearnortheast-2-1991                NA    
    ## anomIntC:ref_yearnortheast-2-1992                NA    
    ## anomIntC:ref_yearnortheast-2-1993                NA    
    ## anomIntC:ref_yearnortheast-2-1994                NA    
    ## anomIntC:ref_yearnortheast-2-1995                NA    
    ## anomIntC:ref_yearnortheast-2-1996                NA    
    ## anomIntC:ref_yearnortheast-2-1997                NA    
    ## anomIntC:ref_yearnortheast-2-1998                NA    
    ## anomIntC:ref_yearnortheast-2-1999                NA    
    ## anomIntC:ref_yearnortheast-2-2000                NA    
    ## anomIntC:ref_yearnortheast-2-2001                NA    
    ## anomIntC:ref_yearnortheast-2-2002                NA    
    ## anomIntC:ref_yearnortheast-2-2003                NA    
    ## anomIntC:ref_yearnortheast-2-2004                NA    
    ## anomIntC:ref_yearnortheast-2-2005                NA    
    ## anomIntC:ref_yearnortheast-2-2006                NA    
    ## anomIntC:ref_yearnortheast-2-2007                NA    
    ## anomIntC:ref_yearnortheast-2-2008                NA    
    ## anomIntC:ref_yearnortheast-2-2009                NA    
    ## anomIntC:ref_yearnortheast-2-2010                NA    
    ## anomIntC:ref_yearnortheast-2-2011                NA    
    ## anomIntC:ref_yearnortheast-2-2012                NA    
    ## anomIntC:ref_yearnortheast-2-2013                NA    
    ## anomIntC:ref_yearnortheast-2-2014                NA    
    ## anomIntC:ref_yearnortheast-2-2015                NA    
    ## anomIntC:ref_yearnortheast-2-2016                NA    
    ## anomIntC:ref_yearnortheast-2-2017                NA    
    ## anomIntC:ref_yearnortheast-2-2018                NA    
    ## anomIntC:ref_yearscotian_shelf-6-1983            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1984            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1985            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1987            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1988            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1989            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1990            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1991            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1992            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1993            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1994            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1995            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1996            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1997            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1998            NA    
    ## anomIntC:ref_yearscotian_shelf-6-1999            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2000            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2001            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2002            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2003            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2004            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2005            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2006            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2007            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2008            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2009            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2010            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2011            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2012            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2013            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2014            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2015            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2016            NA    
    ## anomIntC:ref_yearscotian_shelf-6-2017            NA    
    ## anomIntC:ref_yearsoutheast-4-1990                NA    
    ## anomIntC:ref_yearsoutheast-4-1991                NA    
    ## anomIntC:ref_yearsoutheast-4-1992                NA    
    ## anomIntC:ref_yearsoutheast-4-1993                NA    
    ## anomIntC:ref_yearsoutheast-4-1994                NA    
    ## anomIntC:ref_yearsoutheast-4-1995                NA    
    ## anomIntC:ref_yearsoutheast-4-1996                NA    
    ## anomIntC:ref_yearsoutheast-4-1997                NA    
    ## anomIntC:ref_yearsoutheast-4-1998                NA    
    ## anomIntC:ref_yearsoutheast-4-1999                NA    
    ## anomIntC:ref_yearsoutheast-4-2000                NA    
    ## anomIntC:ref_yearsoutheast-4-2001                NA    
    ## anomIntC:ref_yearsoutheast-4-2002                NA    
    ## anomIntC:ref_yearsoutheast-4-2003                NA    
    ## anomIntC:ref_yearsoutheast-4-2004                NA    
    ## anomIntC:ref_yearsoutheast-4-2005                NA    
    ## anomIntC:ref_yearsoutheast-4-2006                NA    
    ## anomIntC:ref_yearsoutheast-4-2007                NA    
    ## anomIntC:ref_yearsoutheast-4-2008                NA    
    ## anomIntC:ref_yearsoutheast-4-2009                NA    
    ## anomIntC:ref_yearsoutheast-4-2010                NA    
    ## anomIntC:ref_yearsoutheast-4-2011                NA    
    ## anomIntC:ref_yearsoutheast-4-2012                NA    
    ## anomIntC:ref_yearsoutheast-4-2013                NA    
    ## anomIntC:ref_yearsoutheast-4-2014                NA    
    ## anomIntC:ref_yearsoutheast-4-2015                NA    
    ## anomIntC:ref_yearsoutheast-4-2016                NA    
    ## anomIntC:ref_yearsoutheast-4-2017                NA    
    ## anomIntC:ref_yearsoutheast-4-2018                NA    
    ## anomIntC:ref_yearwest_coast-5-1986               NA    
    ## anomIntC:ref_yearwest_coast-5-1989               NA    
    ## anomIntC:ref_yearwest_coast-5-1992               NA    
    ## anomIntC:ref_yearwest_coast-5-1995               NA    
    ## anomIntC:ref_yearwest_coast-5-1998               NA    
    ## anomIntC:ref_yearwest_coast-5-2001               NA    
    ## anomIntC:ref_yearwest_coast-5-2003               NA    
    ## anomIntC:ref_yearwest_coast-5-2004               NA    
    ## anomIntC:ref_yearwest_coast-5-2005               NA    
    ## anomIntC:ref_yearwest_coast-5-2006               NA    
    ## anomIntC:ref_yearwest_coast-5-2007               NA    
    ## anomIntC:ref_yearwest_coast-5-2008               NA    
    ## anomIntC:ref_yearwest_coast-5-2009               NA    
    ## anomIntC:ref_yearwest_coast-5-2010               NA    
    ## anomIntC:ref_yearwest_coast-5-2011               NA    
    ## anomIntC:ref_yearwest_coast-5-2012               NA    
    ## anomIntC:ref_yearwest_coast-5-2013               NA    
    ## anomIntC:ref_yearwest_coast-5-2014               NA    
    ## anomIntC:ref_yearwest_coast-5-2015               NA    
    ## anomIntC:ref_yearwest_coast-5-2016               NA    
    ## anomIntC:ref_yearwest_coast-5-2017               NA    
    ## anomIntC:ref_yearwest_coast-5-2018               NA    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 231.6 on 25348 degrees of freedom
    ## Multiple R-squared:  0.009207,   Adjusted R-squared:  0.001741 
    ## F-statistic: 1.233 on 191 and 25348 DF,  p-value: 0.01592

    ## # A tibble: 4 x 5
    ##   term                              estimate std.error statistic  p.value
    ##   <chr>                                <dbl>     <dbl>     <dbl>    <dbl>
    ## 1 ref_yeareastern_bering_sea-5-2010    198.       24.4      8.10 5.73e-16
    ## 2 ref_yeareastern_bering_sea-5-2011    121.       24.4      4.96 7.06e- 7
    ## 3 ref_yeargulf_of_mexico-1-2009         46.9      26.6      1.76 7.79e- 2
    ## 4 ref_yearwest_coast-5-2003            138.       29.1      4.74 2.19e- 6

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ ref_year, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##  -205.9    -5.3    -2.3    -0.9 20496.2 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                         2.313862  24.283253   0.095   0.9241    
    ## ref_yearaleutian_islands-5-1991     3.936327  33.402998   0.118   0.9062    
    ## ref_yearaleutian_islands-5-1994     7.736156  31.192404   0.248   0.8041    
    ## ref_yearaleutian_islands-5-1997     1.466003  30.449370   0.048   0.9616    
    ## ref_yearaleutian_islands-5-2000     8.838261  30.057957   0.294   0.7687    
    ## ref_yearaleutian_islands-5-2002    -1.728131  30.088647  -0.057   0.9542    
    ## ref_yearaleutian_islands-5-2004     0.266535  29.997550   0.009   0.9929    
    ## ref_yearaleutian_islands-5-2006    34.676262  30.057957   1.154   0.2487    
    ## ref_yearaleutian_islands-5-2010    -0.762149  30.027593  -0.025   0.9798    
    ## ref_yearaleutian_islands-5-2012    -0.264100  29.997550  -0.009   0.9930    
    ## ref_yearaleutian_islands-5-2014     3.466313  30.057957   0.115   0.9082    
    ## ref_yearaleutian_islands-5-2016     0.144039  30.182728   0.005   0.9962    
    ## ref_yearaleutian_islands-5-2018     1.108429  30.214777   0.037   0.9707    
    ## ref_yeareastern_bering_sea-5-1983   8.632588  31.921166   0.270   0.7868    
    ## ref_yeareastern_bering_sea-5-1984  51.747389  30.741573   1.683   0.0923 .  
    ## ref_yeareastern_bering_sea-5-1985  12.214962  30.380450   0.402   0.6876    
    ## ref_yeareastern_bering_sea-5-1986   7.953290  30.279942   0.263   0.7928    
    ## ref_yeareastern_bering_sea-5-1987  12.884329  30.313070   0.425   0.6708    
    ## ref_yeareastern_bering_sea-5-1988  19.047931  30.279942   0.629   0.5293    
    ## ref_yeareastern_bering_sea-5-1989  -0.637600  30.151027  -0.021   0.9831    
    ## ref_yeareastern_bering_sea-5-1990  35.887706  30.346571   1.183   0.2370    
    ## ref_yeareastern_bering_sea-5-1991  -0.579802  30.414714  -0.019   0.9848    
    ## ref_yeareastern_bering_sea-5-1992   1.033432  30.628770   0.034   0.9731    
    ## ref_yeareastern_bering_sea-5-1993  -0.819821  30.741573  -0.027   0.9787    
    ## ref_yeareastern_bering_sea-5-1994   2.616024  30.665925   0.085   0.9320    
    ## ref_yeareastern_bering_sea-5-1995  -1.735949  30.741573  -0.056   0.9550    
    ## ref_yeareastern_bering_sea-5-1996   0.250798  30.665925   0.008   0.9935    
    ## ref_yeareastern_bering_sea-5-1997   0.584175  30.414714   0.019   0.9847    
    ## ref_yeareastern_bering_sea-5-1998  -0.584974  30.247180  -0.019   0.9846    
    ## ref_yeareastern_bering_sea-5-1999  -0.133210  30.313070  -0.004   0.9965    
    ## ref_yeareastern_bering_sea-5-2000   0.417101  30.214777   0.014   0.9890    
    ## ref_yeareastern_bering_sea-5-2001  21.726459  30.484425   0.713   0.4760    
    ## ref_yeareastern_bering_sea-5-2002   0.492027  30.182728   0.016   0.9870    
    ## ref_yeareastern_bering_sea-5-2003   3.857898  30.247180   0.128   0.8985    
    ## ref_yeareastern_bering_sea-5-2004   3.052981  30.214777   0.101   0.9195    
    ## ref_yeareastern_bering_sea-5-2005  46.645181  30.346571   1.537   0.1243    
    ## ref_yeareastern_bering_sea-5-2006  -0.008949  30.346571   0.000   0.9998    
    ## ref_yeareastern_bering_sea-5-2007   6.024043  30.247180   0.199   0.8421    
    ## ref_yeareastern_bering_sea-5-2008  -1.327401  30.346571  -0.044   0.9651    
    ## ref_yeareastern_bering_sea-5-2009  -1.123942  30.346571  -0.037   0.9705    
    ## ref_yeareastern_bering_sea-5-2010 202.605235  30.313070   6.684 2.38e-11 ***
    ## ref_yeareastern_bering_sea-5-2011 125.872679  30.313070   4.152 3.30e-05 ***
    ## ref_yeareastern_bering_sea-5-2012   6.360201  30.346571   0.210   0.8340    
    ## ref_yeareastern_bering_sea-5-2013   0.700343  30.380450   0.023   0.9816    
    ## ref_yeareastern_bering_sea-5-2014  -1.012498  30.214777  -0.034   0.9733    
    ## ref_yeareastern_bering_sea-5-2015   0.240118  30.346571   0.008   0.9937    
    ## ref_yeareastern_bering_sea-5-2016   2.031428  30.380450   0.067   0.9467    
    ## ref_yeareastern_bering_sea-5-2017  -2.221871  30.279942  -0.073   0.9415    
    ## ref_yeareastern_bering_sea-5-2018   6.439066  30.346571   0.212   0.8320    
    ## ref_yeargulf_of_alaska-5-1987      -0.751794  30.665925  -0.025   0.9804    
    ## ref_yeargulf_of_alaska-5-1990       3.093821  30.247180   0.102   0.9185    
    ## ref_yeargulf_of_alaska-5-1993       5.292284  29.582171   0.179   0.8580    
    ## ref_yeargulf_of_alaska-5-1996       5.064886  28.833845   0.176   0.8606    
    ## ref_yeargulf_of_alaska-5-1999      -0.156002  28.584115  -0.005   0.9956    
    ## ref_yeargulf_of_alaska-5-2003      10.515784  28.601035   0.368   0.7131    
    ## ref_yeargulf_of_alaska-5-2005       3.138450  28.567328   0.110   0.9125    
    ## ref_yeargulf_of_alaska-5-2007      10.810909  28.584115   0.378   0.7053    
    ## ref_yeargulf_of_alaska-5-2009      -0.559148  28.584115  -0.020   0.9844    
    ## ref_yeargulf_of_alaska-5-2011       0.395073  28.584115   0.014   0.9890    
    ## ref_yeargulf_of_alaska-5-2013       2.224321  28.635279   0.078   0.9381    
    ## ref_yeargulf_of_alaska-5-2015       1.363076  28.723330   0.047   0.9622    
    ## ref_yeargulf_of_alaska-5-2017      -1.160102  28.635279  -0.041   0.9677    
    ## ref_yeargulf_of_mexico-1-2009      47.084824  27.618381   1.705   0.0882 .  
    ## ref_yeargulf_of_mexico-1-2010       0.037221  27.392275   0.001   0.9989    
    ## ref_yeargulf_of_mexico-1-2011      -0.159101  27.392275  -0.006   0.9954    
    ## ref_yeargulf_of_mexico-1-2012      -1.039989  27.401080  -0.038   0.9697    
    ## ref_yeargulf_of_mexico-1-2013       1.228638  27.401080   0.045   0.9642    
    ## ref_yeargulf_of_mexico-1-2014      -0.775172  27.409936  -0.028   0.9774    
    ## ref_yeargulf_of_mexico-1-2015      -0.291349  27.383520  -0.011   0.9915    
    ## ref_yeargulf_of_mexico-1-2016      -1.528917  27.392275  -0.056   0.9555    
    ## ref_yeargulf_of_mexico-1-2017       1.349707  27.436807   0.049   0.9608    
    ## ref_yearnortheast-2-1983           -1.351297  34.248259  -0.039   0.9685    
    ## ref_yearnortheast-2-1984           -0.183907  33.978292  -0.005   0.9957    
    ## ref_yearnortheast-2-1985            0.479871  34.248259   0.014   0.9888    
    ## ref_yearnortheast-2-1986           -1.718713  34.066602  -0.050   0.9598    
    ## ref_yearnortheast-2-1987           -1.506596  34.156575  -0.044   0.9648    
    ## ref_yearnortheast-2-1988            2.199076  33.978292   0.065   0.9484    
    ## ref_yearnortheast-2-1989            2.761019  33.891599   0.081   0.9351    
    ## ref_yearnortheast-2-1990           -1.290944  33.806478  -0.038   0.9695    
    ## ref_yearnortheast-2-1991            1.775002  33.806478   0.053   0.9581    
    ## ref_yearnortheast-2-1992           -0.297715  33.891599  -0.009   0.9930    
    ## ref_yearnortheast-2-1993           -1.949652  34.156575  -0.057   0.9545    
    ## ref_yearnortheast-2-1994           10.406712  33.978292   0.306   0.7594    
    ## ref_yearnortheast-2-1995            1.891011  33.891599   0.056   0.9555    
    ## ref_yearnortheast-2-1996           -1.922944  33.806478  -0.057   0.9546    
    ## ref_yearnortheast-2-1997           -1.376637  33.978292  -0.041   0.9677    
    ## ref_yearnortheast-2-1998            0.404202  34.066602   0.012   0.9905    
    ## ref_yearnortheast-2-1999            2.586894  33.978292   0.076   0.9393    
    ## ref_yearnortheast-2-2000           -1.489959  34.156575  -0.044   0.9652    
    ## ref_yearnortheast-2-2001           -1.775422  34.341706  -0.052   0.9588    
    ## ref_yearnortheast-2-2002            8.064729  34.341706   0.235   0.8143    
    ## ref_yearnortheast-2-2003           15.480260  33.806478   0.458   0.6470    
    ## ref_yearnortheast-2-2004           -2.111870  33.891599  -0.062   0.9503    
    ## ref_yearnortheast-2-2005           -0.911956  34.066602  -0.027   0.9786    
    ## ref_yearnortheast-2-2006            0.484703  33.806478   0.014   0.9886    
    ## ref_yearnortheast-2-2007           -1.668254  33.806478  -0.049   0.9606    
    ## ref_yearnortheast-2-2008           -0.291782  33.891599  -0.009   0.9931    
    ## ref_yearnortheast-2-2009            2.263707  33.891599   0.067   0.9467    
    ## ref_yearnortheast-2-2010           -2.221911  33.806478  -0.066   0.9476    
    ## ref_yearnortheast-2-2011           -0.421006  33.722886  -0.012   0.9900    
    ## ref_yearnortheast-2-2012           -1.231747  33.891599  -0.036   0.9710    
    ## ref_yearnortheast-2-2013           -0.911470  33.806478  -0.027   0.9785    
    ## ref_yearnortheast-2-2014           -0.756035  34.156575  -0.022   0.9823    
    ## ref_yearnortheast-2-2015            0.748503  33.806478   0.022   0.9823    
    ## ref_yearnortheast-2-2016           -1.616096  33.722886  -0.048   0.9618    
    ## ref_yearnortheast-2-2017           -2.547272  36.260433  -0.070   0.9440    
    ## ref_yearnortheast-2-2018            0.973035  33.978292   0.029   0.9772    
    ## ref_yearscotian_shelf-6-1983       -1.916762  48.768448  -0.039   0.9686    
    ## ref_yearscotian_shelf-6-1984        0.948780  44.334952   0.021   0.9829    
    ## ref_yearscotian_shelf-6-1985       -1.436491  45.165934  -0.032   0.9746    
    ## ref_yearscotian_shelf-6-1987       -0.885831  44.741437  -0.020   0.9842    
    ## ref_yearscotian_shelf-6-1988       -1.837487  45.165934  -0.041   0.9675    
    ## ref_yearscotian_shelf-6-1989       -2.267365  44.334952  -0.051   0.9592    
    ## ref_yearscotian_shelf-6-1990       -1.959395  44.741437  -0.044   0.9651    
    ## ref_yearscotian_shelf-6-1991        2.837920  46.561013   0.061   0.9514    
    ## ref_yearscotian_shelf-6-1992       -2.085980  44.741437  -0.047   0.9628    
    ## ref_yearscotian_shelf-6-1993       -1.394957  45.165934  -0.031   0.9754    
    ## ref_yearscotian_shelf-6-1994       -0.914302  44.334952  -0.021   0.9835    
    ## ref_yearscotian_shelf-6-1995        1.012021  44.741437   0.023   0.9820    
    ## ref_yearscotian_shelf-6-1996       -2.414644  44.334952  -0.054   0.9566    
    ## ref_yearscotian_shelf-6-1997       -1.714972  44.334952  -0.039   0.9691    
    ## ref_yearscotian_shelf-6-1998       -1.816017  46.074234  -0.039   0.9686    
    ## ref_yearscotian_shelf-6-1999       -1.774402  44.334952  -0.040   0.9681    
    ## ref_yearscotian_shelf-6-2000       -1.854201  44.334952  -0.042   0.9666    
    ## ref_yearscotian_shelf-6-2001       -1.694018  44.334952  -0.038   0.9695    
    ## ref_yearscotian_shelf-6-2002       -2.176142  44.334952  -0.049   0.9609    
    ## ref_yearscotian_shelf-6-2003       -2.126601  45.609728  -0.047   0.9628    
    ## ref_yearscotian_shelf-6-2004       -2.023559  44.334952  -0.046   0.9636    
    ## ref_yearscotian_shelf-6-2005        0.088562  44.334952   0.002   0.9984    
    ## ref_yearscotian_shelf-6-2006       -1.941775  44.334952  -0.044   0.9651    
    ## ref_yearscotian_shelf-6-2007       -1.977266  45.165934  -0.044   0.9651    
    ## ref_yearscotian_shelf-6-2008       -1.402698  44.334952  -0.032   0.9748    
    ## ref_yearscotian_shelf-6-2009       -0.129210  44.334952  -0.003   0.9977    
    ## ref_yearscotian_shelf-6-2010        5.436366  45.609728   0.119   0.9051    
    ## ref_yearscotian_shelf-6-2011       -1.185209  44.334952  -0.027   0.9787    
    ## ref_yearscotian_shelf-6-2012       -2.431578  44.334952  -0.055   0.9563    
    ## ref_yearscotian_shelf-6-2013       -1.852313  44.334952  -0.042   0.9667    
    ## ref_yearscotian_shelf-6-2014       -1.903208  44.334952  -0.043   0.9658    
    ## ref_yearscotian_shelf-6-2015       -1.944736  44.334952  -0.044   0.9650    
    ## ref_yearscotian_shelf-6-2016       -1.753309  44.334952  -0.040   0.9685    
    ## ref_yearscotian_shelf-6-2017        0.676832  44.334952   0.015   0.9878    
    ## ref_yearsoutheast-4-1990           -1.201495  32.317593  -0.037   0.9703    
    ## ref_yearsoutheast-4-1991           -1.449540  32.142683  -0.045   0.9640    
    ## ref_yearsoutheast-4-1992           -1.586020  32.142683  -0.049   0.9606    
    ## ref_yearsoutheast-4-1993           -1.066050  32.142683  -0.033   0.9735    
    ## ref_yearsoutheast-4-1994           -1.085597  32.317593  -0.034   0.9732    
    ## ref_yearsoutheast-4-1995           -0.539391  32.200119  -0.017   0.9866    
    ## ref_yearsoutheast-4-1996           -1.692310  32.200119  -0.053   0.9581    
    ## ref_yearsoutheast-4-1997           -1.742825  32.258416  -0.054   0.9569    
    ## ref_yearsoutheast-4-1998           -0.273928  32.317593  -0.008   0.9932    
    ## ref_yearsoutheast-4-1999           -1.216672  32.317593  -0.038   0.9700    
    ## ref_yearsoutheast-4-2000           -1.470679  32.086087  -0.046   0.9634    
    ## ref_yearsoutheast-4-2001            0.008575  32.142683   0.000   0.9998    
    ## ref_yearsoutheast-4-2002            0.011712  32.317593   0.000   0.9997    
    ## ref_yearsoutheast-4-2003           -1.032635  32.258416  -0.032   0.9745    
    ## ref_yearsoutheast-4-2004           -0.865181  32.086087  -0.027   0.9785    
    ## ref_yearsoutheast-4-2005           -1.232541  32.142683  -0.038   0.9694    
    ## ref_yearsoutheast-4-2006           -1.674730  32.258416  -0.052   0.9586    
    ## ref_yearsoutheast-4-2007           -0.948353  32.142683  -0.030   0.9765    
    ## ref_yearsoutheast-4-2008           -1.339896  32.086087  -0.042   0.9667    
    ## ref_yearsoutheast-4-2009            0.260632  32.200119   0.008   0.9935    
    ## ref_yearsoutheast-4-2010           -1.287178  32.317593  -0.040   0.9682    
    ## ref_yearsoutheast-4-2011            1.205503  32.258416   0.037   0.9702    
    ## ref_yearsoutheast-4-2012            6.299435  32.142683   0.196   0.8446    
    ## ref_yearsoutheast-4-2013            0.086804  32.142683   0.003   0.9978    
    ## ref_yearsoutheast-4-2014           -1.920266  32.258416  -0.060   0.9525    
    ## ref_yearsoutheast-4-2015            3.844716  32.142683   0.120   0.9048    
    ## ref_yearsoutheast-4-2016           -1.354904  32.030315  -0.042   0.9663    
    ## ref_yearsoutheast-4-2017            4.795939  32.086087   0.149   0.8812    
    ## ref_yearsoutheast-4-2018           -2.562952  32.377671  -0.079   0.9369    
    ## ref_yearwest_coast-5-1986          -1.169193  32.758278  -0.036   0.9715    
    ## ref_yearwest_coast-5-1989           0.235736  32.893389   0.007   0.9943    
    ## ref_yearwest_coast-5-1992           0.752071  32.962606   0.023   0.9818    
    ## ref_yearwest_coast-5-1995          -0.801812  32.962606  -0.024   0.9806    
    ## ref_yearwest_coast-5-1998           1.184625  32.893389   0.036   0.9713    
    ## ref_yearwest_coast-5-2001           2.176274  32.758278   0.066   0.9470    
    ## ref_yearwest_coast-5-2003         142.300594  34.156575   4.166 3.11e-05 ***
    ## ref_yearwest_coast-5-2004           7.013090  29.660301   0.236   0.8131    
    ## ref_yearwest_coast-5-2005          -1.304342  29.531345  -0.044   0.9648    
    ## ref_yearwest_coast-5-2006           2.217721  29.291281   0.076   0.9396    
    ## ref_yearwest_coast-5-2007          11.693787  29.268487   0.400   0.6895    
    ## ref_yearwest_coast-5-2008           0.239379  29.201341   0.008   0.9935    
    ## ref_yearwest_coast-5-2009           5.210300  29.268487   0.178   0.8587    
    ## ref_yearwest_coast-5-2010           2.108304  29.135994   0.072   0.9423    
    ## ref_yearwest_coast-5-2011          10.387882  29.223520   0.355   0.7222    
    ## ref_yearwest_coast-5-2012           4.015369  29.179362   0.138   0.8905    
    ## ref_yearwest_coast-5-2013           6.472912  29.179362   0.222   0.8244    
    ## ref_yearwest_coast-5-2014           3.720788  29.245901   0.127   0.8988    
    ## ref_yearwest_coast-5-2015           2.409235  29.223520   0.082   0.9343    
    ## ref_yearwest_coast-5-2016          -0.522903  29.114598  -0.018   0.9857    
    ## ref_yearwest_coast-5-2017          -1.182081  29.360943  -0.040   0.9679    
    ## ref_yearwest_coast-5-2018           4.604334  29.291281   0.157   0.8751    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 231.6 on 25348 degrees of freedom
    ## Multiple R-squared:  0.009207,   Adjusted R-squared:  0.001741 
    ## F-statistic: 1.233 on 191 and 25348 DF,  p-value: 0.01592

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##   -21.3   -11.8    -5.6    -2.4 20604.1 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                          6.392      9.294   0.688    0.492
    ## anomIntC                             2.652     32.659   0.081    0.935
    ## regioneastern_bering_sea            13.892      9.955   1.395    0.163
    ## regiongulf_of_alaska                -1.604     10.800  -0.149    0.882
    ## regiongulf_of_mexico                 1.422     11.054   0.129    0.898
    ## regionnortheast                     -3.501     11.068  -0.316    0.752
    ## regionscotian_shelf                 -5.348     12.761  -0.419    0.675
    ## regionsoutheast                     -4.651     10.916  -0.426    0.670
    ## regionwest_coast                     5.900     10.446   0.565    0.572
    ## anomIntC:regioneastern_bering_sea  -16.991     35.046  -0.485    0.628
    ## anomIntC:regiongulf_of_alaska        1.712     40.467   0.042    0.966
    ## anomIntC:regiongulf_of_mexico       -5.426     36.405  -0.149    0.882
    ## anomIntC:regionnortheast            -2.534     38.415  -0.066    0.947
    ## anomIntC:regionscotian_shelf        -2.047     41.424  -0.049    0.961
    ## anomIntC:regionsoutheast            -1.679     38.424  -0.044    0.965
    ## anomIntC:regionwest_coast          -27.581     39.196  -0.704    0.482
    ## 
    ## Residual standard error: 231.8 on 25524 degrees of freedom
    ## Multiple R-squared:  0.0007619,  Adjusted R-squared:  0.0001746 
    ## F-statistic: 1.297 on 15 and 25524 DF,  p-value: 0.1937

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##   -20.7   -10.5    -5.9    -2.2 20604.7 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                        8.754920   7.345721   1.192    0.233
    ## anomDays                          -0.097682   0.294920  -0.331    0.740
    ## regioneastern_bering_sea          10.962656   8.096763   1.354    0.176
    ## regiongulf_of_alaska              -2.808019   8.914026  -0.315    0.753
    ## regiongulf_of_mexico               1.724425   9.584746   0.180    0.857
    ## regionnortheast                   -5.545839   8.903840  -0.623    0.533
    ## regionscotian_shelf               -7.559899  10.629703  -0.711    0.477
    ## regionsoutheast                   -6.753851   8.908726  -0.758    0.448
    ## regionwest_coast                   1.317894   8.437669   0.156    0.876
    ## anomDays:regioneastern_bering_sea -0.008061   0.313172  -0.026    0.979
    ## anomDays:regiongulf_of_alaska      0.072077   0.318549   0.226    0.821
    ## anomDays:regiongulf_of_mexico     -0.073003   0.370417  -0.197    0.844
    ## anomDays:regionnortheast           0.080952   0.343927   0.235    0.814
    ## anomDays:regionscotian_shelf       0.096980   0.401684   0.241    0.809
    ## anomDays:regionsoutheast           0.093220   0.376097   0.248    0.804
    ## anomDays:regionwest_coast          0.043461   0.306315   0.142    0.887
    ## 
    ## Residual standard error: 231.8 on 25524 degrees of freedom
    ## Multiple R-squared:  0.0007428,  Adjusted R-squared:  0.0001556 
    ## F-statistic: 1.265 on 15 and 25524 DF,  p-value: 0.215

Other models with region as an interaction:

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##   -20.3   -10.0    -6.1    -2.2 20605.1 
    ## 
    ## Coefficients:
    ##                                  Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                       8.51818    7.28526   1.169    0.242
    ## anomSev                          -0.29611    1.01846  -0.291    0.771
    ## regioneastern_bering_sea         10.81886    7.96899   1.358    0.175
    ## regiongulf_of_alaska             -2.58749    8.74621  -0.296    0.767
    ## regiongulf_of_mexico             -0.03748    8.84309  -0.004    0.997
    ## regionnortheast                  -5.39812    8.55205  -0.631    0.528
    ## regionscotian_shelf              -7.35122   10.55046  -0.697    0.486
    ## regionsoutheast                  -6.47103    8.54892  -0.757    0.449
    ## regionwest_coast                  1.21648    8.33688   0.146    0.884
    ## anomSev:regioneastern_bering_sea  0.15931    1.02636   0.155    0.877
    ## anomSev:regiongulf_of_alaska      0.23056    1.05177   0.219    0.826
    ## anomSev:regiongulf_of_mexico      0.13811    1.06206   0.130    0.897
    ## anomSev:regionnortheast           0.26575    1.06444   0.250    0.803
    ## anomSev:regionscotian_shelf       0.29876    1.19336   0.250    0.802
    ## anomSev:regionsoutheast           0.27570    1.09779   0.251    0.802
    ## anomSev:regionwest_coast          0.21079    1.03076   0.204    0.838
    ## 
    ## Residual standard error: 231.8 on 25524 degrees of freedom
    ## Multiple R-squared:  0.0007311,  Adjusted R-squared:  0.0001439 
    ## F-statistic: 1.245 on 15 and 25524 DF,  p-value: 0.2289

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.3040 -0.7328 -0.2914  0.2868 30.1512 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                       -0.05053    0.04246  -1.190   0.2341  
    ## anomIntC                           0.23729    0.15884   1.494   0.1352  
    ## regioneastern_bering_sea           0.05277    0.04646   1.136   0.2561  
    ## regiongulf_of_alaska               0.00700    0.05052   0.139   0.8898  
    ## regiongulf_of_mexico               0.12930    0.05278   2.450   0.0143 *
    ## regionnortheast                   -0.11706    0.05340  -2.192   0.0284 *
    ## regionscotian_shelf                0.02495    0.06346   0.393   0.6942  
    ## regionsoutheast                    0.04529    0.05233   0.865   0.3868  
    ## regionwest_coast                   0.07610    0.04920   1.547   0.1220  
    ## anomIntC:regioneastern_bering_sea -0.24105    0.17264  -1.396   0.1626  
    ## anomIntC:regiongulf_of_alaska      0.10143    0.20357   0.498   0.6183  
    ## anomIntC:regiongulf_of_mexico     -0.26585    0.18115  -1.468   0.1422  
    ## anomIntC:regionnortheast           0.46853    0.19293   2.429   0.0152 *
    ## anomIntC:regionscotian_shelf      -0.09926    0.21051  -0.471   0.6373  
    ## anomIntC:regionsoutheast          -0.21173    0.19274  -1.099   0.2720  
    ## anomIntC:regionwest_coast         -0.24589    0.19632  -1.252   0.2104  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.267 on 27967 degrees of freedom
    ## Multiple R-squared:  0.002223,   Adjusted R-squared:  0.001688 
    ## F-statistic: 4.154 on 15 and 27967 DF,  p-value: 1.029e-07

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.4521 -0.7315 -0.2909  0.2878 30.1498 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                       -0.026039   0.034953  -0.745 0.456301    
    ## anomDays                           0.001642   0.001496   1.098 0.272321    
    ## regioneastern_bering_sea           0.029736   0.039315   0.756 0.449448    
    ## regiongulf_of_alaska               0.031239   0.043182   0.723 0.469428    
    ## regiongulf_of_mexico               0.197154   0.046565   4.234  2.3e-05 ***
    ## regionnortheast                   -0.066673   0.044257  -1.507 0.131950    
    ## regionscotian_shelf                0.025628   0.054165   0.473 0.636116    
    ## regionsoutheast                    0.057909   0.044060   1.314 0.188751    
    ## regionwest_coast                   0.047875   0.041082   1.165 0.243884    
    ## anomDays:regioneastern_bering_sea -0.001783   0.001598  -1.116 0.264372    
    ## anomDays:regiongulf_of_alaska     -0.001906   0.001629  -1.170 0.241897    
    ## anomDays:regiongulf_of_mexico     -0.007063   0.001906  -3.705 0.000212 ***
    ## anomDays:regionnortheast           0.003055   0.001777   1.719 0.085706 .  
    ## anomDays:regionscotian_shelf      -0.001218   0.002070  -0.588 0.556242    
    ## anomDays:regionsoutheast          -0.004016   0.001953  -2.057 0.039714 *  
    ## anomDays:regionwest_coast         -0.001513   0.001561  -0.969 0.332428    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.267 on 27967 degrees of freedom
    ## Multiple R-squared:  0.002156,   Adjusted R-squared:  0.001621 
    ## F-statistic: 4.029 on 15 and 27967 DF,  p-value: 2.162e-07

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.4732 -0.7339 -0.2911  0.2886 30.1536 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)                      -0.015369   0.034603  -0.444  0.65694   
    ## anomSev                           0.003420   0.005161   0.663  0.50759   
    ## regioneastern_bering_sea          0.015266   0.038588   0.396  0.69238   
    ## regiongulf_of_alaska              0.024986   0.042169   0.593  0.55350   
    ## regiongulf_of_mexico              0.111922   0.042871   2.611  0.00904 **
    ## regionnortheast                  -0.045181   0.042187  -1.071  0.28419   
    ## regionscotian_shelf               0.007132   0.053810   0.133  0.89456   
    ## regionsoutheast                   0.054936   0.041951   1.310  0.19036   
    ## regionwest_coast                  0.036739   0.040489   0.907  0.36422   
    ## anomSev:regioneastern_bering_sea -0.003199   0.005206  -0.615  0.53883   
    ## anomSev:regiongulf_of_alaska     -0.004777   0.005348  -0.893  0.37177   
    ## anomSev:regiongulf_of_mexico     -0.006557   0.005406  -1.213  0.22515   
    ## anomSev:regionnortheast           0.004061   0.005428   0.748  0.45434   
    ## anomSev:regionscotian_shelf      -0.001227   0.006151  -0.199  0.84192   
    ## anomSev:regionsoutheast          -0.011146   0.005609  -1.987  0.04693 * 
    ## anomSev:regionwest_coast         -0.003068   0.005231  -0.586  0.55755   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.267 on 27967 degrees of freedom
    ## Multiple R-squared:  0.001724,   Adjusted R-squared:  0.001189 
    ## F-statistic:  3.22 on 15 and 27967 DF,  p-value: 2.294e-05
