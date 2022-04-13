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
    ## REML criterion at convergence: 468.8
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.9055 -0.5259 -0.1617  0.2883 10.1447 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr
    ##  region   (Intercept) 0.000e+00 0.000e+00     
    ##           anomIntC    1.972e-17 4.440e-09  NaN
    ##  Residual             1.878e-01 4.334e-01     
    ## Number of obs: 398, groups:  region, 17
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  0.08075    0.02172   3.717
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtAnomProp ~ anomIntC + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 415.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.9222 -0.6295 -0.1029  0.4116  7.1581 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr
    ##  region   (Intercept) 0.000e+00 0.000e+00     
    ##           anomIntC    1.445e-14 1.202e-07  NaN
    ##  Residual             1.573e-01 3.966e-01     
    ## Number of obs: 415, groups:  region, 17
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error t value
    ## (Intercept) 5.647e-16  1.947e-02       0
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtDiffProp ~ mhwYesNo + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 467.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.2194 -0.5412 -0.1622  0.3025  9.9573 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev. Corr 
    ##  region   (Intercept) 0.007909 0.08893       
    ##           mhwYesNoyes 0.012758 0.11295  -1.00
    ##  Residual             0.183955 0.42890       
    ## Number of obs: 398, groups:  region, 17
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)  0.07478    0.02252    3.32
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: wtMtAnomProp ~ mhwYesNo + 1 | region
    ##    Data: .
    ## 
    ## REML criterion at convergence: 415.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.9222 -0.6295 -0.1029  0.4116  7.1581 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance  Std.Dev.  Corr
    ##  region   (Intercept) 0.000e+00 0.000e+00     
    ##           mhwYesNoyes 1.830e-12 1.353e-06  NaN
    ##  Residual             1.573e-01 3.966e-01     
    ## Number of obs: 415, groups:  region, 17
    ## 
    ## Fixed effects:
    ##               Estimate Std. Error t value
    ## (Intercept) -4.810e-13  1.947e-02       0
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see ?isSingular

### MHW yes/no

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ mhwYesNo, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.8569 -0.2271 -0.0787  0.1229  4.3656 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  0.11183    0.03183   3.513 0.000494 ***
    ## mhwYesNoyes -0.05807    0.04351  -1.335 0.182774    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.433 on 396 degrees of freedom
    ##   (17 observations deleted due to missingness)
    ## Multiple R-squared:  0.004478,   Adjusted R-squared:  0.001964 
    ## F-statistic: 1.781 on 1 and 396 DF,  p-value: 0.1828

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ mhwYesNo, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.7622 -0.2497 -0.0407  0.1631  2.8387 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)  0.0001495  0.0286558   0.005    0.996
    ## mhwYesNoyes -0.0002782  0.0390916  -0.007    0.994
    ## 
    ## Residual standard error: 0.3971 on 413 degrees of freedom
    ## Multiple R-squared:  1.226e-07,  Adjusted R-squared:  -0.002421 
    ## F-statistic: 5.064e-05 on 1 and 413 DF,  p-value: 0.9943

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.76999 -0.23342 -0.03184  0.15415  2.72197 
    ## 
    ## Coefficients:
    ##                                      Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                          -0.11382    0.20316  -0.560   0.5756  
    ## mhwYesNoyes                           0.15935    0.24038   0.663   0.5078  
    ## regionbits                            0.09678    0.24417   0.396   0.6921  
    ## regioneastern_bering_sea              0.08406    0.21944   0.383   0.7019  
    ## regionevhoe                           0.16122    0.24882   0.648   0.5174  
    ## regionfr_cgfs                         0.17125    0.23036   0.743   0.4577  
    ## regiongulf_of_alaska                  0.08573    0.24882   0.345   0.7306  
    ## regiongulf_of_mexico                  0.03439    0.27257   0.126   0.8997  
    ## regionie_igfs                         0.17106    0.26228   0.652   0.5147  
    ## regionnorbts                          0.09984    0.24038   0.415   0.6781  
    ## regionnortheast                      -0.01417    0.22865  -0.062   0.9506  
    ## regionns_ibts                         0.16617    0.22580   0.736   0.4622  
    ## regionpt_ibts                        -0.04806    0.27257  -0.176   0.8601  
    ## regionrockall                         0.33230    0.26228   1.267   0.2059  
    ## regionscotian_shelf                   0.11647    0.22460   0.519   0.6044  
    ## regionsoutheast                       0.08991    0.22865   0.393   0.6944  
    ## regionswc_ibts                        0.07680    0.23459   0.327   0.7435  
    ## regionwest_coast                      0.23067    0.22714   1.016   0.3105  
    ## mhwYesNoyes:regionbits               -0.13464    0.29049  -0.464   0.6433  
    ## mhwYesNoyes:regioneastern_bering_sea -0.07008    0.28004  -0.250   0.8025  
    ## mhwYesNoyes:regionevhoe              -0.23045    0.29789  -0.774   0.4396  
    ## mhwYesNoyes:regionfr_cgfs            -0.30612    0.29652  -1.032   0.3025  
    ## mhwYesNoyes:regiongulf_of_alaska     -0.09380    0.32548  -0.288   0.7734  
    ## mhwYesNoyes:regiongulf_of_mexico     -0.01374    0.34398  -0.040   0.9682  
    ## mhwYesNoyes:regionie_igfs            -0.24521    0.31474  -0.779   0.4364  
    ## mhwYesNoyes:regionnorbts             -0.11041    0.33996  -0.325   0.7455  
    ## mhwYesNoyes:regionnortheast           0.05590    0.27622   0.202   0.8397  
    ## mhwYesNoyes:regionns_ibts            -0.25408    0.27451  -0.926   0.3553  
    ## mhwYesNoyes:regionpt_ibts             0.09246    0.33038   0.280   0.7797  
    ## mhwYesNoyes:regionrockall            -0.47867    0.31305  -1.529   0.1271  
    ## mhwYesNoyes:regionscotian_shelf      -0.16499    0.27798  -0.594   0.5532  
    ## mhwYesNoyes:regionsoutheast          -0.11153    0.28249  -0.395   0.6932  
    ## mhwYesNoyes:regionswc_ibts           -0.10383    0.28004  -0.371   0.7110  
    ## mhwYesNoyes:regionwest_coast         -0.50989    0.29789  -1.712   0.0878 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4063 on 381 degrees of freedom
    ## Multiple R-squared:  0.03396,    Adjusted R-squared:  -0.04971 
    ## F-statistic: 0.4059 on 33 and 381 DF,  p-value: 0.9988

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.1319 -0.2275 -0.0443  0.1508  4.0907 
    ## 
    ## Coefficients:
    ##                                       Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                           0.137000   0.251881   0.544    0.587
    ## mhwYesNoyes                          -0.083166   0.287189  -0.290    0.772
    ## regionbits                           -0.067724   0.295357  -0.229    0.819
    ## regioneastern_bering_sea             -0.114150   0.267805  -0.426    0.670
    ## regionevhoe                           0.030639   0.295357   0.104    0.917
    ## regionfr_cgfs                         0.105178   0.277559   0.379    0.705
    ## regiongulf_of_alaska                 -0.099409   0.295357  -0.337    0.737
    ## regiongulf_of_mexico                 -0.070742   0.333207  -0.212    0.832
    ## regionie_igfs                        -0.170011   0.308490  -0.551    0.582
    ## regionnorbts                          0.313447   0.290847   1.078    0.282
    ## regionnortheast                      -0.111947   0.275922  -0.406    0.685
    ## regionns_ibts                        -0.078510   0.273203  -0.287    0.774
    ## regionpt_ibts                        -0.250651   0.333207  -0.752    0.452
    ## regionrockall                         0.001351   0.308490   0.004    0.997
    ## regionscotian_shelf                  -0.177577   0.272063  -0.653    0.514
    ## regionsoutheast                      -0.072203   0.277559  -0.260    0.795
    ## regionswc_ibts                        0.024118   0.281612   0.086    0.932
    ## regionwest_coast                      0.249792   0.274481   0.910    0.363
    ## mhwYesNoyes:regionbits                0.073780   0.340273   0.217    0.828
    ## mhwYesNoyes:regioneastern_bering_sea  0.066220   0.326517   0.203    0.839
    ## mhwYesNoyes:regionevhoe              -0.061520   0.344902  -0.178    0.859
    ## mhwYesNoyes:regionfr_cgfs            -0.173121   0.346214  -0.500    0.617
    ## mhwYesNoyes:regiongulf_of_alaska      0.057462   0.379915   0.151    0.880
    ## mhwYesNoyes:regiongulf_of_mexico     -0.018991   0.402222  -0.047    0.962
    ## mhwYesNoyes:regionie_igfs             0.183854   0.362632   0.507    0.612
    ## mhwYesNoyes:regionnorbts             -0.450888   0.388855  -1.160    0.247
    ## mhwYesNoyes:regionnortheast           0.102059   0.322846   0.316    0.752
    ## mhwYesNoyes:regionns_ibts             0.046540   0.321232   0.145    0.885
    ## mhwYesNoyes:regionpt_ibts             0.556040   0.388855   1.430    0.154
    ## mhwYesNoyes:regionrockall             0.024050   0.360639   0.067    0.947
    ## mhwYesNoyes:regionscotian_shelf       0.233183   0.325177   0.717    0.474
    ## mhwYesNoyes:regionsoutheast           0.085854   0.329790   0.260    0.795
    ## mhwYesNoyes:regionswc_ibts           -0.017554   0.326517  -0.054    0.957
    ## mhwYesNoyes:regionwest_coast         -0.364946   0.348659  -1.047    0.296
    ## 
    ## Residual standard error: 0.4363 on 364 degrees of freedom
    ##   (17 observations deleted due to missingness)
    ## Multiple R-squared:  0.07093,    Adjusted R-squared:  -0.0133 
    ## F-statistic: 0.8421 on 33 and 364 DF,  p-value: 0.7189

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##   -372    -10     -5     -2 202474 
    ## 
    ## Coefficients:
    ##                                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                             4.68634   49.52939   0.095 0.924619    
    ## mhwYesNoyes                             1.44973   56.06821   0.026 0.979372    
    ## regionbits                              1.03851   72.03569   0.014 0.988498    
    ## regioneastern_bering_sea               16.87844   52.32983   0.323 0.747046    
    ## regionevhoe                            -0.08394   59.51093  -0.001 0.998875    
    ## regionfr_cgfs                          -2.72862   63.54185  -0.043 0.965748    
    ## regiongulf_of_alaska                   -0.76152   55.74261  -0.014 0.989100    
    ## regiongulf_of_mexico                    1.28430   57.38939   0.022 0.982146    
    ## regionie_igfs                           7.32755   65.69669   0.112 0.911192    
    ## regionnorbts                          365.99187   66.01757   5.544 2.98e-08 ***
    ## regionnortheast                        -3.34082   56.72884  -0.059 0.953039    
    ## regionns_ibts                           4.67108   55.71810   0.084 0.933189    
    ## regionpt_ibts                          -2.34849   77.36943  -0.030 0.975785    
    ## regionrockall                          -3.85842   83.56347  -0.046 0.963172    
    ## regionscotian_shelf                    -3.98138   63.65128  -0.063 0.950125    
    ## regionsoutheast                        -3.13411   55.70418  -0.056 0.955132    
    ## regionswc_ibts                          2.68757   61.46532   0.044 0.965124    
    ## regionwest_coast                        5.74283   53.28649   0.108 0.914176    
    ## mhwYesNoyes:regionbits                 -0.49351   83.85202  -0.006 0.995304    
    ## mhwYesNoyes:regioneastern_bering_sea  -12.11010   63.17915  -0.192 0.847995    
    ## mhwYesNoyes:regionevhoe                -2.92430   69.56912  -0.042 0.966471    
    ## mhwYesNoyes:regionfr_cgfs              -1.28325   87.05360  -0.015 0.988239    
    ## mhwYesNoyes:regiongulf_of_alaska        2.47468   68.78634   0.036 0.971301    
    ## mhwYesNoyes:regiongulf_of_mexico       -5.52065   67.30622  -0.082 0.934629    
    ## mhwYesNoyes:regionie_igfs              -3.16909   77.49983  -0.041 0.967382    
    ## mhwYesNoyes:regionnorbts             -365.76655   94.81456  -3.858 0.000115 ***
    ## mhwYesNoyes:regionnortheast            -1.17753   66.59388  -0.018 0.985892    
    ## mhwYesNoyes:regionns_ibts               1.58122   65.74660   0.024 0.980813    
    ## mhwYesNoyes:regionpt_ibts               3.46968   91.07020   0.038 0.969609    
    ## mhwYesNoyes:regionrockall              65.43155  100.74100   0.650 0.516017    
    ## mhwYesNoyes:regionscotian_shelf        -0.45912   80.87283  -0.006 0.995470    
    ## mhwYesNoyes:regionsoutheast            -0.55431   66.33186  -0.008 0.993332    
    ## mhwYesNoyes:regionswc_ibts             -4.47182   71.69848  -0.062 0.950269    
    ## mhwYesNoyes:regionwest_coast           -9.50237   67.00787  -0.142 0.887231    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1045 on 41735 degrees of freedom
    ## Multiple R-squared:  0.001697,   Adjusted R-squared:  0.0009072 
    ## F-statistic: 2.149 on 33 and 41735 DF,  p-value: 0.0001395

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ mhwYesNo + mhwYesNo * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -1.328 -0.909 -0.529  0.143 38.091 
    ## 
    ## Coefficients:
    ##                                       Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)                          -0.039826   0.088176  -0.452  0.65151   
    ## mhwYesNoyes                           0.055756   0.104331   0.534  0.59305   
    ## regionbits                            0.112656   0.116917   0.964  0.33528   
    ## regioneastern_bering_sea              0.038567   0.095360   0.404  0.68589   
    ## regionevhoe                           0.227917   0.104504   2.181  0.02919 * 
    ## regionfr_cgfs                         0.081001   0.116014   0.698  0.48506   
    ## regiongulf_of_alaska                 -0.001046   0.103039  -0.010  0.99190   
    ## regiongulf_of_mexico                  0.001603   0.104726   0.015  0.98779   
    ## regionie_igfs                        -0.198445   0.111789  -1.775  0.07588 . 
    ## regionnorbts                         -0.091543   0.111179  -0.823  0.41029   
    ## regionnortheast                      -0.138797   0.107033  -1.297  0.19472   
    ## regionns_ibts                        -0.051270   0.096822  -0.530  0.59644   
    ## regionpt_ibts                        -0.182190   0.136373  -1.336  0.18156   
    ## regionrockall                        -0.082869   0.139599  -0.594  0.55277   
    ## regionscotian_shelf                   0.013804   0.124432   0.111  0.91167   
    ## regionsoutheast                       0.029547   0.103479   0.286  0.77523   
    ## regionswc_ibts                       -0.011417   0.106292  -0.107  0.91446   
    ## regionwest_coast                      0.078376   0.097628   0.803  0.42209   
    ## mhwYesNoyes:regionbits               -0.161359   0.139400  -1.158  0.24706   
    ## mhwYesNoyes:regioneastern_bering_sea -0.047161   0.121822  -0.387  0.69866   
    ## mhwYesNoyes:regionevhoe              -0.337893   0.124916  -2.705  0.00683 **
    ## mhwYesNoyes:regionfr_cgfs            -0.160980   0.159409  -1.010  0.31257   
    ## mhwYesNoyes:regiongulf_of_alaska      0.039611   0.132350   0.299  0.76472   
    ## mhwYesNoyes:regiongulf_of_mexico      0.014320   0.129375   0.111  0.91187   
    ## mhwYesNoyes:regionie_igfs             0.301651   0.134044   2.250  0.02443 * 
    ## mhwYesNoyes:regionnorbts              0.404035   0.164121   2.462  0.01383 * 
    ## mhwYesNoyes:regionnortheast           0.248660   0.130788   1.901  0.05727 . 
    ## mhwYesNoyes:regionns_ibts             0.121669   0.117386   1.036  0.29998   
    ## mhwYesNoyes:regionpt_ibts             0.289602   0.166494   1.739  0.08197 . 
    ## mhwYesNoyes:regionrockall             0.123568   0.167343   0.738  0.46027   
    ## mhwYesNoyes:regionscotian_shelf       0.002855   0.165123   0.017  0.98621   
    ## mhwYesNoyes:regionsoutheast          -0.035171   0.129456  -0.272  0.78586   
    ## mhwYesNoyes:regionswc_ibts            0.021108   0.127159   0.166  0.86816   
    ## mhwYesNoyes:regionwest_coast         -0.186808   0.129830  -1.439  0.15019   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.326 on 58401 degrees of freedom
    ## Multiple R-squared:  0.001568,   Adjusted R-squared:  0.001004 
    ## F-statistic:  2.78 on 33 and 58401 DF,  p-value: 1.991e-07

### Net change in biomass

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.8622 -0.2276 -0.0802  0.1297  4.3420 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  0.13546    0.02948   4.595 5.82e-06 ***
    ## anomIntC    -0.23484    0.08634  -2.720  0.00681 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4299 on 396 degrees of freedom
    ##   (17 observations deleted due to missingness)
    ## Multiple R-squared:  0.01834,    Adjusted R-squared:  0.01586 
    ## F-statistic: 7.399 on 1 and 396 DF,  p-value: 0.006815

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomIntC, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.78000 -0.24915 -0.03951  0.16261  2.84238 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)
    ## (Intercept) -0.003559   0.026694  -0.133    0.894
    ## anomIntC     0.015413   0.078997   0.195    0.845
    ## 
    ## Residual standard error: 0.397 on 413 degrees of freedom
    ## Multiple R-squared:  9.217e-05,  Adjusted R-squared:  -0.002329 
    ## F-statistic: 0.03807 on 1 and 413 DF,  p-value: 0.8454

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.0528 -0.2155 -0.0534  0.1484  4.0796 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                        0.080186   0.211818   0.379   0.7052  
    ## anomIntC                          -0.031223   0.763532  -0.041   0.9674  
    ## regionbits                         0.138038   0.256014   0.539   0.5901  
    ## regioneastern_bering_sea          -0.016265   0.228322  -0.071   0.9432  
    ## regionevhoe                        0.230643   0.281873   0.818   0.4137  
    ## regionfr_cgfs                     -0.008035   0.248079  -0.032   0.9742  
    ## regiongulf_of_alaska              -0.009541   0.258808  -0.037   0.9706  
    ## regiongulf_of_mexico               0.002777   0.278050   0.010   0.9920  
    ## regionie_igfs                     -0.097795   0.264084  -0.370   0.7114  
    ## regionnorbts                       0.434815   0.259807   1.674   0.0951 .
    ## regionnortheast                   -0.069571   0.238379  -0.292   0.7706  
    ## regionns_ibts                     -0.006566   0.232862  -0.028   0.9775  
    ## regionpt_ibts                     -0.196063   0.294397  -0.666   0.5058  
    ## regionrockall                      0.228980   0.258904   0.884   0.3771  
    ## regionscotian_shelf               -0.041341   0.234471  -0.176   0.8601  
    ## regionsoutheast                    0.040064   0.241643   0.166   0.8684  
    ## regionswc_ibts                     0.147619   0.240788   0.613   0.5402  
    ## regionwest_coast                   0.317683   0.239298   1.328   0.1852  
    ## anomIntC:regionbits               -0.246923   0.792426  -0.312   0.7555  
    ## anomIntC:regioneastern_bering_sea -0.285948   0.820918  -0.348   0.7278  
    ## anomIntC:regionevhoe              -0.817568   0.960208  -0.851   0.3951  
    ## anomIntC:regionfr_cgfs             0.619496   1.033622   0.599   0.5493  
    ## anomIntC:regiongulf_of_alaska     -0.291919   1.015226  -0.288   0.7739  
    ## anomIntC:regiongulf_of_mexico     -0.299074   0.912981  -0.328   0.7434  
    ## anomIntC:regionie_igfs             0.222359   0.888680   0.250   0.8026  
    ## anomIntC:regionnorbts             -1.746006   1.044445  -1.672   0.0954 .
    ## anomIntC:regionnortheast           0.142679   0.844881   0.169   0.8660  
    ## anomIntC:regionns_ibts            -0.109767   0.808773  -0.136   0.8921  
    ## anomIntC:regionpt_ibts             1.127509   0.942467   1.196   0.2323  
    ## anomIntC:regionrockall            -0.676563   0.847286  -0.799   0.4251  
    ## anomIntC:regionscotian_shelf      -0.017724   0.817717  -0.022   0.9827  
    ## anomIntC:regionsoutheast          -0.231226   0.866942  -0.267   0.7898  
    ## anomIntC:regionswc_ibts           -0.711493   0.909811  -0.782   0.4347  
    ## anomIntC:regionwest_coast         -1.118864   0.921152  -1.215   0.2253  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4298 on 364 degrees of freedom
    ##   (17 observations deleted due to missingness)
    ## Multiple R-squared:  0.09831,    Adjusted R-squared:  0.01656 
    ## F-statistic: 1.203 on 33 and 364 DF,  p-value: 0.2101

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.81176 -0.22157 -0.04429  0.14175  2.76006 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                       -0.161845   0.178429  -0.907   0.3650  
    ## anomIntC                           0.760052   0.667456   1.139   0.2555  
    ## regionbits                         0.195841   0.220312   0.889   0.3746  
    ## regioneastern_bering_sea           0.151303   0.194939   0.776   0.4381  
    ## regionevhoe                        0.329107   0.249624   1.318   0.1882  
    ## regionfr_cgfs                     -0.030748   0.214912  -0.143   0.8863  
    ## regiongulf_of_alaska               0.139893   0.223471   0.626   0.5317  
    ## regiongulf_of_mexico               0.148626   0.241813   0.615   0.5392  
    ## regionie_igfs                      0.141674   0.230512   0.615   0.5392  
    ## regionnorbts                       0.169501   0.222753   0.761   0.4472  
    ## regionnortheast                    0.001921   0.205508   0.009   0.9925  
    ## regionns_ibts                      0.216828   0.200203   1.083   0.2795  
    ## regionpt_ibts                      0.019506   0.248799   0.078   0.9376  
    ## regionrockall                      0.314295   0.224735   1.399   0.1628  
    ## regionscotian_shelf                0.170959   0.201587   0.848   0.3969  
    ## regionsoutheast                    0.165864   0.208603   0.795   0.4270  
    ## regionswc_ibts                     0.087212   0.208180   0.419   0.6755  
    ## regionwest_coast                   0.240600   0.206503   1.165   0.2447  
    ## anomIntC:regionbits               -0.822664   0.695047  -1.184   0.2373  
    ## anomIntC:regioneastern_bering_sea -0.686694   0.724472  -0.948   0.3438  
    ## anomIntC:regionevhoe              -1.352497   0.861786  -1.569   0.1174  
    ## anomIntC:regionfr_cgfs             0.718035   0.934629   0.768   0.4428  
    ## anomIntC:regiongulf_of_alaska     -0.589227   0.914896  -0.644   0.5199  
    ## anomIntC:regiongulf_of_mexico     -0.702995   0.815974  -0.862   0.3895  
    ## anomIntC:regionie_igfs            -0.682235   0.792330  -0.861   0.3898  
    ## anomIntC:regionnorbts             -0.824074   0.935534  -0.881   0.3789  
    ## anomIntC:regionnortheast          -0.058406   0.748910  -0.078   0.9379  
    ## anomIntC:regionns_ibts            -0.973764   0.710831  -1.370   0.1715  
    ## anomIntC:regionpt_ibts            -0.250199   0.825789  -0.303   0.7621  
    ## anomIntC:regionrockall            -1.281901   0.750851  -1.707   0.0886 .
    ## anomIntC:regionscotian_shelf      -0.799612   0.721825  -1.108   0.2687  
    ## anomIntC:regionsoutheast          -0.779652   0.770775  -1.012   0.3124  
    ## anomIntC:regionswc_ibts           -0.355827   0.806322  -0.441   0.6592  
    ## anomIntC:regionwest_coast         -1.358599   0.823169  -1.650   0.0997 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4036 on 381 degrees of freedom
    ## Multiple R-squared:  0.04675,    Adjusted R-squared:  -0.03582 
    ## F-statistic: 0.5662 on 33 and 381 DF,  p-value: 0.9757

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.75971 -0.22962 -0.04627  0.15546  2.79935 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                       -0.0588836  0.1475822  -0.399   0.6901  
    ## anomDays                           0.0037134  0.0063159   0.588   0.5569  
    ## regionbits                         0.0628055  0.1805220   0.348   0.7281  
    ## regioneastern_bering_sea           0.0523749  0.1656980   0.316   0.7521  
    ## regionevhoe                        0.0433547  0.1913632   0.227   0.8209  
    ## regionfr_cgfs                      0.0924098  0.1773378   0.521   0.6026  
    ## regiongulf_of_alaska               0.0529503  0.1935440   0.274   0.7846  
    ## regiongulf_of_mexico               0.1044660  0.2180182   0.479   0.6321  
    ## regionie_igfs                      0.0817676  0.2012461   0.406   0.6847  
    ## regionnorbts                       0.0051910  0.1927104   0.027   0.9785  
    ## regionnortheast                   -0.0221770  0.1706559  -0.130   0.8967  
    ## regionns_ibts                      0.0914096  0.1705190   0.536   0.5922  
    ## regionpt_ibts                     -0.0656651  0.2255534  -0.291   0.7711  
    ## regionrockall                      0.3780176  0.2106050   1.795   0.0735 .
    ## regionscotian_shelf                0.0570366  0.1691805   0.337   0.7362  
    ## regionsoutheast                    0.1184916  0.1756295   0.675   0.5003  
    ## regionswc_ibts                     0.0700786  0.1776515   0.394   0.6935  
    ## regionwest_coast                   0.0983475  0.1735133   0.567   0.5712  
    ## anomDays:regionbits               -0.0039240  0.0073961  -0.531   0.5960  
    ## anomDays:regioneastern_bering_sea -0.0032530  0.0067397  -0.483   0.6296  
    ## anomDays:regionevhoe              -0.0027553  0.0083837  -0.329   0.7426  
    ## anomDays:regionfr_cgfs            -0.0062499  0.0073684  -0.848   0.3969  
    ## anomDays:regiongulf_of_alaska     -0.0034124  0.0070711  -0.483   0.6297  
    ## anomDays:regiongulf_of_mexico     -0.0058934  0.0080366  -0.733   0.4638  
    ## anomDays:regionie_igfs            -0.0050379  0.0084844  -0.594   0.5530  
    ## anomDays:regionnorbts             -0.0015408  0.0067673  -0.228   0.8200  
    ## anomDays:regionnortheast           0.0008447  0.0070037   0.121   0.9041  
    ## anomDays:regionns_ibts            -0.0055918  0.0070560  -0.792   0.4286  
    ## anomDays:regionpt_ibts             0.0020604  0.0087843   0.235   0.8147  
    ## anomDays:regionrockall            -0.0201013  0.0087514  -2.297   0.0222 *
    ## anomDays:regionscotian_shelf      -0.0035953  0.0069335  -0.519   0.6044  
    ## anomDays:regionsoutheast          -0.0081507  0.0077292  -1.055   0.2923  
    ## anomDays:regionswc_ibts           -0.0043613  0.0075726  -0.576   0.5650  
    ## anomDays:regionwest_coast         -0.0054870  0.0065471  -0.838   0.4025  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4056 on 381 degrees of freedom
    ## Multiple R-squared:  0.03747,    Adjusted R-squared:  -0.0459 
    ## F-statistic: 0.4495 on 33 and 381 DF,  p-value: 0.9967

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.0616 -0.2251 -0.0583  0.1412  4.1544 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                        1.315e-01  1.716e-01   0.766    0.444
    ## anomDays                          -3.424e-03  7.078e-03  -0.484    0.629
    ## regionbits                        -4.636e-02  2.072e-01  -0.224    0.823
    ## regioneastern_bering_sea          -6.897e-02  1.907e-01  -0.362    0.718
    ## regionevhoe                       -5.250e-02  2.166e-01  -0.242    0.809
    ## regionfr_cgfs                      2.804e-02  2.027e-01   0.138    0.890
    ## regiongulf_of_alaska              -6.627e-02  2.215e-01  -0.299    0.765
    ## regiongulf_of_mexico              -5.330e-02  2.508e-01  -0.213    0.832
    ## regionie_igfs                     -1.605e-01  2.313e-01  -0.694    0.488
    ## regionnorbts                       2.734e-01  2.221e-01   1.231    0.219
    ## regionnortheast                   -8.306e-02  1.952e-01  -0.425    0.671
    ## regionns_ibts                     -4.995e-02  1.953e-01  -0.256    0.798
    ## regionpt_ibts                     -6.711e-02  2.663e-01  -0.252    0.801
    ## regionrockall                     -2.865e-02  2.412e-01  -0.119    0.905
    ## regionscotian_shelf               -1.251e-01  1.944e-01  -0.643    0.520
    ## regionsoutheast                   -2.621e-02  2.010e-01  -0.130    0.896
    ## regionswc_ibts                     3.225e-02  2.023e-01   0.159    0.873
    ## regionwest_coast                   1.916e-01  1.988e-01   0.963    0.336
    ## anomDays:regionbits                2.250e-03  8.243e-03   0.273    0.785
    ## anomDays:regioneastern_bering_sea  2.961e-04  7.526e-03   0.039    0.969
    ## anomDays:regionevhoe               3.062e-03  9.298e-03   0.329    0.742
    ## anomDays:regionfr_cgfs             2.612e-03  8.188e-03   0.319    0.750
    ## anomDays:regiongulf_of_alaska      1.548e-03  7.873e-03   0.197    0.844
    ## anomDays:regiongulf_of_mexico      7.987e-05  8.920e-03   0.009    0.993
    ## anomDays:regionie_igfs             7.532e-03  1.036e-02   0.727    0.468
    ## anomDays:regionnorbts             -1.040e-03  7.563e-03  -0.138    0.891
    ## anomDays:regionnortheast           2.715e-03  7.807e-03   0.348    0.728
    ## anomDays:regionns_ibts             9.350e-04  7.857e-03   0.119    0.905
    ## anomDays:regionpt_ibts             9.853e-03  9.972e-03   0.988    0.324
    ## anomDays:regionrockall             3.230e-03  9.723e-03   0.332    0.740
    ## anomDays:regionscotian_shelf       5.025e-03  8.017e-03   0.627    0.531
    ## anomDays:regionsoutheast           5.389e-04  8.569e-03   0.063    0.950
    ## anomDays:regionswc_ibts           -6.790e-04  8.445e-03  -0.080    0.936
    ## anomDays:regionwest_coast          1.144e-04  7.321e-03   0.016    0.988
    ## 
    ## Residual standard error: 0.4394 on 364 degrees of freedom
    ##   (17 observations deleted due to missingness)
    ## Multiple R-squared:  0.0577, Adjusted R-squared:  -0.02773 
    ## F-statistic: 0.6754 on 33 and 364 DF,  p-value: 0.9148

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.71857 -0.23728 -0.04595  0.15286  2.81262 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                      -0.0746224  0.1468591  -0.508    0.612
    ## anomSev                           0.0166044  0.0219044   0.758    0.449
    ## regionbits                        0.0961149  0.1767159   0.544    0.587
    ## regioneastern_bering_sea          0.0717570  0.1634933   0.439    0.661
    ## regionevhoe                       0.0941631  0.1833357   0.514    0.608
    ## regionfr_cgfs                     0.0821697  0.1731458   0.475    0.635
    ## regiongulf_of_alaska              0.0749122  0.1894150   0.395    0.693
    ## regiongulf_of_mexico              0.1009754  0.2095612   0.482    0.630
    ## regionie_igfs                     0.0679025  0.1930820   0.352    0.725
    ## regionnorbts                      0.0359373  0.1894021   0.190    0.850
    ## regionnortheast                   0.0229708  0.1654560   0.139    0.890
    ## regionns_ibts                     0.1050326  0.1689110   0.622    0.534
    ## regionpt_ibts                     0.0005649  0.2062646   0.003    0.998
    ## regionrockall                     0.2308022  0.1931791   1.195    0.233
    ## regionscotian_shelf               0.0876670  0.1685931   0.520    0.603
    ## regionsoutheast                   0.1282481  0.1694823   0.757    0.450
    ## regionswc_ibts                    0.0638051  0.1719607   0.371    0.711
    ## regionwest_coast                  0.1008199  0.1717977   0.587    0.558
    ## anomSev:regionbits               -0.0181317  0.0223525  -0.811    0.418
    ## anomSev:regioneastern_bering_sea -0.0162534  0.0220898  -0.736    0.462
    ## anomSev:regionevhoe              -0.0198214  0.0248691  -0.797    0.426
    ## anomSev:regionfr_cgfs            -0.0186036  0.0237227  -0.784    0.433
    ## anomSev:regiongulf_of_alaska     -0.0166453  0.0229842  -0.724    0.469
    ## anomSev:regiongulf_of_mexico     -0.0196216  0.0239709  -0.819    0.414
    ## anomSev:regionie_igfs            -0.0156260  0.0248412  -0.629    0.530
    ## anomSev:regionnorbts             -0.0125540  0.0225039  -0.558    0.577
    ## anomSev:regionnortheast          -0.0089969  0.0225457  -0.399    0.690
    ## anomSev:regionns_ibts            -0.0209322  0.0230697  -0.907    0.365
    ## anomSev:regionpt_ibts            -0.0089662  0.0240127  -0.373    0.709
    ## anomSev:regionrockall            -0.0387787  0.0249177  -1.556    0.120
    ## anomSev:regionscotian_shelf      -0.0185828  0.0229131  -0.811    0.418
    ## anomSev:regionsoutheast          -0.0270690  0.0232651  -1.163    0.245
    ## anomSev:regionswc_ibts           -0.0143304  0.0250869  -0.571    0.568
    ## anomSev:regionwest_coast         -0.0193117  0.0221513  -0.872    0.384
    ## 
    ## Residual standard error: 0.4078 on 381 degrees of freedom
    ## Multiple R-squared:  0.02707,    Adjusted R-squared:  -0.0572 
    ## F-statistic: 0.3212 on 33 and 381 DF,  p-value: 0.9999

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.0511 -0.2347 -0.0557  0.1527  4.1705 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                       0.128158   0.168886   0.759    0.448
    ## anomSev                          -0.011391   0.024273  -0.469    0.639
    ## regionbits                        0.003225   0.200801   0.016    0.987
    ## regioneastern_bering_sea         -0.076628   0.186157  -0.412    0.681
    ## regionevhoe                      -0.011697   0.206253  -0.057    0.955
    ## regionfr_cgfs                     0.023903   0.196558   0.122    0.903
    ## regiongulf_of_alaska             -0.065959   0.215529  -0.306    0.760
    ## regiongulf_of_mexico             -0.050793   0.239963  -0.212    0.832
    ## regionie_igfs                    -0.131319   0.216000  -0.608    0.544
    ## regionnorbts                      0.258862   0.215724   1.200    0.231
    ## regionnortheast                  -0.076886   0.188034  -0.409    0.683
    ## regionns_ibts                    -0.050536   0.191240  -0.264    0.792
    ## regionpt_ibts                    -0.002849   0.236964  -0.012    0.990
    ## regionrockall                     0.087156   0.219426   0.397    0.691
    ## regionscotian_shelf              -0.093812   0.190828  -0.492    0.623
    ## regionsoutheast                  -0.026016   0.192542  -0.135    0.893
    ## regionswc_ibts                    0.034283   0.194300   0.176    0.860
    ## regionwest_coast                  0.178750   0.195077   0.916    0.360
    ## anomSev:regionbits                0.006668   0.024750   0.269    0.788
    ## anomSev:regioneastern_bering_sea  0.007284   0.024467   0.298    0.766
    ## anomSev:regionevhoe               0.004140   0.027383   0.151    0.880
    ## anomSev:regionfr_cgfs             0.010591   0.026169   0.405    0.686
    ## anomSev:regiongulf_of_alaska      0.006818   0.025409   0.268    0.789
    ## anomSev:regiongulf_of_mexico      0.003691   0.026485   0.139    0.889
    ## anomSev:regionie_igfs             0.016865   0.027468   0.614    0.540
    ## anomSev:regionnorbts              0.001582   0.024906   0.064    0.949
    ## anomSev:regionnortheast           0.009157   0.024940   0.367    0.714
    ## anomSev:regionns_ibts             0.005725   0.025499   0.225    0.822
    ## anomSev:regionpt_ibts             0.019859   0.026601   0.747    0.456
    ## anomSev:regionrockall            -0.004455   0.027495  -0.162    0.871
    ## anomSev:regionscotian_shelf       0.010278   0.025426   0.404    0.686
    ## anomSev:regionsoutheast           0.004530   0.025695   0.176    0.860
    ## anomSev:regionswc_ibts           -0.003585   0.027827  -0.129    0.898
    ## anomSev:regionwest_coast          0.005646   0.024530   0.230    0.818
    ## 
    ## Residual standard error: 0.4375 on 364 degrees of freedom
    ##   (17 observations deleted due to missingness)
    ## Multiple R-squared:  0.06585,    Adjusted R-squared:  -0.01884 
    ## F-statistic: 0.7775 on 33 and 364 DF,  p-value: 0.8083

### Species-level models using region\*year predictors

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC + anomIntC * ref_year, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##  -3716     -5     -2     -1 199129 
    ## 
    ## Coefficients: (402 not defined because of singularities)
    ##                                              Estimate Std. Error t value
    ## (Intercept)                                 1.301e+00  7.307e+01   0.018
    ## anomIntC                                   -4.845e-01  6.266e+02  -0.001
    ## ref_yearaleutian_islands-5-1991             4.758e+00  1.264e+02   0.038
    ## ref_yearaleutian_islands-5-1994             6.894e+00  1.768e+02   0.039
    ## ref_yearaleutian_islands-5-1997             3.896e+00  1.420e+02   0.027
    ## ref_yearaleutian_islands-5-2000             6.346e+00  1.081e+02   0.059
    ## ref_yearaleutian_islands-5-2002            -6.732e-01  1.388e+02  -0.005
    ## ref_yearaleutian_islands-5-2004             9.728e-01  1.400e+02   0.007
    ## ref_yearaleutian_islands-5-2006             2.995e+01  1.725e+02   0.174
    ## ref_yearaleutian_islands-5-2010            -3.712e-01  1.079e+02  -0.003
    ## ref_yearaleutian_islands-5-2012             1.430e+00  2.408e+02   0.006
    ## ref_yearaleutian_islands-5-2014             4.101e+00  3.270e+02   0.013
    ## ref_yearaleutian_islands-5-2016            -2.215e-01  1.823e+02  -0.001
    ## ref_yearaleutian_islands-5-2018             1.240e+00  1.528e+02   0.008
    ## ref_yearbits-2-1993                        -1.368e-01  3.889e+02   0.000
    ## ref_yearbits-2-1994                         3.032e-01  3.902e+02   0.001
    ## ref_yearbits-2-1995                         4.924e+00  7.069e+02   0.007
    ## ref_yearbits-2-1996                         1.725e+01  4.722e+02   0.037
    ## ref_yearbits-2-1997                        -3.189e-01  1.861e+02  -0.002
    ## ref_yearbits-2-1998                        -9.762e-01  8.447e+02  -0.001
    ## ref_yearbits-2-1999                         2.360e+01  2.501e+02   0.094
    ## ref_yearbits-2-2000                        -4.850e-01  2.530e+02  -0.002
    ## ref_yearbits-2-2001                         6.695e+01  2.915e+02   0.230
    ## ref_yearbits-2-2002                        -1.110e+00  3.072e+02  -0.004
    ## ref_yearbits-2-2003                         5.023e+00  4.357e+02   0.012
    ## ref_yearbits-2-2004                         1.207e+00  3.852e+02   0.003
    ## ref_yearbits-2-2005                         6.514e-01  1.538e+02   0.004
    ## ref_yearbits-2-2006                         9.746e+00  3.833e+02   0.025
    ## ref_yearbits-2-2007                         2.138e+00  4.119e+02   0.005
    ## ref_yearbits-2-2008                        -2.694e-01  5.609e+02   0.000
    ## ref_yearbits-2-2009                         1.102e+00  6.591e+02   0.002
    ## ref_yearbits-2-2010                         2.185e+01  1.990e+02   0.110
    ## ref_yearbits-2-2011                         8.629e-03  6.445e+02   0.000
    ## ref_yearbits-2-2012                         6.199e+00  2.442e+02   0.025
    ## ref_yearbits-2-2013                         1.227e+00  1.606e+02   0.008
    ## ref_yearbits-2-2014                         1.007e+00  1.540e+02   0.007
    ## ref_yearbits-2-2015                         6.731e+00  4.120e+02   0.016
    ## ref_yearbits-2-2016                         1.025e+00  5.664e+02   0.002
    ## ref_yearbits-2-2017                         8.515e-01  2.757e+02   0.003
    ## ref_yearbits-2-2018                        -6.057e-01  1.520e+02  -0.004
    ## ref_yearbits-2-2019                         8.186e+00  6.339e+02   0.013
    ## ref_yearbits-2-2020                         6.494e-01  2.185e+02   0.003
    ## ref_yeareastern_bering_sea-5-1983           1.729e+00  1.184e+02   0.015
    ## ref_yeareastern_bering_sea-5-1984           3.269e+01  2.274e+02   0.144
    ## ref_yeareastern_bering_sea-5-1985           8.832e+00  2.556e+02   0.035
    ## ref_yeareastern_bering_sea-5-1986           7.288e+00  1.093e+02   0.067
    ## ref_yeareastern_bering_sea-5-1987           1.594e+01  1.046e+02   0.152
    ## ref_yeareastern_bering_sea-5-1988           1.115e+01  1.034e+02   0.108
    ## ref_yeareastern_bering_sea-5-1989           3.691e-01  1.086e+02   0.003
    ## ref_yeareastern_bering_sea-5-1990           1.892e+01  1.097e+02   0.172
    ## ref_yeareastern_bering_sea-5-1991           6.512e-01  1.101e+02   0.006
    ## ref_yeareastern_bering_sea-5-1992           2.276e+00  1.113e+02   0.020
    ## ref_yeareastern_bering_sea-5-1993          -4.346e-01  1.119e+02  -0.004
    ## ref_yeareastern_bering_sea-5-1994           2.222e+00  1.138e+02   0.020
    ## ref_yeareastern_bering_sea-5-1995          -7.032e-01  1.119e+02  -0.006
    ## ref_yeareastern_bering_sea-5-1996           1.604e+00  1.115e+02   0.014
    ## ref_yeareastern_bering_sea-5-1997           5.693e-01  1.101e+02   0.005
    ## ref_yeareastern_bering_sea-5-1998           3.917e+00  3.215e+02   0.012
    ## ref_yeareastern_bering_sea-5-1999           5.819e-01  1.095e+02   0.005
    ## ref_yeareastern_bering_sea-5-2000           2.499e+00  1.089e+02   0.023
    ## ref_yeareastern_bering_sea-5-2001           1.985e+01  1.048e+02   0.189
    ## ref_yeareastern_bering_sea-5-2002           2.128e+00  1.009e+02   0.021
    ## ref_yeareastern_bering_sea-5-2003           4.197e+00  1.064e+02   0.039
    ## ref_yeareastern_bering_sea-5-2004           5.554e+00  1.719e+02   0.032
    ## ref_yeareastern_bering_sea-5-2005           2.443e+01  3.077e+02   0.079
    ## ref_yeareastern_bering_sea-5-2006           1.396e+00  2.914e+02   0.005
    ## ref_yeareastern_bering_sea-5-2007           3.565e+00  1.091e+02   0.033
    ## ref_yeareastern_bering_sea-5-2008          -7.005e-01  1.097e+02  -0.006
    ## ref_yeareastern_bering_sea-5-2009          -5.872e-01  1.097e+02  -0.005
    ## ref_yeareastern_bering_sea-5-2010           7.111e+01  1.095e+02   0.649
    ## ref_yeareastern_bering_sea-5-2011           3.407e+02  1.095e+02   3.111
    ## ref_yeareastern_bering_sea-5-2012           5.405e+00  1.097e+02   0.049
    ## ref_yeareastern_bering_sea-5-2013           1.870e+00  1.099e+02   0.017
    ## ref_yeareastern_bering_sea-5-2014          -3.628e-01  1.089e+02  -0.003
    ## ref_yeareastern_bering_sea-5-2015           7.707e-01  3.983e+02   0.002
    ## ref_yeareastern_bering_sea-5-2016           3.074e+00  1.650e+02   0.019
    ## ref_yeareastern_bering_sea-5-2017          -8.419e-01  5.767e+02  -0.001
    ## ref_yeareastern_bering_sea-5-2018           4.722e+00  1.097e+02   0.043
    ## ref_yearevhoe-10-1998                      -4.121e-01  2.531e+02  -0.002
    ## ref_yearevhoe-10-1999                       1.814e+00  1.410e+02   0.013
    ## ref_yearevhoe-10-2000                       8.874e-01  1.666e+02   0.005
    ## ref_yearevhoe-10-2001                       8.410e-01  1.760e+02   0.005
    ## ref_yearevhoe-10-2002                       1.031e-01  1.169e+02   0.001
    ## ref_yearevhoe-10-2003                       5.154e-01  2.089e+02   0.002
    ## ref_yearevhoe-10-2004                      -6.768e-02  2.998e+02   0.000
    ## ref_yearevhoe-10-2005                      -2.316e-01  2.148e+02  -0.001
    ## ref_yearevhoe-10-2006                      -4.604e-01  2.829e+02  -0.002
    ## ref_yearevhoe-10-2007                       1.067e+00  2.470e+02   0.004
    ## ref_yearevhoe-10-2008                       6.699e+00  1.270e+02   0.053
    ## ref_yearevhoe-10-2009                       2.471e-01  1.876e+02   0.001
    ## ref_yearevhoe-10-2010                       6.234e-02  1.396e+02   0.000
    ## ref_yearevhoe-10-2011                       1.063e-01  2.322e+02   0.000
    ## ref_yearevhoe-10-2012                      -5.515e-02  1.107e+02   0.000
    ## ref_yearevhoe-10-2013                       9.913e+00  1.737e+02   0.057
    ## ref_yearevhoe-10-2014                      -5.820e-01  1.665e+02  -0.003
    ## ref_yearevhoe-10-2015                       2.168e+01  1.533e+02   0.141
    ## ref_yearevhoe-10-2016                       3.183e+00  1.140e+02   0.028
    ## ref_yearevhoe-10-2017                       4.065e+00  2.581e+02   0.016
    ## ref_yearevhoe-10-2018                       9.071e+00  3.386e+02   0.027
    ## ref_yearevhoe-10-2019                       3.349e-01  1.441e+02   0.002
    ## ref_yearevhoe-10-2020                      -7.170e-01  1.164e+02  -0.006
    ## ref_yearfr_cgfs-10-1999                    -2.521e-01  1.806e+02  -0.001
    ## ref_yearfr_cgfs-10-2000                    -1.428e+00  1.657e+02  -0.009
    ## ref_yearfr_cgfs-10-2001                    -1.156e+00  1.739e+02  -0.007
    ## ref_yearfr_cgfs-10-2002                     1.828e-01  1.828e+02   0.001
    ## ref_yearfr_cgfs-10-2003                    -8.066e-01  1.938e+02  -0.004
    ## ref_yearfr_cgfs-10-2004                    -9.519e-01  1.685e+02  -0.006
    ## ref_yearfr_cgfs-10-2005                    -5.372e-02  1.668e+02   0.000
    ## ref_yearfr_cgfs-10-2006                    -7.573e-01  1.759e+02  -0.004
    ## ref_yearfr_cgfs-10-2007                     1.015e+00  2.810e+02   0.004
    ## ref_yearfr_cgfs-10-2008                    -1.979e-01  1.643e+02  -0.001
    ## ref_yearfr_cgfs-10-2009                    -3.219e-01  1.644e+02  -0.002
    ## ref_yearfr_cgfs-10-2010                     6.936e-01  1.657e+02   0.004
    ## ref_yearfr_cgfs-10-2011                     1.741e-01  1.825e+02   0.001
    ## ref_yearfr_cgfs-10-2012                     4.181e-01  1.594e+02   0.003
    ## ref_yearfr_cgfs-10-2013                     2.698e+00  1.631e+02   0.017
    ## ref_yearfr_cgfs-10-2014                     3.227e+00  1.922e+02   0.017
    ## ref_yearfr_cgfs-10-2015                     6.909e+00  1.657e+02   0.042
    ## ref_yearfr_cgfs-10-2016                    -9.207e-01  1.612e+02  -0.006
    ## ref_yearfr_cgfs-10-2017                     3.817e+00  2.963e+02   0.013
    ## ref_yearfr_cgfs-10-2018                     3.912e+00  1.831e+02   0.021
    ## ref_yearfr_cgfs-10-2019                     7.164e-01  1.660e+02   0.004
    ## ref_yearfr_cgfs-10-2020                    -7.593e-01  1.594e+02  -0.005
    ## ref_yeargulf_of_alaska-5-1987               8.546e-01  1.038e+02   0.008
    ## ref_yeargulf_of_alaska-5-1990               6.009e+00  1.091e+02   0.055
    ## ref_yeargulf_of_alaska-5-1993               4.657e+00  1.054e+02   0.044
    ## ref_yeargulf_of_alaska-5-1996               4.445e+00  1.011e+02   0.044
    ## ref_yeargulf_of_alaska-5-1999               6.470e-01  9.966e+01   0.006
    ## ref_yeargulf_of_alaska-5-2003               9.359e+00  1.140e+02   0.082
    ## ref_yeargulf_of_alaska-5-2005               2.523e+00  2.571e+02   0.010
    ## ref_yeargulf_of_alaska-5-2007               2.041e+01  2.156e+02   0.095
    ## ref_yeargulf_of_alaska-5-2009               3.262e-01  9.966e+01   0.003
    ## ref_yeargulf_of_alaska-5-2011               1.924e+00  9.966e+01   0.019
    ## ref_yeargulf_of_alaska-5-2013               3.075e+00  9.996e+01   0.031
    ## ref_yeargulf_of_alaska-5-2015               7.519e-01  1.175e+02   0.006
    ## ref_yeargulf_of_alaska-5-2017               2.477e-01  2.761e+02   0.001
    ## ref_yeargulf_of_mexico-5-2009               1.320e+01  9.400e+01   0.140
    ## ref_yeargulf_of_mexico-5-2010               1.750e+00  1.035e+02   0.017
    ## ref_yeargulf_of_mexico-5-2011               8.978e-01  1.565e+02   0.006
    ## ref_yeargulf_of_mexico-5-2012              -8.245e-03  5.512e+02   0.000
    ## ref_yeargulf_of_mexico-5-2013               2.434e+00  9.271e+01   0.026
    ## ref_yeargulf_of_mexico-5-2014               2.061e-01  9.276e+01   0.002
    ## ref_yeargulf_of_mexico-5-2015               4.290e-01  2.119e+02   0.002
    ## ref_yeargulf_of_mexico-5-2016              -1.435e-01  1.514e+02  -0.001
    ## ref_yeargulf_of_mexico-5-2017               1.818e+00  1.834e+02   0.010
    ## ref_yeargulf_of_mexico-5-2019               3.394e+00  8.851e+01   0.038
    ## ref_yearie_igfs-10-2004                     1.271e+00  2.006e+02   0.006
    ## ref_yearie_igfs-10-2005                    -9.261e-01  1.323e+02  -0.007
    ## ref_yearie_igfs-10-2006                     1.711e+00  2.623e+02   0.007
    ## ref_yearie_igfs-10-2007                     7.485e+01  2.912e+02   0.257
    ## ref_yearie_igfs-10-2008                     6.294e-01  1.181e+02   0.005
    ## ref_yearie_igfs-10-2009                    -1.082e-01  1.353e+02  -0.001
    ## ref_yearie_igfs-10-2010                    -9.084e-03  1.839e+02   0.000
    ## ref_yearie_igfs-10-2011                     9.034e-01  1.276e+02   0.007
    ## ref_yearie_igfs-10-2012                     3.813e+00  1.285e+02   0.030
    ## ref_yearie_igfs-10-2013                    -8.598e-01  3.658e+02  -0.002
    ## ref_yearie_igfs-10-2014                     2.268e+00  2.694e+02   0.008
    ## ref_yearie_igfs-10-2015                     5.798e+01  1.285e+02   0.451
    ## ref_yearie_igfs-10-2016                    -2.989e-01  3.719e+02  -0.001
    ## ref_yearie_igfs-10-2017                     1.929e+00  1.247e+02   0.015
    ## ref_yearie_igfs-10-2018                     1.551e+01  3.708e+02   0.042
    ## ref_yearie_igfs-10-2019                     7.577e-01  1.222e+02   0.006
    ## ref_yearie_igfs-10-2020                    -4.978e-01  1.268e+02  -0.004
    ## ref_yearnorbts-1-2005                       4.910e+00  1.897e+02   0.026
    ## ref_yearnorbts-1-2006                       3.536e+01  1.381e+02   0.256
    ## ref_yearnorbts-1-2007                       9.996e+00  1.714e+02   0.058
    ## ref_yearnorbts-1-2008                       5.453e+00  1.541e+02   0.035
    ## ref_yearnorbts-1-2009                       3.714e+03  1.537e+02  24.167
    ## ref_yearnorbts-1-2010                      -1.303e+00  1.475e+02  -0.009
    ## ref_yearnorbts-1-2011                       2.993e+00  1.644e+02   0.018
    ## ref_yearnorbts-1-2012                       2.876e+00  1.501e+02   0.019
    ## ref_yearnorbts-1-2013                       4.927e+01  1.387e+02   0.355
    ## ref_yearnorbts-1-2014                       1.264e+01  3.579e+02   0.035
    ## ref_yearnorbts-1-2015                      -7.992e-01  1.459e+02  -0.005
    ## ref_yearnorbts-1-2016                      -6.555e-01  1.369e+02  -0.005
    ## ref_yearnorbts-1-2017                       7.966e-01  2.053e+02   0.004
    ## ref_yearnortheast-2-1983                   -4.854e-01  1.542e+02  -0.003
    ## ref_yearnortheast-2-1984                    8.660e-02  1.510e+02   0.001
    ## ref_yearnortheast-2-1985                    1.016e-01  1.964e+02   0.001
    ## ref_yearnortheast-2-1986                   -9.829e-01  1.387e+02  -0.007
    ## ref_yearnortheast-2-1987                   -7.015e-01  1.444e+02  -0.005
    ## ref_yearnortheast-2-1988                   -1.469e-01  1.294e+02  -0.001
    ## ref_yearnortheast-2-1989                    3.588e+00  1.246e+02   0.029
    ## ref_yearnortheast-2-1990                   -7.473e-01  1.364e+02  -0.005
    ## ref_yearnortheast-2-1991                    9.960e-01  1.705e+02   0.006
    ## ref_yearnortheast-2-1992                    1.399e-01  3.829e+02   0.000
    ## ref_yearnortheast-2-1993                   -1.062e+00  1.304e+02  -0.008
    ## ref_yearnortheast-2-1994                    3.503e+00  1.246e+02   0.028
    ## ref_yearnortheast-2-1995                    7.495e-01  1.716e+02   0.004
    ## ref_yearnortheast-2-1996                   -1.181e+00  1.285e+02  -0.009
    ## ref_yearnortheast-2-1997                   -5.416e-01  1.246e+02  -0.004
    ## ref_yearnortheast-2-1998                   -9.948e-02  1.299e+02  -0.001
    ## ref_yearnortheast-2-1999                   -3.790e-02  1.294e+02   0.000
    ## ref_yearnortheast-2-2000                   -4.913e-01  1.361e+02  -0.004
    ## ref_yearnortheast-2-2001                   -7.079e-01  1.757e+02  -0.004
    ## ref_yearnortheast-2-2002                    6.061e+00  1.608e+02   0.038
    ## ref_yearnortheast-2-2003                    4.181e+00  2.514e+02   0.017
    ## ref_yearnortheast-2-2004                   -1.153e+00  1.290e+02  -0.009
    ## ref_yearnortheast-2-2005                   -2.926e-01  1.299e+02  -0.002
    ## ref_yearnortheast-2-2006                   -4.139e-01  1.625e+02  -0.003
    ## ref_yearnortheast-2-2007                   -2.335e-02  2.513e+02   0.000
    ## ref_yearnortheast-2-2008                   -5.761e-01  1.290e+02  -0.004
    ## ref_yearnortheast-2-2009                    9.717e-01  1.315e+02   0.007
    ## ref_yearnortheast-2-2010                   -9.706e-01  1.439e+02  -0.007
    ## ref_yearnortheast-2-2011                    1.051e+00  3.971e+02   0.003
    ## ref_yearnortheast-2-2012                   -5.904e-01  3.416e+02  -0.002
    ## ref_yearnortheast-2-2013                    7.549e-02  3.657e+02   0.000
    ## ref_yearnortheast-2-2014                    5.821e-01  2.964e+02   0.002
    ## ref_yearnortheast-2-2015                    8.739e-01  1.455e+02   0.006
    ## ref_yearnortheast-2-2016                   -5.206e-01  2.605e+02  -0.002
    ## ref_yearnortheast-2-2017                   -5.417e-01  1.806e+02  -0.003
    ## ref_yearnortheast-2-2018                    1.998e+00  1.429e+02   0.014
    ## ref_yearnortheast-2-2019                   -1.045e+00  2.610e+02  -0.004
    ## ref_yearns_ibts-1-1983                      9.007e-01  3.667e+02   0.002
    ## ref_yearns_ibts-1-1984                      4.854e+01  1.356e+02   0.358
    ## ref_yearns_ibts-1-1985                     -2.711e-01  1.506e+02  -0.002
    ## ref_yearns_ibts-1-1986                      8.283e-02  1.362e+02   0.001
    ## ref_yearns_ibts-1-1987                      1.646e+00  1.356e+02   0.012
    ## ref_yearns_ibts-1-1988                     -1.200e+00  1.368e+02  -0.009
    ## ref_yearns_ibts-1-1989                      1.260e+01  1.356e+02   0.093
    ## ref_yearns_ibts-1-1990                     -6.457e-01  1.592e+02  -0.004
    ## ref_yearns_ibts-1-1991                      5.426e+00  2.210e+02   0.025
    ## ref_yearns_ibts-1-1992                      1.596e+00  1.436e+02   0.011
    ## ref_yearns_ibts-1-1993                     -4.798e-01  3.166e+02  -0.002
    ## ref_yearns_ibts-1-1994                     -1.059e+00  1.345e+02  -0.008
    ## ref_yearns_ibts-1-1995                      4.472e-01  2.046e+02   0.002
    ## ref_yearns_ibts-1-1996                      4.267e+00  2.869e+02   0.015
    ## ref_yearns_ibts-1-1997                      1.175e-02  1.272e+02   0.000
    ## ref_yearns_ibts-1-1998                      5.632e+00  4.790e+02   0.012
    ## ref_yearns_ibts-1-1999                     -8.642e-01  1.285e+02  -0.007
    ## ref_yearns_ibts-1-2000                     -6.739e-02  1.482e+02   0.000
    ## ref_yearns_ibts-1-2001                      8.772e+00  2.901e+02   0.030
    ## ref_yearns_ibts-1-2002                     -5.809e-01  1.259e+02  -0.005
    ## ref_yearns_ibts-1-2003                      1.020e+02  1.700e+02   0.600
    ## ref_yearns_ibts-1-2004                      3.352e-01  2.768e+02   0.001
    ## ref_yearns_ibts-1-2005                     -2.332e-01  1.593e+02  -0.001
    ## ref_yearns_ibts-1-2006                      3.109e-02  1.240e+02   0.000
    ## ref_yearns_ibts-1-2007                      7.037e+00  2.259e+02   0.031
    ## ref_yearns_ibts-1-2008                     -5.605e-01  2.188e+02  -0.003
    ## ref_yearns_ibts-1-2009                      2.886e+00  2.533e+02   0.011
    ## ref_yearns_ibts-1-2010                      4.024e+00  7.517e+02   0.005
    ## ref_yearns_ibts-1-2011                      3.443e+01  1.233e+02   0.279
    ## ref_yearns_ibts-1-2012                      3.869e+01  1.244e+02   0.311
    ## ref_yearns_ibts-1-2013                     -8.519e-01  2.401e+02  -0.004
    ## ref_yearns_ibts-1-2014                      8.168e-01  1.218e+02   0.007
    ## ref_yearns_ibts-1-2015                      1.583e+00  3.374e+02   0.005
    ## ref_yearns_ibts-1-2016                      2.542e+00  1.215e+02   0.021
    ## ref_yearns_ibts-1-2017                      8.975e+01  1.545e+02   0.581
    ## ref_yearns_ibts-1-2018                      1.663e+00  1.326e+02   0.013
    ## ref_yearns_ibts-1-2019                      2.153e-01  2.190e+02   0.001
    ## ref_yearns_ibts-1-2020                      3.675e-02  1.353e+02   0.000
    ## ref_yearpt_ibts-9-2005                      2.372e+00  1.639e+02   0.014
    ## ref_yearpt_ibts-9-2006                     -2.121e-01  3.350e+02  -0.001
    ## ref_yearpt_ibts-9-2007                     -5.200e-01  3.075e+02  -0.002
    ## ref_yearpt_ibts-9-2008                      2.456e+00  1.350e+02   0.018
    ## ref_yearpt_ibts-9-2009                      1.366e-01  2.377e+02   0.001
    ## ref_yearpt_ibts-9-2010                     -2.662e-01  2.214e+02  -0.001
    ## ref_yearpt_ibts-9-2011                      1.603e+00  3.965e+02   0.004
    ## ref_yearpt_ibts-9-2013                      5.168e+00  1.427e+02   0.036
    ## ref_yearpt_ibts-9-2014                     -1.182e+00  1.336e+02  -0.009
    ## ref_yearpt_ibts-9-2015                      4.764e+01  3.614e+02   0.132
    ## ref_yearpt_ibts-9-2016                      1.310e+00  1.370e+02   0.010
    ## ref_yearpt_ibts-9-2017                      5.802e+00  1.906e+02   0.030
    ## ref_yearpt_ibts-9-2018                     -1.518e+00  1.340e+02  -0.011
    ## ref_yearrockall-8-2001                     -1.571e+00  2.741e+02  -0.006
    ## ref_yearrockall-8-2002                     -1.050e+00  2.269e+02  -0.005
    ## ref_yearrockall-8-2003                      1.848e+01  2.972e+02   0.062
    ## ref_yearrockall-8-2005                      1.681e+00  2.134e+02   0.008
    ## ref_yearrockall-8-2006                      8.154e-01  1.927e+02   0.004
    ## ref_yearrockall-8-2007                     -3.028e-01  2.153e+02  -0.001
    ## ref_yearrockall-8-2008                     -9.787e-01  3.603e+02  -0.003
    ## ref_yearrockall-8-2009                      2.730e-01  6.453e+02   0.000
    ## ref_yearrockall-8-2011                      7.431e+02  1.846e+02   4.026
    ## ref_yearrockall-8-2012                     -1.603e-01  1.685e+02  -0.001
    ## ref_yearrockall-8-2013                      6.020e+00  2.203e+02   0.027
    ## ref_yearrockall-8-2014                      6.199e+00  5.029e+02   0.012
    ## ref_yearrockall-8-2015                     -1.013e+00  1.888e+02  -0.005
    ## ref_yearrockall-8-2016                      4.713e+00  3.216e+02   0.015
    ## ref_yearrockall-8-2017                     -1.334e+00  1.753e+02  -0.008
    ## ref_yearrockall-8-2018                     -5.797e-01  1.801e+02  -0.003
    ## ref_yearrockall-8-2019                      1.031e-01  1.809e+02   0.001
    ## ref_yearrockall-8-2020                     -1.457e+00  1.731e+02  -0.008
    ## ref_yearscotian_shelf-6-1983               -1.554e-01  2.339e+02  -0.001
    ## ref_yearscotian_shelf-6-1984                2.088e+00  2.594e+02   0.008
    ## ref_yearscotian_shelf-6-1985               -6.438e-01  4.144e+02  -0.002
    ## ref_yearscotian_shelf-6-1987               -7.542e-01  1.840e+02  -0.004
    ## ref_yearscotian_shelf-6-1988               -3.906e-01  1.821e+02  -0.002
    ## ref_yearscotian_shelf-6-1989               -7.562e-01  2.468e+02  -0.003
    ## ref_yearscotian_shelf-6-1990               -1.433e+00  1.840e+02  -0.008
    ## ref_yearscotian_shelf-6-1991                7.736e+00  2.241e+02   0.035
    ## ref_yearscotian_shelf-6-1992               -1.152e+00  1.840e+02  -0.006
    ## ref_yearscotian_shelf-6-1993               -2.311e-01  1.861e+02  -0.001
    ## ref_yearscotian_shelf-6-1994               -6.658e-02  1.820e+02   0.000
    ## ref_yearscotian_shelf-6-1995                5.284e+00  4.615e+02   0.011
    ## ref_yearscotian_shelf-6-1996               -1.304e+00  1.820e+02  -0.007
    ## ref_yearscotian_shelf-6-1997               -9.599e-01  1.820e+02  -0.005
    ## ref_yearscotian_shelf-6-1998               -7.521e-01  1.905e+02  -0.004
    ## ref_yearscotian_shelf-6-1999               -8.601e-01  2.174e+02  -0.004
    ## ref_yearscotian_shelf-6-2000               -7.892e-01  4.308e+02  -0.002
    ## ref_yearscotian_shelf-6-2001               -5.339e-01  1.820e+02  -0.003
    ## ref_yearscotian_shelf-6-2002               -1.310e+00  1.820e+02  -0.007
    ## ref_yearscotian_shelf-6-2003               -1.016e+00  1.839e+02  -0.006
    ## ref_yearscotian_shelf-6-2004               -3.816e-01  2.600e+02  -0.001
    ## ref_yearscotian_shelf-6-2005               -4.894e-01  1.820e+02  -0.003
    ## ref_yearscotian_shelf-6-2006               -6.046e-01  2.655e+02  -0.002
    ## ref_yearscotian_shelf-6-2007               -7.686e-01  1.861e+02  -0.004
    ## ref_yearscotian_shelf-6-2008               -8.657e-01  1.820e+02  -0.005
    ## ref_yearscotian_shelf-6-2009                1.439e+00  1.791e+02   0.008
    ## ref_yearscotian_shelf-6-2010                1.087e+00  2.199e+02   0.005
    ## ref_yearscotian_shelf-6-2011               -2.083e-01  5.192e+02   0.000
    ## ref_yearscotian_shelf-6-2012               -8.401e-01  4.267e+02  -0.002
    ## ref_yearscotian_shelf-6-2013               -9.244e-01  2.610e+02  -0.004
    ## ref_yearscotian_shelf-6-2014               -4.359e-01  3.168e+02  -0.001
    ## ref_yearscotian_shelf-6-2015               -9.592e-01  1.913e+02  -0.005
    ## ref_yearscotian_shelf-6-2016               -5.110e-01  1.919e+02  -0.003
    ## ref_yearscotian_shelf-6-2017                2.718e+00  2.072e+02   0.013
    ## ref_yearsoutheast-4-1990                   -7.119e-01  2.338e+02  -0.003
    ## ref_yearsoutheast-4-1991                   -4.464e-01  1.274e+02  -0.004
    ## ref_yearsoutheast-4-1992                   -5.224e-01  1.128e+02  -0.005
    ## ref_yearsoutheast-4-1993                   -9.816e-02  2.667e+02   0.000
    ## ref_yearsoutheast-4-1994                    2.150e-01  1.577e+02   0.001
    ## ref_yearsoutheast-4-1995                    8.618e-01  1.159e+02   0.007
    ## ref_yearsoutheast-4-1996                   -6.836e-01  1.199e+02  -0.006
    ## ref_yearsoutheast-4-1997                   -6.213e-01  4.081e+02  -0.002
    ## ref_yearsoutheast-4-1998                    5.254e-01  1.205e+02   0.004
    ## ref_yearsoutheast-4-1999                    6.802e-02  3.479e+02   0.000
    ## ref_yearsoutheast-4-2000                   -5.842e-01  1.122e+02  -0.005
    ## ref_yearsoutheast-4-2001                   -1.825e-01  1.652e+02  -0.001
    ## ref_yearsoutheast-4-2002                    1.162e+00  1.497e+02   0.008
    ## ref_yearsoutheast-4-2003                    1.592e-01  1.148e+02   0.001
    ## ref_yearsoutheast-4-2004                    2.677e-02  1.138e+02   0.000
    ## ref_yearsoutheast-4-2005                   -3.297e-01  1.157e+02  -0.003
    ## ref_yearsoutheast-4-2006                   -4.144e-01  1.914e+02  -0.002
    ## ref_yearsoutheast-4-2007                   -4.427e-01  1.196e+02  -0.004
    ## ref_yearsoutheast-4-2008                   -3.507e-01  1.189e+02  -0.003
    ## ref_yearsoutheast-4-2009                    1.142e+00  1.199e+02   0.010
    ## ref_yearsoutheast-4-2010                   -3.774e-01  1.205e+02  -0.003
    ## ref_yearsoutheast-4-2011                    2.423e+00  1.314e+02   0.018
    ## ref_yearsoutheast-4-2012                    1.208e+01  3.310e+02   0.037
    ## ref_yearsoutheast-4-2013                    2.446e+00  1.746e+02   0.014
    ## ref_yearsoutheast-4-2014                   -9.422e-01  1.202e+02  -0.008
    ## ref_yearsoutheast-4-2015                    5.190e+00  1.174e+02   0.044
    ## ref_yearsoutheast-4-2016                   -3.248e-01  2.689e+02  -0.001
    ## ref_yearsoutheast-4-2017                    4.775e+00  1.194e+02   0.040
    ## ref_yearsoutheast-4-2018                   -6.252e-01  2.200e+02  -0.003
    ## ref_yearswc_ibts-1-1986                    -7.570e-01  1.459e+02  -0.005
    ## ref_yearswc_ibts-1-1987                    -8.700e-01  1.511e+02  -0.006
    ## ref_yearswc_ibts-1-1988                     1.287e+01  1.511e+02   0.085
    ## ref_yearswc_ibts-1-1989                    -1.625e-02  1.473e+02   0.000
    ## ref_yearswc_ibts-1-1990                     1.974e+01  1.679e+02   0.118
    ## ref_yearswc_ibts-1-1991                     1.098e-01  1.760e+02   0.001
    ## ref_yearswc_ibts-1-1992                     2.415e+01  1.725e+02   0.140
    ## ref_yearswc_ibts-1-1993                     4.860e+00  1.960e+02   0.025
    ## ref_yearswc_ibts-1-1994                     1.636e-02  1.520e+02   0.000
    ## ref_yearswc_ibts-1-1995                     1.970e+01  1.475e+02   0.134
    ## ref_yearswc_ibts-1-1996                     3.145e-01  2.581e+02   0.001
    ## ref_yearswc_ibts-1-1997                     4.917e-01  1.443e+02   0.003
    ## ref_yearswc_ibts-1-1998                     2.809e-01  1.536e+02   0.002
    ## ref_yearswc_ibts-1-1999                    -8.593e-01  1.542e+02  -0.006
    ## ref_yearswc_ibts-1-2000                     1.495e+01  1.411e+02   0.106
    ## ref_yearswc_ibts-1-2001                     4.634e-01  1.673e+02   0.003
    ## ref_yearswc_ibts-1-2002                    -3.107e-01  1.480e+02  -0.002
    ## ref_yearswc_ibts-1-2003                     2.631e+00  1.365e+02   0.019
    ## ref_yearswc_ibts-1-2004                    -7.266e-01  1.739e+02  -0.004
    ## ref_yearswc_ibts-1-2005                    -7.174e-01  1.416e+02  -0.005
    ## ref_yearswc_ibts-1-2006                     3.854e+01  1.492e+02   0.258
    ## ref_yearswc_ibts-1-2007                     1.870e+00  1.705e+02   0.011
    ## ref_yearswc_ibts-1-2008                     2.086e-01  3.206e+02   0.001
    ## ref_yearswc_ibts-1-2009                    -1.170e+00  1.846e+02  -0.006
    ## ref_yearswc_ibts-1-2010                     6.231e+00  3.469e+02   0.018
    ## ref_yearswc_ibts-1-2011                     2.892e+00  1.491e+02   0.019
    ## ref_yearswc_ibts-1-2012                    -7.747e-01  1.317e+02  -0.006
    ## ref_yearswc_ibts-1-2013                     8.327e+00  1.354e+02   0.061
    ## ref_yearswc_ibts-1-2014                    -6.277e-01  1.749e+02  -0.004
    ## ref_yearswc_ibts-1-2015                    -7.758e-02  2.529e+02   0.000
    ## ref_yearswc_ibts-1-2016                    -6.145e-01  1.381e+02  -0.004
    ## ref_yearswc_ibts-1-2017                    -7.340e-01  1.974e+02  -0.004
    ## ref_yearswc_ibts-1-2018                    -9.746e-01  1.814e+02  -0.005
    ## ref_yearswc_ibts-1-2019                     4.271e+00  2.075e+02   0.021
    ## ref_yearswc_ibts-1-2020                     1.255e+00  1.500e+02   0.008
    ## ref_yearwest_coast-5-1986                   7.086e-02  1.229e+02   0.001
    ## ref_yearwest_coast-5-1989                   1.461e+00  1.236e+02   0.012
    ## ref_yearwest_coast-5-1992                   9.732e-01  1.486e+02   0.007
    ## ref_yearwest_coast-5-1995                   4.666e-01  1.534e+02   0.003
    ## ref_yearwest_coast-5-1998                   1.802e+00  3.163e+02   0.006
    ## ref_yearwest_coast-5-2001                   5.050e+00  1.229e+02   0.041
    ## ref_yearwest_coast-5-2003                   1.215e+02  1.304e+02   0.932
    ## ref_yearwest_coast-5-2004                   7.023e+00  9.807e+01   0.072
    ## ref_yearwest_coast-5-2005                  -4.863e-01  1.052e+02  -0.005
    ## ref_yearwest_coast-5-2006                   3.970e+00  1.037e+02   0.038
    ## ref_yearwest_coast-5-2007                   1.425e+01  1.036e+02   0.138
    ## ref_yearwest_coast-5-2008                   1.523e+00  2.082e+02   0.007
    ## ref_yearwest_coast-5-2009                   7.786e+00  1.036e+02   0.075
    ## ref_yearwest_coast-5-2010                   3.475e+00  1.028e+02   0.034
    ## ref_yearwest_coast-5-2011                   8.810e+00  1.033e+02   0.085
    ## ref_yearwest_coast-5-2012                   4.987e+00  1.031e+02   0.048
    ## ref_yearwest_coast-5-2013                   8.103e+00  1.031e+02   0.079
    ## ref_yearwest_coast-5-2014                   2.056e+00  1.508e+02   0.014
    ## ref_yearwest_coast-5-2015                   3.247e+00  3.027e+02   0.011
    ## ref_yearwest_coast-5-2016                   5.151e-01  1.979e+02   0.003
    ## ref_yearwest_coast-5-2017                  -2.470e-02  1.726e+02   0.000
    ## ref_yearwest_coast-5-2018                   8.875e+00  1.037e+02   0.086
    ## ref_yearwest_coast-5-2019                          NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-1991           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-1994           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-1997           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2000           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2002           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2004           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2006           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2010           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2012           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2014           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2016           NA         NA      NA
    ## anomIntC:ref_yearaleutian_islands-5-2018           NA         NA      NA
    ## anomIntC:ref_yearbits-2-1993                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-1994                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-1995                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-1996                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-1997                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-1998                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-1999                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2000                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2001                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2002                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2003                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2004                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2005                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2006                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2007                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2008                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2009                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2010                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2011                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2012                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2013                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2014                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2015                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2016                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2017                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2018                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2019                       NA         NA      NA
    ## anomIntC:ref_yearbits-2-2020                       NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1983         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1984         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1985         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1986         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1987         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1988         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1989         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1990         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1991         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1992         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1993         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1994         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1995         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1996         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1997         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1998         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-1999         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2000         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2001         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2002         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2003         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2004         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2005         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2006         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2007         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2008         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2009         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2010         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2011         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2012         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2013         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2014         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2015         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2016         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2017         NA         NA      NA
    ## anomIntC:ref_yeareastern_bering_sea-5-2018         NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-1998                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-1999                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2000                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2001                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2002                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2003                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2004                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2005                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2006                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2007                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2008                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2009                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2010                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2011                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2012                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2013                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2014                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2015                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2016                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2017                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2018                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2019                     NA         NA      NA
    ## anomIntC:ref_yearevhoe-10-2020                     NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-1999                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2000                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2001                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2002                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2003                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2004                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2005                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2006                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2007                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2008                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2009                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2010                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2011                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2012                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2013                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2014                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2015                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2016                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2017                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2018                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2019                   NA         NA      NA
    ## anomIntC:ref_yearfr_cgfs-10-2020                   NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1987             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1990             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1993             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1996             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-1999             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2003             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2005             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2007             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2009             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2011             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2013             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2015             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_alaska-5-2017             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2009             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2010             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2011             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2012             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2013             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2014             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2015             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2016             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2017             NA         NA      NA
    ## anomIntC:ref_yeargulf_of_mexico-5-2019             NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2004                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2005                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2006                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2007                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2008                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2009                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2010                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2011                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2012                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2013                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2014                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2015                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2016                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2017                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2018                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2019                   NA         NA      NA
    ## anomIntC:ref_yearie_igfs-10-2020                   NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2005                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2006                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2007                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2008                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2009                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2010                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2011                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2012                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2013                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2014                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2015                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2016                     NA         NA      NA
    ## anomIntC:ref_yearnorbts-1-2017                     NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1983                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1984                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1985                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1986                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1987                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1988                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1989                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1990                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1991                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1992                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1993                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1994                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1995                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1996                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1997                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1998                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-1999                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2000                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2001                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2002                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2003                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2004                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2005                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2006                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2007                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2008                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2009                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2010                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2011                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2012                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2013                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2014                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2015                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2016                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2017                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2018                  NA         NA      NA
    ## anomIntC:ref_yearnortheast-2-2019                  NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1983                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1984                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1985                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1986                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1987                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1988                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1989                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1990                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1991                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1992                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1993                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1994                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1995                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1996                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1997                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1998                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-1999                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2000                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2001                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2002                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2003                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2004                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2005                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2006                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2007                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2008                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2009                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2010                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2011                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2012                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2013                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2014                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2015                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2016                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2017                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2018                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2019                    NA         NA      NA
    ## anomIntC:ref_yearns_ibts-1-2020                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2005                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2006                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2007                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2008                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2009                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2010                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2011                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2013                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2014                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2015                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2016                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2017                    NA         NA      NA
    ## anomIntC:ref_yearpt_ibts-9-2018                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2001                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2002                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2003                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2005                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2006                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2007                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2008                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2009                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2011                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2012                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2013                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2014                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2015                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2016                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2017                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2018                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2019                    NA         NA      NA
    ## anomIntC:ref_yearrockall-8-2020                    NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1983              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1984              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1985              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1987              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1988              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1989              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1990              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1991              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1992              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1993              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1994              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1995              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1996              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1997              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1998              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-1999              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2000              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2001              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2002              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2003              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2004              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2005              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2006              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2007              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2008              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2009              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2010              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2011              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2012              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2013              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2014              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2015              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2016              NA         NA      NA
    ## anomIntC:ref_yearscotian_shelf-6-2017              NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1990                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1991                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1992                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1993                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1994                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1995                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1996                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1997                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1998                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-1999                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2000                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2001                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2002                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2003                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2004                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2005                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2006                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2007                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2008                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2009                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2010                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2011                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2012                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2013                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2014                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2015                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2016                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2017                  NA         NA      NA
    ## anomIntC:ref_yearsoutheast-4-2018                  NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1986                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1987                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1988                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1989                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1990                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1991                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1992                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1993                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1994                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1995                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1996                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1997                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1998                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-1999                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2000                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2001                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2002                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2003                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2004                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2005                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2006                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2007                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2008                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2009                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2010                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2011                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2012                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2013                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2014                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2015                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2016                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2017                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2018                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2019                   NA         NA      NA
    ## anomIntC:ref_yearswc_ibts-1-2020                   NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1986                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1989                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1992                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1995                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-1998                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2001                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2003                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2004                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2005                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2006                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2007                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2008                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2009                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2010                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2011                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2012                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2013                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2014                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2015                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2016                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2017                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2018                 NA         NA      NA
    ## anomIntC:ref_yearwest_coast-5-2019                 NA         NA      NA
    ##                                            Pr(>|t|)    
    ## (Intercept)                                 0.98580    
    ## anomIntC                                    0.99938    
    ## ref_yearaleutian_islands-5-1991             0.96996    
    ## ref_yearaleutian_islands-5-1994             0.96890    
    ## ref_yearaleutian_islands-5-1997             0.97810    
    ## ref_yearaleutian_islands-5-2000             0.95317    
    ## ref_yearaleutian_islands-5-2002             0.99613    
    ## ref_yearaleutian_islands-5-2004             0.99446    
    ## ref_yearaleutian_islands-5-2006             0.86215    
    ## ref_yearaleutian_islands-5-2010             0.99725    
    ## ref_yearaleutian_islands-5-2012             0.99526    
    ## ref_yearaleutian_islands-5-2014             0.98999    
    ## ref_yearaleutian_islands-5-2016             0.99903    
    ## ref_yearaleutian_islands-5-2018             0.99353    
    ## ref_yearbits-2-1993                         0.99972    
    ## ref_yearbits-2-1994                         0.99938    
    ## ref_yearbits-2-1995                         0.99444    
    ## ref_yearbits-2-1996                         0.97086    
    ## ref_yearbits-2-1997                         0.99863    
    ## ref_yearbits-2-1998                         0.99908    
    ## ref_yearbits-2-1999                         0.92480    
    ## ref_yearbits-2-2000                         0.99847    
    ## ref_yearbits-2-2001                         0.81838    
    ## ref_yearbits-2-2002                         0.99712    
    ## ref_yearbits-2-2003                         0.99080    
    ## ref_yearbits-2-2004                         0.99750    
    ## ref_yearbits-2-2005                         0.99662    
    ## ref_yearbits-2-2006                         0.97972    
    ## ref_yearbits-2-2007                         0.99586    
    ## ref_yearbits-2-2008                         0.99962    
    ## ref_yearbits-2-2009                         0.99867    
    ## ref_yearbits-2-2010                         0.91256    
    ## ref_yearbits-2-2011                         0.99999    
    ## ref_yearbits-2-2012                         0.97975    
    ## ref_yearbits-2-2013                         0.99390    
    ## ref_yearbits-2-2014                         0.99478    
    ## ref_yearbits-2-2015                         0.98697    
    ## ref_yearbits-2-2016                         0.99856    
    ## ref_yearbits-2-2017                         0.99754    
    ## ref_yearbits-2-2018                         0.99682    
    ## ref_yearbits-2-2019                         0.98970    
    ## ref_yearbits-2-2020                         0.99763    
    ## ref_yeareastern_bering_sea-5-1983           0.98834    
    ## ref_yeareastern_bering_sea-5-1984           0.88569    
    ## ref_yeareastern_bering_sea-5-1985           0.97244    
    ## ref_yeareastern_bering_sea-5-1986           0.94685    
    ## ref_yeareastern_bering_sea-5-1987           0.87887    
    ## ref_yeareastern_bering_sea-5-1988           0.91417    
    ## ref_yeareastern_bering_sea-5-1989           0.99729    
    ## ref_yeareastern_bering_sea-5-1990           0.86308    
    ## ref_yeareastern_bering_sea-5-1991           0.99528    
    ## ref_yeareastern_bering_sea-5-1992           0.98368    
    ## ref_yeareastern_bering_sea-5-1993           0.99690    
    ## ref_yeareastern_bering_sea-5-1994           0.98442    
    ## ref_yeareastern_bering_sea-5-1995           0.99499    
    ## ref_yeareastern_bering_sea-5-1996           0.98852    
    ## ref_yeareastern_bering_sea-5-1997           0.99587    
    ## ref_yeareastern_bering_sea-5-1998           0.99028    
    ## ref_yeareastern_bering_sea-5-1999           0.99576    
    ## ref_yeareastern_bering_sea-5-2000           0.98170    
    ## ref_yeareastern_bering_sea-5-2001           0.84984    
    ## ref_yeareastern_bering_sea-5-2002           0.98317    
    ## ref_yeareastern_bering_sea-5-2003           0.96854    
    ## ref_yeareastern_bering_sea-5-2004           0.97423    
    ## ref_yeareastern_bering_sea-5-2005           0.93673    
    ## ref_yeareastern_bering_sea-5-2006           0.99618    
    ## ref_yeareastern_bering_sea-5-2007           0.97394    
    ## ref_yeareastern_bering_sea-5-2008           0.99490    
    ## ref_yeareastern_bering_sea-5-2009           0.99573    
    ## ref_yeareastern_bering_sea-5-2010           0.51604    
    ## ref_yeareastern_bering_sea-5-2011           0.00186 ** 
    ## ref_yeareastern_bering_sea-5-2012           0.96070    
    ## ref_yeareastern_bering_sea-5-2013           0.98642    
    ## ref_yeareastern_bering_sea-5-2014           0.99734    
    ## ref_yeareastern_bering_sea-5-2015           0.99846    
    ## ref_yeareastern_bering_sea-5-2016           0.98513    
    ## ref_yeareastern_bering_sea-5-2017           0.99884    
    ## ref_yeareastern_bering_sea-5-2018           0.96566    
    ## ref_yearevhoe-10-1998                       0.99870    
    ## ref_yearevhoe-10-1999                       0.98974    
    ## ref_yearevhoe-10-2000                       0.99575    
    ## ref_yearevhoe-10-2001                       0.99619    
    ## ref_yearevhoe-10-2002                       0.99930    
    ## ref_yearevhoe-10-2003                       0.99803    
    ## ref_yearevhoe-10-2004                       0.99982    
    ## ref_yearevhoe-10-2005                       0.99914    
    ## ref_yearevhoe-10-2006                       0.99870    
    ## ref_yearevhoe-10-2007                       0.99655    
    ## ref_yearevhoe-10-2008                       0.95793    
    ## ref_yearevhoe-10-2009                       0.99895    
    ## ref_yearevhoe-10-2010                       0.99964    
    ## ref_yearevhoe-10-2011                       0.99963    
    ## ref_yearevhoe-10-2012                       0.99960    
    ## ref_yearevhoe-10-2013                       0.95450    
    ## ref_yearevhoe-10-2014                       0.99721    
    ## ref_yearevhoe-10-2015                       0.88756    
    ## ref_yearevhoe-10-2016                       0.97773    
    ## ref_yearevhoe-10-2017                       0.98743    
    ## ref_yearevhoe-10-2018                       0.97863    
    ## ref_yearevhoe-10-2019                       0.99815    
    ## ref_yearevhoe-10-2020                       0.99509    
    ## ref_yearfr_cgfs-10-1999                     0.99889    
    ## ref_yearfr_cgfs-10-2000                     0.99312    
    ## ref_yearfr_cgfs-10-2001                     0.99470    
    ## ref_yearfr_cgfs-10-2002                     0.99920    
    ## ref_yearfr_cgfs-10-2003                     0.99668    
    ## ref_yearfr_cgfs-10-2004                     0.99549    
    ## ref_yearfr_cgfs-10-2005                     0.99974    
    ## ref_yearfr_cgfs-10-2006                     0.99657    
    ## ref_yearfr_cgfs-10-2007                     0.99712    
    ## ref_yearfr_cgfs-10-2008                     0.99904    
    ## ref_yearfr_cgfs-10-2009                     0.99844    
    ## ref_yearfr_cgfs-10-2010                     0.99666    
    ## ref_yearfr_cgfs-10-2011                     0.99924    
    ## ref_yearfr_cgfs-10-2012                     0.99791    
    ## ref_yearfr_cgfs-10-2013                     0.98680    
    ## ref_yearfr_cgfs-10-2014                     0.98661    
    ## ref_yearfr_cgfs-10-2015                     0.96674    
    ## ref_yearfr_cgfs-10-2016                     0.99544    
    ## ref_yearfr_cgfs-10-2017                     0.98972    
    ## ref_yearfr_cgfs-10-2018                     0.98295    
    ## ref_yearfr_cgfs-10-2019                     0.99656    
    ## ref_yearfr_cgfs-10-2020                     0.99620    
    ## ref_yeargulf_of_alaska-5-1987               0.99343    
    ## ref_yeargulf_of_alaska-5-1990               0.95609    
    ## ref_yeargulf_of_alaska-5-1993               0.96475    
    ## ref_yeargulf_of_alaska-5-1996               0.96493    
    ## ref_yeargulf_of_alaska-5-1999               0.99482    
    ## ref_yeargulf_of_alaska-5-2003               0.93457    
    ## ref_yeargulf_of_alaska-5-2005               0.99217    
    ## ref_yeargulf_of_alaska-5-2007               0.92457    
    ## ref_yeargulf_of_alaska-5-2009               0.99739    
    ## ref_yeargulf_of_alaska-5-2011               0.98460    
    ## ref_yeargulf_of_alaska-5-2013               0.97546    
    ## ref_yeargulf_of_alaska-5-2015               0.99490    
    ## ref_yeargulf_of_alaska-5-2017               0.99928    
    ## ref_yeargulf_of_mexico-5-2009               0.88835    
    ## ref_yeargulf_of_mexico-5-2010               0.98651    
    ## ref_yeargulf_of_mexico-5-2011               0.99542    
    ## ref_yeargulf_of_mexico-5-2012               0.99999    
    ## ref_yeargulf_of_mexico-5-2013               0.97905    
    ## ref_yeargulf_of_mexico-5-2014               0.99823    
    ## ref_yeargulf_of_mexico-5-2015               0.99838    
    ## ref_yeargulf_of_mexico-5-2016               0.99924    
    ## ref_yeargulf_of_mexico-5-2017               0.99209    
    ## ref_yeargulf_of_mexico-5-2019               0.96941    
    ## ref_yearie_igfs-10-2004                     0.99494    
    ## ref_yearie_igfs-10-2005                     0.99441    
    ## ref_yearie_igfs-10-2006                     0.99479    
    ## ref_yearie_igfs-10-2007                     0.79716    
    ## ref_yearie_igfs-10-2008                     0.99575    
    ## ref_yearie_igfs-10-2009                     0.99936    
    ## ref_yearie_igfs-10-2010                     0.99996    
    ## ref_yearie_igfs-10-2011                     0.99435    
    ## ref_yearie_igfs-10-2012                     0.97633    
    ## ref_yearie_igfs-10-2013                     0.99812    
    ## ref_yearie_igfs-10-2014                     0.99328    
    ## ref_yearie_igfs-10-2015                     0.65185    
    ## ref_yearie_igfs-10-2016                     0.99936    
    ## ref_yearie_igfs-10-2017                     0.98767    
    ## ref_yearie_igfs-10-2018                     0.96664    
    ## ref_yearie_igfs-10-2019                     0.99505    
    ## ref_yearie_igfs-10-2020                     0.99687    
    ## ref_yearnorbts-1-2005                       0.97935    
    ## ref_yearnorbts-1-2006                       0.79784    
    ## ref_yearnorbts-1-2007                       0.95349    
    ## ref_yearnorbts-1-2008                       0.97178    
    ## ref_yearnorbts-1-2009                       < 2e-16 ***
    ## ref_yearnorbts-1-2010                       0.99295    
    ## ref_yearnorbts-1-2011                       0.98547    
    ## ref_yearnorbts-1-2012                       0.98471    
    ## ref_yearnorbts-1-2013                       0.72240    
    ## ref_yearnorbts-1-2014                       0.97184    
    ## ref_yearnorbts-1-2015                       0.99563    
    ## ref_yearnorbts-1-2016                       0.99618    
    ## ref_yearnorbts-1-2017                       0.99690    
    ## ref_yearnortheast-2-1983                    0.99749    
    ## ref_yearnortheast-2-1984                    0.99954    
    ## ref_yearnortheast-2-1985                    0.99959    
    ## ref_yearnortheast-2-1986                    0.99435    
    ## ref_yearnortheast-2-1987                    0.99612    
    ## ref_yearnortheast-2-1988                    0.99909    
    ## ref_yearnortheast-2-1989                    0.97703    
    ## ref_yearnortheast-2-1990                    0.99563    
    ## ref_yearnortheast-2-1991                    0.99534    
    ## ref_yearnortheast-2-1992                    0.99971    
    ## ref_yearnortheast-2-1993                    0.99350    
    ## ref_yearnortheast-2-1994                    0.97757    
    ## ref_yearnortheast-2-1995                    0.99652    
    ## ref_yearnortheast-2-1996                    0.99267    
    ## ref_yearnortheast-2-1997                    0.99653    
    ## ref_yearnortheast-2-1998                    0.99939    
    ## ref_yearnortheast-2-1999                    0.99977    
    ## ref_yearnortheast-2-2000                    0.99712    
    ## ref_yearnortheast-2-2001                    0.99679    
    ## ref_yearnortheast-2-2002                    0.96993    
    ## ref_yearnortheast-2-2003                    0.98673    
    ## ref_yearnortheast-2-2004                    0.99287    
    ## ref_yearnortheast-2-2005                    0.99820    
    ## ref_yearnortheast-2-2006                    0.99797    
    ## ref_yearnortheast-2-2007                    0.99993    
    ## ref_yearnortheast-2-2008                    0.99644    
    ## ref_yearnortheast-2-2009                    0.99410    
    ## ref_yearnortheast-2-2010                    0.99462    
    ## ref_yearnortheast-2-2011                    0.99789    
    ## ref_yearnortheast-2-2012                    0.99862    
    ## ref_yearnortheast-2-2013                    0.99984    
    ## ref_yearnortheast-2-2014                    0.99843    
    ## ref_yearnortheast-2-2015                    0.99521    
    ## ref_yearnortheast-2-2016                    0.99841    
    ## ref_yearnortheast-2-2017                    0.99761    
    ## ref_yearnortheast-2-2018                    0.98884    
    ## ref_yearnortheast-2-2019                    0.99681    
    ## ref_yearns_ibts-1-1983                      0.99804    
    ## ref_yearns_ibts-1-1984                      0.72046    
    ## ref_yearns_ibts-1-1985                      0.99856    
    ## ref_yearns_ibts-1-1986                      0.99951    
    ## ref_yearns_ibts-1-1987                      0.99032    
    ## ref_yearns_ibts-1-1988                      0.99300    
    ## ref_yearns_ibts-1-1989                      0.92597    
    ## ref_yearns_ibts-1-1990                      0.99676    
    ## ref_yearns_ibts-1-1991                      0.98041    
    ## ref_yearns_ibts-1-1992                      0.99113    
    ## ref_yearns_ibts-1-1993                      0.99879    
    ## ref_yearns_ibts-1-1994                      0.99372    
    ## ref_yearns_ibts-1-1995                      0.99826    
    ## ref_yearns_ibts-1-1996                      0.98813    
    ## ref_yearns_ibts-1-1997                      0.99993    
    ## ref_yearns_ibts-1-1998                      0.99062    
    ## ref_yearns_ibts-1-1999                      0.99463    
    ## ref_yearns_ibts-1-2000                      0.99964    
    ## ref_yearns_ibts-1-2001                      0.97588    
    ## ref_yearns_ibts-1-2002                      0.99632    
    ## ref_yearns_ibts-1-2003                      0.54845    
    ## ref_yearns_ibts-1-2004                      0.99903    
    ## ref_yearns_ibts-1-2005                      0.99883    
    ## ref_yearns_ibts-1-2006                      0.99980    
    ## ref_yearns_ibts-1-2007                      0.97515    
    ## ref_yearns_ibts-1-2008                      0.99796    
    ## ref_yearns_ibts-1-2009                      0.99091    
    ## ref_yearns_ibts-1-2010                      0.99573    
    ## ref_yearns_ibts-1-2011                      0.77997    
    ## ref_yearns_ibts-1-2012                      0.75576    
    ## ref_yearns_ibts-1-2013                      0.99717    
    ## ref_yearns_ibts-1-2014                      0.99465    
    ## ref_yearns_ibts-1-2015                      0.99626    
    ## ref_yearns_ibts-1-2016                      0.98331    
    ## ref_yearns_ibts-1-2017                      0.56118    
    ## ref_yearns_ibts-1-2018                      0.99000    
    ## ref_yearns_ibts-1-2019                      0.99922    
    ## ref_yearns_ibts-1-2020                      0.99978    
    ## ref_yearpt_ibts-9-2005                      0.98845    
    ## ref_yearpt_ibts-9-2006                      0.99949    
    ## ref_yearpt_ibts-9-2007                      0.99865    
    ## ref_yearpt_ibts-9-2008                      0.98548    
    ## ref_yearpt_ibts-9-2009                      0.99954    
    ## ref_yearpt_ibts-9-2010                      0.99904    
    ## ref_yearpt_ibts-9-2011                      0.99678    
    ## ref_yearpt_ibts-9-2013                      0.97112    
    ## ref_yearpt_ibts-9-2014                      0.99294    
    ## ref_yearpt_ibts-9-2015                      0.89513    
    ## ref_yearpt_ibts-9-2016                      0.99237    
    ## ref_yearpt_ibts-9-2017                      0.97571    
    ## ref_yearpt_ibts-9-2018                      0.99096    
    ## ref_yearrockall-8-2001                      0.99543    
    ## ref_yearrockall-8-2002                      0.99631    
    ## ref_yearrockall-8-2003                      0.95042    
    ## ref_yearrockall-8-2005                      0.99372    
    ## ref_yearrockall-8-2006                      0.99662    
    ## ref_yearrockall-8-2007                      0.99888    
    ## ref_yearrockall-8-2008                      0.99783    
    ## ref_yearrockall-8-2009                      0.99966    
    ## ref_yearrockall-8-2011                     5.68e-05 ***
    ## ref_yearrockall-8-2012                      0.99924    
    ## ref_yearrockall-8-2013                      0.97820    
    ## ref_yearrockall-8-2014                      0.99017    
    ## ref_yearrockall-8-2015                      0.99572    
    ## ref_yearrockall-8-2016                      0.98831    
    ## ref_yearrockall-8-2017                      0.99393    
    ## ref_yearrockall-8-2018                      0.99743    
    ## ref_yearrockall-8-2019                      0.99955    
    ## ref_yearrockall-8-2020                      0.99329    
    ## ref_yearscotian_shelf-6-1983                0.99947    
    ## ref_yearscotian_shelf-6-1984                0.99358    
    ## ref_yearscotian_shelf-6-1985                0.99876    
    ## ref_yearscotian_shelf-6-1987                0.99673    
    ## ref_yearscotian_shelf-6-1988                0.99829    
    ## ref_yearscotian_shelf-6-1989                0.99756    
    ## ref_yearscotian_shelf-6-1990                0.99379    
    ## ref_yearscotian_shelf-6-1991                0.97246    
    ## ref_yearscotian_shelf-6-1992                0.99501    
    ## ref_yearscotian_shelf-6-1993                0.99901    
    ## ref_yearscotian_shelf-6-1994                0.99971    
    ## ref_yearscotian_shelf-6-1995                0.99086    
    ## ref_yearscotian_shelf-6-1996                0.99429    
    ## ref_yearscotian_shelf-6-1997                0.99579    
    ## ref_yearscotian_shelf-6-1998                0.99685    
    ## ref_yearscotian_shelf-6-1999                0.99684    
    ## ref_yearscotian_shelf-6-2000                0.99854    
    ## ref_yearscotian_shelf-6-2001                0.99766    
    ## ref_yearscotian_shelf-6-2002                0.99426    
    ## ref_yearscotian_shelf-6-2003                0.99559    
    ## ref_yearscotian_shelf-6-2004                0.99883    
    ## ref_yearscotian_shelf-6-2005                0.99785    
    ## ref_yearscotian_shelf-6-2006                0.99818    
    ## ref_yearscotian_shelf-6-2007                0.99670    
    ## ref_yearscotian_shelf-6-2008                0.99621    
    ## ref_yearscotian_shelf-6-2009                0.99359    
    ## ref_yearscotian_shelf-6-2010                0.99606    
    ## ref_yearscotian_shelf-6-2011                0.99968    
    ## ref_yearscotian_shelf-6-2012                0.99843    
    ## ref_yearscotian_shelf-6-2013                0.99717    
    ## ref_yearscotian_shelf-6-2014                0.99890    
    ## ref_yearscotian_shelf-6-2015                0.99600    
    ## ref_yearscotian_shelf-6-2016                0.99788    
    ## ref_yearscotian_shelf-6-2017                0.98954    
    ## ref_yearsoutheast-4-1990                    0.99757    
    ## ref_yearsoutheast-4-1991                    0.99720    
    ## ref_yearsoutheast-4-1992                    0.99631    
    ## ref_yearsoutheast-4-1993                    0.99971    
    ## ref_yearsoutheast-4-1994                    0.99891    
    ## ref_yearsoutheast-4-1995                    0.99406    
    ## ref_yearsoutheast-4-1996                    0.99545    
    ## ref_yearsoutheast-4-1997                    0.99879    
    ## ref_yearsoutheast-4-1998                    0.99652    
    ## ref_yearsoutheast-4-1999                    0.99984    
    ## ref_yearsoutheast-4-2000                    0.99585    
    ## ref_yearsoutheast-4-2001                    0.99912    
    ## ref_yearsoutheast-4-2002                    0.99381    
    ## ref_yearsoutheast-4-2003                    0.99889    
    ## ref_yearsoutheast-4-2004                    0.99981    
    ## ref_yearsoutheast-4-2005                    0.99773    
    ## ref_yearsoutheast-4-2006                    0.99827    
    ## ref_yearsoutheast-4-2007                    0.99705    
    ## ref_yearsoutheast-4-2008                    0.99765    
    ## ref_yearsoutheast-4-2009                    0.99240    
    ## ref_yearsoutheast-4-2010                    0.99750    
    ## ref_yearsoutheast-4-2011                    0.98529    
    ## ref_yearsoutheast-4-2012                    0.97088    
    ## ref_yearsoutheast-4-2013                    0.98882    
    ## ref_yearsoutheast-4-2014                    0.99375    
    ## ref_yearsoutheast-4-2015                    0.96473    
    ## ref_yearsoutheast-4-2016                    0.99904    
    ## ref_yearsoutheast-4-2017                    0.96810    
    ## ref_yearsoutheast-4-2018                    0.99773    
    ## ref_yearswc_ibts-1-1986                     0.99586    
    ## ref_yearswc_ibts-1-1987                     0.99541    
    ## ref_yearswc_ibts-1-1988                     0.93212    
    ## ref_yearswc_ibts-1-1989                     0.99991    
    ## ref_yearswc_ibts-1-1990                     0.90642    
    ## ref_yearswc_ibts-1-1991                     0.99950    
    ## ref_yearswc_ibts-1-1992                     0.88868    
    ## ref_yearswc_ibts-1-1993                     0.98021    
    ## ref_yearswc_ibts-1-1994                     0.99991    
    ## ref_yearswc_ibts-1-1995                     0.89376    
    ## ref_yearswc_ibts-1-1996                     0.99903    
    ## ref_yearswc_ibts-1-1997                     0.99728    
    ## ref_yearswc_ibts-1-1998                     0.99854    
    ## ref_yearswc_ibts-1-1999                     0.99555    
    ## ref_yearswc_ibts-1-2000                     0.91560    
    ## ref_yearswc_ibts-1-2001                     0.99779    
    ## ref_yearswc_ibts-1-2002                     0.99833    
    ## ref_yearswc_ibts-1-2003                     0.98462    
    ## ref_yearswc_ibts-1-2004                     0.99667    
    ## ref_yearswc_ibts-1-2005                     0.99596    
    ## ref_yearswc_ibts-1-2006                     0.79624    
    ## ref_yearswc_ibts-1-2007                     0.99125    
    ## ref_yearswc_ibts-1-2008                     0.99948    
    ## ref_yearswc_ibts-1-2009                     0.99494    
    ## ref_yearswc_ibts-1-2010                     0.98567    
    ## ref_yearswc_ibts-1-2011                     0.98453    
    ## ref_yearswc_ibts-1-2012                     0.99531    
    ## ref_yearswc_ibts-1-2013                     0.95097    
    ## ref_yearswc_ibts-1-2014                     0.99714    
    ## ref_yearswc_ibts-1-2015                     0.99976    
    ## ref_yearswc_ibts-1-2016                     0.99645    
    ## ref_yearswc_ibts-1-2017                     0.99703    
    ## ref_yearswc_ibts-1-2018                     0.99571    
    ## ref_yearswc_ibts-1-2019                     0.98358    
    ## ref_yearswc_ibts-1-2020                     0.99333    
    ## ref_yearwest_coast-5-1986                   0.99954    
    ## ref_yearwest_coast-5-1989                   0.99057    
    ## ref_yearwest_coast-5-1992                   0.99478    
    ## ref_yearwest_coast-5-1995                   0.99757    
    ## ref_yearwest_coast-5-1998                   0.99545    
    ## ref_yearwest_coast-5-2001                   0.96722    
    ## ref_yearwest_coast-5-2003                   0.35122    
    ## ref_yearwest_coast-5-2004                   0.94291    
    ## ref_yearwest_coast-5-2005                   0.99631    
    ## ref_yearwest_coast-5-2006                   0.96947    
    ## ref_yearwest_coast-5-2007                   0.89059    
    ## ref_yearwest_coast-5-2008                   0.99416    
    ## ref_yearwest_coast-5-2009                   0.94009    
    ## ref_yearwest_coast-5-2010                   0.97304    
    ## ref_yearwest_coast-5-2011                   0.93206    
    ## ref_yearwest_coast-5-2012                   0.96142    
    ## ref_yearwest_coast-5-2013                   0.93735    
    ## ref_yearwest_coast-5-2014                   0.98913    
    ## ref_yearwest_coast-5-2015                   0.99144    
    ## ref_yearwest_coast-5-2016                   0.99792    
    ## ref_yearwest_coast-5-2017                   0.99989    
    ## ref_yearwest_coast-5-2018                   0.93182    
    ## ref_yearwest_coast-5-2019                        NA    
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
    ## anomIntC:ref_yearbits-2-1993                     NA    
    ## anomIntC:ref_yearbits-2-1994                     NA    
    ## anomIntC:ref_yearbits-2-1995                     NA    
    ## anomIntC:ref_yearbits-2-1996                     NA    
    ## anomIntC:ref_yearbits-2-1997                     NA    
    ## anomIntC:ref_yearbits-2-1998                     NA    
    ## anomIntC:ref_yearbits-2-1999                     NA    
    ## anomIntC:ref_yearbits-2-2000                     NA    
    ## anomIntC:ref_yearbits-2-2001                     NA    
    ## anomIntC:ref_yearbits-2-2002                     NA    
    ## anomIntC:ref_yearbits-2-2003                     NA    
    ## anomIntC:ref_yearbits-2-2004                     NA    
    ## anomIntC:ref_yearbits-2-2005                     NA    
    ## anomIntC:ref_yearbits-2-2006                     NA    
    ## anomIntC:ref_yearbits-2-2007                     NA    
    ## anomIntC:ref_yearbits-2-2008                     NA    
    ## anomIntC:ref_yearbits-2-2009                     NA    
    ## anomIntC:ref_yearbits-2-2010                     NA    
    ## anomIntC:ref_yearbits-2-2011                     NA    
    ## anomIntC:ref_yearbits-2-2012                     NA    
    ## anomIntC:ref_yearbits-2-2013                     NA    
    ## anomIntC:ref_yearbits-2-2014                     NA    
    ## anomIntC:ref_yearbits-2-2015                     NA    
    ## anomIntC:ref_yearbits-2-2016                     NA    
    ## anomIntC:ref_yearbits-2-2017                     NA    
    ## anomIntC:ref_yearbits-2-2018                     NA    
    ## anomIntC:ref_yearbits-2-2019                     NA    
    ## anomIntC:ref_yearbits-2-2020                     NA    
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
    ## anomIntC:ref_yearevhoe-10-1998                   NA    
    ## anomIntC:ref_yearevhoe-10-1999                   NA    
    ## anomIntC:ref_yearevhoe-10-2000                   NA    
    ## anomIntC:ref_yearevhoe-10-2001                   NA    
    ## anomIntC:ref_yearevhoe-10-2002                   NA    
    ## anomIntC:ref_yearevhoe-10-2003                   NA    
    ## anomIntC:ref_yearevhoe-10-2004                   NA    
    ## anomIntC:ref_yearevhoe-10-2005                   NA    
    ## anomIntC:ref_yearevhoe-10-2006                   NA    
    ## anomIntC:ref_yearevhoe-10-2007                   NA    
    ## anomIntC:ref_yearevhoe-10-2008                   NA    
    ## anomIntC:ref_yearevhoe-10-2009                   NA    
    ## anomIntC:ref_yearevhoe-10-2010                   NA    
    ## anomIntC:ref_yearevhoe-10-2011                   NA    
    ## anomIntC:ref_yearevhoe-10-2012                   NA    
    ## anomIntC:ref_yearevhoe-10-2013                   NA    
    ## anomIntC:ref_yearevhoe-10-2014                   NA    
    ## anomIntC:ref_yearevhoe-10-2015                   NA    
    ## anomIntC:ref_yearevhoe-10-2016                   NA    
    ## anomIntC:ref_yearevhoe-10-2017                   NA    
    ## anomIntC:ref_yearevhoe-10-2018                   NA    
    ## anomIntC:ref_yearevhoe-10-2019                   NA    
    ## anomIntC:ref_yearevhoe-10-2020                   NA    
    ## anomIntC:ref_yearfr_cgfs-10-1999                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2000                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2001                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2002                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2003                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2004                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2005                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2006                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2007                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2008                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2009                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2010                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2011                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2012                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2013                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2014                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2015                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2016                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2017                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2018                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2019                 NA    
    ## anomIntC:ref_yearfr_cgfs-10-2020                 NA    
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
    ## anomIntC:ref_yeargulf_of_mexico-5-2009           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2010           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2011           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2012           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2013           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2014           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2015           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2016           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2017           NA    
    ## anomIntC:ref_yeargulf_of_mexico-5-2019           NA    
    ## anomIntC:ref_yearie_igfs-10-2004                 NA    
    ## anomIntC:ref_yearie_igfs-10-2005                 NA    
    ## anomIntC:ref_yearie_igfs-10-2006                 NA    
    ## anomIntC:ref_yearie_igfs-10-2007                 NA    
    ## anomIntC:ref_yearie_igfs-10-2008                 NA    
    ## anomIntC:ref_yearie_igfs-10-2009                 NA    
    ## anomIntC:ref_yearie_igfs-10-2010                 NA    
    ## anomIntC:ref_yearie_igfs-10-2011                 NA    
    ## anomIntC:ref_yearie_igfs-10-2012                 NA    
    ## anomIntC:ref_yearie_igfs-10-2013                 NA    
    ## anomIntC:ref_yearie_igfs-10-2014                 NA    
    ## anomIntC:ref_yearie_igfs-10-2015                 NA    
    ## anomIntC:ref_yearie_igfs-10-2016                 NA    
    ## anomIntC:ref_yearie_igfs-10-2017                 NA    
    ## anomIntC:ref_yearie_igfs-10-2018                 NA    
    ## anomIntC:ref_yearie_igfs-10-2019                 NA    
    ## anomIntC:ref_yearie_igfs-10-2020                 NA    
    ## anomIntC:ref_yearnorbts-1-2005                   NA    
    ## anomIntC:ref_yearnorbts-1-2006                   NA    
    ## anomIntC:ref_yearnorbts-1-2007                   NA    
    ## anomIntC:ref_yearnorbts-1-2008                   NA    
    ## anomIntC:ref_yearnorbts-1-2009                   NA    
    ## anomIntC:ref_yearnorbts-1-2010                   NA    
    ## anomIntC:ref_yearnorbts-1-2011                   NA    
    ## anomIntC:ref_yearnorbts-1-2012                   NA    
    ## anomIntC:ref_yearnorbts-1-2013                   NA    
    ## anomIntC:ref_yearnorbts-1-2014                   NA    
    ## anomIntC:ref_yearnorbts-1-2015                   NA    
    ## anomIntC:ref_yearnorbts-1-2016                   NA    
    ## anomIntC:ref_yearnorbts-1-2017                   NA    
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
    ## anomIntC:ref_yearnortheast-2-2019                NA    
    ## anomIntC:ref_yearns_ibts-1-1983                  NA    
    ## anomIntC:ref_yearns_ibts-1-1984                  NA    
    ## anomIntC:ref_yearns_ibts-1-1985                  NA    
    ## anomIntC:ref_yearns_ibts-1-1986                  NA    
    ## anomIntC:ref_yearns_ibts-1-1987                  NA    
    ## anomIntC:ref_yearns_ibts-1-1988                  NA    
    ## anomIntC:ref_yearns_ibts-1-1989                  NA    
    ## anomIntC:ref_yearns_ibts-1-1990                  NA    
    ## anomIntC:ref_yearns_ibts-1-1991                  NA    
    ## anomIntC:ref_yearns_ibts-1-1992                  NA    
    ## anomIntC:ref_yearns_ibts-1-1993                  NA    
    ## anomIntC:ref_yearns_ibts-1-1994                  NA    
    ## anomIntC:ref_yearns_ibts-1-1995                  NA    
    ## anomIntC:ref_yearns_ibts-1-1996                  NA    
    ## anomIntC:ref_yearns_ibts-1-1997                  NA    
    ## anomIntC:ref_yearns_ibts-1-1998                  NA    
    ## anomIntC:ref_yearns_ibts-1-1999                  NA    
    ## anomIntC:ref_yearns_ibts-1-2000                  NA    
    ## anomIntC:ref_yearns_ibts-1-2001                  NA    
    ## anomIntC:ref_yearns_ibts-1-2002                  NA    
    ## anomIntC:ref_yearns_ibts-1-2003                  NA    
    ## anomIntC:ref_yearns_ibts-1-2004                  NA    
    ## anomIntC:ref_yearns_ibts-1-2005                  NA    
    ## anomIntC:ref_yearns_ibts-1-2006                  NA    
    ## anomIntC:ref_yearns_ibts-1-2007                  NA    
    ## anomIntC:ref_yearns_ibts-1-2008                  NA    
    ## anomIntC:ref_yearns_ibts-1-2009                  NA    
    ## anomIntC:ref_yearns_ibts-1-2010                  NA    
    ## anomIntC:ref_yearns_ibts-1-2011                  NA    
    ## anomIntC:ref_yearns_ibts-1-2012                  NA    
    ## anomIntC:ref_yearns_ibts-1-2013                  NA    
    ## anomIntC:ref_yearns_ibts-1-2014                  NA    
    ## anomIntC:ref_yearns_ibts-1-2015                  NA    
    ## anomIntC:ref_yearns_ibts-1-2016                  NA    
    ## anomIntC:ref_yearns_ibts-1-2017                  NA    
    ## anomIntC:ref_yearns_ibts-1-2018                  NA    
    ## anomIntC:ref_yearns_ibts-1-2019                  NA    
    ## anomIntC:ref_yearns_ibts-1-2020                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2005                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2006                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2007                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2008                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2009                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2010                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2011                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2013                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2014                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2015                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2016                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2017                  NA    
    ## anomIntC:ref_yearpt_ibts-9-2018                  NA    
    ## anomIntC:ref_yearrockall-8-2001                  NA    
    ## anomIntC:ref_yearrockall-8-2002                  NA    
    ## anomIntC:ref_yearrockall-8-2003                  NA    
    ## anomIntC:ref_yearrockall-8-2005                  NA    
    ## anomIntC:ref_yearrockall-8-2006                  NA    
    ## anomIntC:ref_yearrockall-8-2007                  NA    
    ## anomIntC:ref_yearrockall-8-2008                  NA    
    ## anomIntC:ref_yearrockall-8-2009                  NA    
    ## anomIntC:ref_yearrockall-8-2011                  NA    
    ## anomIntC:ref_yearrockall-8-2012                  NA    
    ## anomIntC:ref_yearrockall-8-2013                  NA    
    ## anomIntC:ref_yearrockall-8-2014                  NA    
    ## anomIntC:ref_yearrockall-8-2015                  NA    
    ## anomIntC:ref_yearrockall-8-2016                  NA    
    ## anomIntC:ref_yearrockall-8-2017                  NA    
    ## anomIntC:ref_yearrockall-8-2018                  NA    
    ## anomIntC:ref_yearrockall-8-2019                  NA    
    ## anomIntC:ref_yearrockall-8-2020                  NA    
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
    ## anomIntC:ref_yearswc_ibts-1-1986                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1987                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1988                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1989                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1990                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1991                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1992                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1993                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1994                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1995                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1996                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1997                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1998                 NA    
    ## anomIntC:ref_yearswc_ibts-1-1999                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2000                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2001                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2002                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2003                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2004                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2005                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2006                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2007                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2008                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2009                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2010                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2011                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2012                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2013                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2014                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2015                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2016                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2017                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2018                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2019                 NA    
    ## anomIntC:ref_yearswc_ibts-1-2020                 NA    
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
    ## anomIntC:ref_yearwest_coast-5-2019               NA    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1041 on 41367 degrees of freedom
    ## Multiple R-squared:  0.01754,    Adjusted R-squared:  0.008021 
    ## F-statistic: 1.842 on 401 and 41367 DF,  p-value: < 2.2e-16

    ## # A tibble: 3 x 5
    ##   term                              estimate std.error statistic   p.value
    ##   <chr>                                <dbl>     <dbl>     <dbl>     <dbl>
    ## 1 ref_yeareastern_bering_sea-5-2011     341.      109.      3.11 1.86e-  3
    ## 2 ref_yearnorbts-1-2009                3714.      154.     24.2  3.84e-128
    ## 3 ref_yearrockall-8-2011                743.      185.      4.03 5.68e-  5

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ ref_year, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##  -3716     -5     -2     -1 199129 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                        1.199e+00  1.091e+02   0.011  0.99123    
    ## ref_yearaleutian_islands-5-1991    4.860e+00  1.501e+02   0.032  0.97417    
    ## ref_yearaleutian_islands-5-1994    6.855e+00  1.402e+02   0.049  0.96100    
    ## ref_yearaleutian_islands-5-1997    3.891e+00  1.368e+02   0.028  0.97732    
    ## ref_yearaleutian_islands-5-2000    6.448e+00  1.351e+02   0.048  0.96193    
    ## ref_yearaleutian_islands-5-2002   -6.772e-01  1.352e+02  -0.005  0.99600    
    ## ref_yearaleutian_islands-5-2004    9.669e-01  1.348e+02   0.007  0.99428    
    ## ref_yearaleutian_islands-5-2006    2.991e+01  1.351e+02   0.221  0.82477    
    ## ref_yearaleutian_islands-5-2010   -2.697e-01  1.350e+02  -0.002  0.99841    
    ## ref_yearaleutian_islands-5-2012    1.330e+00  1.348e+02   0.010  0.99213    
    ## ref_yearaleutian_islands-5-2014    3.931e+00  1.351e+02   0.029  0.97679    
    ## ref_yearaleutian_islands-5-2016   -2.688e-01  1.357e+02  -0.002  0.99842    
    ## ref_yearaleutian_islands-5-2018    1.221e+00  1.358e+02   0.009  0.99282    
    ## ref_yearbits-2-1993               -3.248e-01  2.192e+02  -0.001  0.99882    
    ## ref_yearbits-2-1994                1.154e-01  2.220e+02   0.001  0.99959    
    ## ref_yearbits-2-1995                4.473e+00  2.315e+02   0.019  0.98459    
    ## ref_yearbits-2-1996                1.700e+01  2.473e+02   0.069  0.94521    
    ## ref_yearbits-2-1997               -2.173e-01  2.030e+02  -0.001  0.99915    
    ## ref_yearbits-2-1998               -1.542e+00  2.116e+02  -0.007  0.99418    
    ## ref_yearbits-2-1999                2.364e+01  2.626e+02   0.090  0.92827    
    ## ref_yearbits-2-2000               -5.631e-01  1.883e+02  -0.003  0.99761    
    ## ref_yearbits-2-2001                6.683e+01  1.958e+02   0.341  0.73288    
    ## ref_yearbits-2-2002               -1.244e+00  1.810e+02  -0.007  0.99451    
    ## ref_yearbits-2-2003                4.781e+00  1.857e+02   0.026  0.97946    
    ## ref_yearbits-2-2004                1.006e+00  1.833e+02   0.005  0.99562    
    ## ref_yearbits-2-2005                7.337e-01  1.778e+02   0.004  0.99671    
    ## ref_yearbits-2-2006                9.546e+00  1.810e+02   0.053  0.95794    
    ## ref_yearbits-2-2007                1.913e+00  1.799e+02   0.011  0.99152    
    ## ref_yearbits-2-2008               -6.165e-01  1.778e+02  -0.003  0.99723    
    ## ref_yearbits-2-2009                6.763e-01  1.759e+02   0.004  0.99693    
    ## ref_yearbits-2-2010                2.182e+01  1.788e+02   0.122  0.90289    
    ## ref_yearbits-2-2011               -4.071e-01  1.698e+02  -0.002  0.99809    
    ## ref_yearbits-2-2012                6.126e+00  1.833e+02   0.033  0.97333    
    ## ref_yearbits-2-2013                1.329e+00  1.799e+02   0.007  0.99411    
    ## ref_yearbits-2-2014                1.109e+00  1.740e+02   0.006  0.99491    
    ## ref_yearbits-2-2015                6.504e+00  1.740e+02   0.037  0.97018    
    ## ref_yearbits-2-2016                6.725e-01  1.723e+02   0.004  0.99689    
    ## ref_yearbits-2-2017                7.448e-01  1.788e+02   0.004  0.99668    
    ## ref_yearbits-2-2018               -5.042e-01  1.723e+02  -0.003  0.99766    
    ## ref_yearbits-2-2019                7.779e+00  1.706e+02   0.046  0.96364    
    ## ref_yearbits-2-2020                5.921e-01  1.698e+02   0.003  0.99722    
    ## ref_yeareastern_bering_sea-5-1983  1.831e+00  1.435e+02   0.013  0.98982    
    ## ref_yeareastern_bering_sea-5-1984  3.260e+01  1.382e+02   0.236  0.81346    
    ## ref_yeareastern_bering_sea-5-1985  8.721e+00  1.365e+02   0.064  0.94907    
    ## ref_yeareastern_bering_sea-5-1986  7.389e+00  1.361e+02   0.054  0.95670    
    ## ref_yeareastern_bering_sea-5-1987  1.600e+01  1.362e+02   0.117  0.90653    
    ## ref_yeareastern_bering_sea-5-1988  1.123e+01  1.361e+02   0.083  0.93423    
    ## ref_yeareastern_bering_sea-5-1989  4.707e-01  1.355e+02   0.003  0.99723    
    ## ref_yeareastern_bering_sea-5-1990  1.902e+01  1.364e+02   0.139  0.88911    
    ## ref_yeareastern_bering_sea-5-1991  7.528e-01  1.367e+02   0.006  0.99561    
    ## ref_yeareastern_bering_sea-5-1992  2.378e+00  1.377e+02   0.017  0.98622    
    ## ref_yeareastern_bering_sea-5-1993 -3.330e-01  1.382e+02  -0.002  0.99808    
    ## ref_yeareastern_bering_sea-5-1994  2.256e+00  1.378e+02   0.016  0.98694    
    ## ref_yeareastern_bering_sea-5-1995 -6.016e-01  1.382e+02  -0.004  0.99653    
    ## ref_yeareastern_bering_sea-5-1996  1.706e+00  1.378e+02   0.012  0.99013    
    ## ref_yeareastern_bering_sea-5-1997  6.709e-01  1.367e+02   0.005  0.99608    
    ## ref_yeareastern_bering_sea-5-1998  3.751e+00  1.359e+02   0.028  0.97799    
    ## ref_yeareastern_bering_sea-5-1999  6.835e-01  1.362e+02   0.005  0.99600    
    ## ref_yeareastern_bering_sea-5-2000  2.600e+00  1.358e+02   0.019  0.98472    
    ## ref_yeareastern_bering_sea-5-2001  1.990e+01  1.370e+02   0.145  0.88449    
    ## ref_yeareastern_bering_sea-5-2002  2.198e+00  1.357e+02   0.016  0.98707    
    ## ref_yeareastern_bering_sea-5-2003  4.241e+00  1.359e+02   0.031  0.97511    
    ## ref_yeareastern_bering_sea-5-2004  5.517e+00  1.358e+02   0.041  0.96760    
    ## ref_yeareastern_bering_sea-5-2005  2.427e+01  1.364e+02   0.178  0.85876    
    ## ref_yeareastern_bering_sea-5-2006  1.255e+00  1.364e+02   0.009  0.99266    
    ## ref_yeareastern_bering_sea-5-2007  3.667e+00  1.359e+02   0.027  0.97848    
    ## ref_yeareastern_bering_sea-5-2008 -5.990e-01  1.364e+02  -0.004  0.99650    
    ## ref_yeareastern_bering_sea-5-2009 -4.857e-01  1.364e+02  -0.004  0.99716    
    ## ref_yeareastern_bering_sea-5-2010  7.121e+01  1.362e+02   0.523  0.60117    
    ## ref_yeareastern_bering_sea-5-2011  3.408e+02  1.362e+02   2.501  0.01238 *  
    ## ref_yeareastern_bering_sea-5-2012  5.507e+00  1.364e+02   0.040  0.96779    
    ## ref_yeareastern_bering_sea-5-2013  1.972e+00  1.365e+02   0.014  0.98848    
    ## ref_yeareastern_bering_sea-5-2014 -2.612e-01  1.358e+02  -0.002  0.99847    
    ## ref_yeareastern_bering_sea-5-2015  5.431e-01  1.364e+02   0.004  0.99682    
    ## ref_yeareastern_bering_sea-5-2016  3.044e+00  1.365e+02   0.022  0.98221    
    ## ref_yeareastern_bering_sea-5-2017 -1.211e+00  1.361e+02  -0.009  0.99290    
    ## ref_yeareastern_bering_sea-5-2018  4.823e+00  1.364e+02   0.035  0.97179    
    ## ref_yearevhoe-10-1998             -5.157e-01  1.478e+02  -0.003  0.99722    
    ## ref_yearevhoe-10-1999              1.822e+00  1.472e+02   0.012  0.99013    
    ## ref_yearevhoe-10-2000              8.627e-01  1.447e+02   0.006  0.99524    
    ## ref_yearevhoe-10-2001              8.104e-01  1.491e+02   0.005  0.99566    
    ## ref_yearevhoe-10-2002              2.047e-01  1.423e+02   0.001  0.99885    
    ## ref_yearevhoe-10-2003              4.488e-01  1.437e+02   0.003  0.99751    
    ## ref_yearevhoe-10-2004             -2.123e-01  1.450e+02  -0.001  0.99883    
    ## ref_yearevhoe-10-2005             -3.026e-01  1.452e+02  -0.002  0.99834    
    ## ref_yearevhoe-10-2006             -5.905e-01  1.458e+02  -0.004  0.99677    
    ## ref_yearevhoe-10-2007              9.663e-01  1.428e+02   0.007  0.99460    
    ## ref_yearevhoe-10-2008              6.718e+00  1.414e+02   0.048  0.96211    
    ## ref_yearevhoe-10-2009              2.006e-01  1.437e+02   0.001  0.99889    
    ## ref_yearevhoe-10-2010              6.628e-02  1.428e+02   0.000  0.99963    
    ## ref_yearevhoe-10-2011              1.896e-02  1.437e+02   0.000  0.99989    
    ## ref_yearevhoe-10-2012              3.399e-02  1.410e+02   0.000  0.99981    
    ## ref_yearevhoe-10-2013              9.880e+00  1.435e+02   0.069  0.94510    
    ## ref_yearevhoe-10-2014             -6.092e-01  1.419e+02  -0.004  0.99657    
    ## ref_yearevhoe-10-2015              2.166e+01  1.421e+02   0.152  0.87882    
    ## ref_yearevhoe-10-2016              3.237e+00  1.442e+02   0.022  0.98209    
    ## ref_yearevhoe-10-2017              3.955e+00  1.425e+02   0.028  0.97786    
    ## ref_yearevhoe-10-2018              8.901e+00  1.624e+02   0.055  0.95628    
    ## ref_yearevhoe-10-2019              3.335e-01  1.430e+02   0.002  0.99814    
    ## ref_yearevhoe-10-2020             -6.154e-01  1.419e+02  -0.004  0.99654    
    ## ref_yearfr_cgfs-10-1999           -2.457e-01  1.845e+02  -0.001  0.99894    
    ## ref_yearfr_cgfs-10-2000           -1.326e+00  1.845e+02  -0.007  0.99426    
    ## ref_yearfr_cgfs-10-2001           -1.114e+00  1.927e+02  -0.006  0.99539    
    ## ref_yearfr_cgfs-10-2002            1.977e-01  1.912e+02   0.001  0.99917    
    ## ref_yearfr_cgfs-10-2003           -8.150e-01  1.883e+02  -0.004  0.99655    
    ## ref_yearfr_cgfs-10-2004           -8.503e-01  1.870e+02  -0.005  0.99637    
    ## ref_yearfr_cgfs-10-2005           -2.322e-03  1.883e+02   0.000  0.99999    
    ## ref_yearfr_cgfs-10-2006           -7.308e-01  1.897e+02  -0.004  0.99693    
    ## ref_yearfr_cgfs-10-2007            9.078e-01  1.857e+02   0.005  0.99610    
    ## ref_yearfr_cgfs-10-2008           -1.488e-01  1.857e+02  -0.001  0.99936    
    ## ref_yearfr_cgfs-10-2009           -2.203e-01  1.833e+02  -0.001  0.99904    
    ## ref_yearfr_cgfs-10-2010            7.952e-01  1.845e+02   0.004  0.99656    
    ## ref_yearfr_cgfs-10-2011            1.840e-01  1.883e+02   0.001  0.99922    
    ## ref_yearfr_cgfs-10-2012            5.197e-01  1.788e+02   0.003  0.99768    
    ## ref_yearfr_cgfs-10-2013            2.800e+00  1.821e+02   0.015  0.98773    
    ## ref_yearfr_cgfs-10-2014            3.211e+00  1.810e+02   0.018  0.98584    
    ## ref_yearfr_cgfs-10-2015            7.011e+00  1.845e+02   0.038  0.96969    
    ## ref_yearfr_cgfs-10-2016           -8.700e-01  1.833e+02  -0.005  0.99621    
    ## ref_yearfr_cgfs-10-2017            3.694e+00  1.821e+02   0.020  0.98382    
    ## ref_yearfr_cgfs-10-2018            3.909e+00  1.810e+02   0.022  0.98277    
    ## ref_yearfr_cgfs-10-2019            7.543e-01  1.845e+02   0.004  0.99674    
    ## ref_yearfr_cgfs-10-2020           -6.577e-01  1.788e+02  -0.004  0.99707    
    ## ref_yeargulf_of_alaska-5-1987      9.247e-01  1.378e+02   0.007  0.99465    
    ## ref_yeargulf_of_alaska-5-1990      6.110e+00  1.359e+02   0.045  0.96415    
    ## ref_yeargulf_of_alaska-5-1993      4.758e+00  1.330e+02   0.036  0.97145    
    ## ref_yeargulf_of_alaska-5-1996      4.547e+00  1.296e+02   0.035  0.97201    
    ## ref_yeargulf_of_alaska-5-1999      7.485e-01  1.285e+02   0.006  0.99535    
    ## ref_yeargulf_of_alaska-5-2003      9.376e+00  1.285e+02   0.073  0.94185    
    ## ref_yeargulf_of_alaska-5-2005      2.407e+00  1.284e+02   0.019  0.98504    
    ## ref_yeargulf_of_alaska-5-2007      2.033e+01  1.285e+02   0.158  0.87424    
    ## ref_yeargulf_of_alaska-5-2009      4.277e-01  1.285e+02   0.003  0.99734    
    ## ref_yeargulf_of_alaska-5-2011      2.026e+00  1.285e+02   0.016  0.98742    
    ## ref_yeargulf_of_alaska-5-2013      3.177e+00  1.287e+02   0.025  0.98031    
    ## ref_yeargulf_of_alaska-5-2015      7.654e-01  1.291e+02   0.006  0.99527    
    ## ref_yeargulf_of_alaska-5-2017      1.163e-01  1.287e+02   0.001  0.99928    
    ## ref_yeargulf_of_mexico-5-2009      1.330e+01  1.241e+02   0.107  0.91468    
    ## ref_yeargulf_of_mexico-5-2010      1.773e+00  1.231e+02   0.014  0.98851    
    ## ref_yeargulf_of_mexico-5-2011      8.655e-01  1.231e+02   0.007  0.99439    
    ## ref_yeargulf_of_mexico-5-2012     -3.595e-01  1.231e+02  -0.003  0.99767    
    ## ref_yeargulf_of_mexico-5-2013      2.535e+00  1.231e+02   0.021  0.98357    
    ## ref_yeargulf_of_mexico-5-2014      3.077e-01  1.232e+02   0.002  0.99801    
    ## ref_yeargulf_of_mexico-5-2015      3.485e-01  1.231e+02   0.003  0.99774    
    ## ref_yeargulf_of_mexico-5-2016     -1.712e-01  1.231e+02  -0.001  0.99889    
    ## ref_yeargulf_of_mexico-5-2017      1.762e+00  1.233e+02   0.014  0.98860    
    ## ref_yeargulf_of_mexico-5-2019      3.486e+00  1.235e+02   0.028  0.97748    
    ## ref_yearie_igfs-10-2004            1.217e+00  1.505e+02   0.008  0.99355    
    ## ref_yearie_igfs-10-2005           -8.973e-01  1.512e+02  -0.006  0.99526    
    ## ref_yearie_igfs-10-2006            1.601e+00  1.512e+02   0.011  0.99155    
    ## ref_yearie_igfs-10-2007            7.471e+01  1.475e+02   0.506  0.61257    
    ## ref_yearie_igfs-10-2008            6.906e-01  1.485e+02   0.005  0.99629    
    ## ref_yearie_igfs-10-2009           -9.050e-02  1.481e+02  -0.001  0.99951    
    ## ref_yearie_igfs-10-2010           -4.506e-02  1.523e+02   0.000  0.99976    
    ## ref_yearie_igfs-10-2011            1.005e+00  1.512e+02   0.007  0.99470    
    ## ref_yearie_igfs-10-2012            3.915e+00  1.519e+02   0.026  0.97945    
    ## ref_yearie_igfs-10-2013           -1.056e+00  1.543e+02  -0.007  0.99454    
    ## ref_yearie_igfs-10-2014            2.154e+00  1.539e+02   0.014  0.98884    
    ## ref_yearie_igfs-10-2015            5.808e+01  1.519e+02   0.382  0.70226    
    ## ref_yearie_igfs-10-2016           -5.004e-01  1.519e+02  -0.003  0.99737    
    ## ref_yearie_igfs-10-2017            1.991e+00  1.539e+02   0.013  0.98968    
    ## ref_yearie_igfs-10-2018            1.531e+01  1.539e+02   0.099  0.92078    
    ## ref_yearie_igfs-10-2019            8.120e-01  1.508e+02   0.005  0.99570    
    ## ref_yearie_igfs-10-2020           -3.962e-01  1.505e+02  -0.003  0.99790    
    ## ref_yearnorbts-1-2005              4.875e+00  1.612e+02   0.030  0.97587    
    ## ref_yearnorbts-1-2006              3.546e+01  1.601e+02   0.222  0.82469    
    ## ref_yearnorbts-1-2007              1.002e+01  1.845e+02   0.054  0.95668    
    ## ref_yearnorbts-1-2008              5.502e+00  1.768e+02   0.031  0.97518    
    ## ref_yearnorbts-1-2009              3.714e+03  1.778e+02  20.887  < 2e-16 ***
    ## ref_yearnorbts-1-2010             -1.201e+00  1.683e+02  -0.007  0.99431    
    ## ref_yearnorbts-1-2011              3.095e+00  1.833e+02   0.017  0.98653    
    ## ref_yearnorbts-1-2012              2.921e+00  1.723e+02   0.017  0.98647    
    ## ref_yearnorbts-1-2013              4.937e+01  1.606e+02   0.307  0.75859    
    ## ref_yearnorbts-1-2014              1.245e+01  1.683e+02   0.074  0.94103    
    ## ref_yearnorbts-1-2015             -6.977e-01  1.669e+02  -0.004  0.99666    
    ## ref_yearnorbts-1-2016             -5.874e-01  1.642e+02  -0.004  0.99715    
    ## ref_yearnorbts-1-2017              7.479e-01  1.636e+02   0.005  0.99635    
    ## ref_yearnortheast-2-1983          -4.858e-01  1.539e+02  -0.003  0.99748    
    ## ref_yearnortheast-2-1984           8.885e-02  1.527e+02   0.001  0.99954    
    ## ref_yearnortheast-2-1985           5.422e-02  1.539e+02   0.000  0.99972    
    ## ref_yearnortheast-2-1986          -9.618e-01  1.531e+02  -0.006  0.99499    
    ## ref_yearnortheast-2-1987          -6.888e-01  1.535e+02  -0.004  0.99642    
    ## ref_yearnortheast-2-1988          -4.532e-02  1.527e+02   0.000  0.99976    
    ## ref_yearnortheast-2-1989           3.677e+00  1.523e+02   0.024  0.98074    
    ## ref_yearnortheast-2-1990          -7.245e-01  1.519e+02  -0.005  0.99620    
    ## ref_yearnortheast-2-1991           9.740e-01  1.519e+02   0.006  0.99489    
    ## ref_yearnortheast-2-1992          -7.054e-02  1.523e+02   0.000  0.99963    
    ## ref_yearnortheast-2-1993          -9.607e-01  1.535e+02  -0.006  0.99501    
    ## ref_yearnortheast-2-1994           3.557e+00  1.527e+02   0.023  0.98142    
    ## ref_yearnortheast-2-1995           7.266e-01  1.523e+02   0.005  0.99619    
    ## ref_yearnortheast-2-1996          -1.080e+00  1.519e+02  -0.007  0.99433    
    ## ref_yearnortheast-2-1997          -4.555e-01  1.527e+02  -0.003  0.99762    
    ## ref_yearnortheast-2-1998           2.082e-03  1.531e+02   0.000  0.99999    
    ## ref_yearnortheast-2-1999           6.366e-02  1.527e+02   0.000  0.99967    
    ## ref_yearnortheast-2-2000          -4.648e-01  1.535e+02  -0.003  0.99758    
    ## ref_yearnortheast-2-2001          -7.334e-01  1.543e+02  -0.005  0.99621    
    ## ref_yearnortheast-2-2002           6.053e+00  1.543e+02   0.039  0.96872    
    ## ref_yearnortheast-2-2003           4.081e+00  1.519e+02   0.027  0.97857    
    ## ref_yearnortheast-2-2004          -1.051e+00  1.523e+02  -0.007  0.99449    
    ## ref_yearnortheast-2-2005          -1.910e-01  1.531e+02  -0.001  0.99900    
    ## ref_yearnortheast-2-2006          -4.269e-01  1.519e+02  -0.003  0.99776    
    ## ref_yearnortheast-2-2007          -1.231e-01  1.519e+02  -0.001  0.99935    
    ## ref_yearnortheast-2-2008          -4.745e-01  1.523e+02  -0.003  0.99751    
    ## ref_yearnortheast-2-2009           1.005e+00  1.523e+02   0.007  0.99474    
    ## ref_yearnortheast-2-2010          -9.596e-01  1.519e+02  -0.006  0.99496    
    ## ref_yearnortheast-2-2011           8.284e-01  1.516e+02   0.005  0.99564    
    ## ref_yearnortheast-2-2012          -7.669e-01  1.523e+02  -0.005  0.99598    
    ## ref_yearnortheast-2-2013          -1.210e-01  1.519e+02  -0.001  0.99936    
    ## ref_yearnortheast-2-2014           4.440e-01  1.535e+02   0.003  0.99769    
    ## ref_yearnortheast-2-2015           8.826e-01  1.519e+02   0.006  0.99537    
    ## ref_yearnortheast-2-2016          -6.287e-01  1.516e+02  -0.004  0.99669    
    ## ref_yearnortheast-2-2017          -5.639e-01  1.630e+02  -0.003  0.99724    
    ## ref_yearnortheast-2-2018           2.012e+00  1.527e+02   0.013  0.98949    
    ## ref_yearnortheast-2-2019          -1.153e+00  1.519e+02  -0.008  0.99394    
    ## ref_yearns_ibts-1-1983             7.064e-01  1.606e+02   0.004  0.99649    
    ## ref_yearns_ibts-1-1984             4.864e+01  1.580e+02   0.308  0.75822    
    ## ref_yearns_ibts-1-1985            -2.648e-01  1.552e+02  -0.002  0.99864    
    ## ref_yearns_ibts-1-1986             1.844e-01  1.585e+02   0.001  0.99907    
    ## ref_yearns_ibts-1-1987             1.747e+00  1.580e+02   0.011  0.99118    
    ## ref_yearns_ibts-1-1988            -1.098e+00  1.590e+02  -0.007  0.99449    
    ## ref_yearns_ibts-1-1989             1.270e+01  1.580e+02   0.080  0.93592    
    ## ref_yearns_ibts-1-1990            -6.485e-01  1.570e+02  -0.004  0.99671    
    ## ref_yearns_ibts-1-1991             5.355e+00  1.539e+02   0.035  0.97225    
    ## ref_yearns_ibts-1-1992             1.606e+00  1.508e+02   0.011  0.99151    
    ## ref_yearns_ibts-1-1993            -6.351e-01  1.531e+02  -0.004  0.99669    
    ## ref_yearns_ibts-1-1994            -9.575e-01  1.570e+02  -0.006  0.99514    
    ## ref_yearns_ibts-1-1995             3.926e-01  1.552e+02   0.003  0.99798    
    ## ref_yearns_ibts-1-1996             4.136e+00  1.501e+02   0.028  0.97802    
    ## ref_yearns_ibts-1-1997             1.133e-01  1.508e+02   0.001  0.99940    
    ## ref_yearns_ibts-1-1998             5.343e+00  1.505e+02   0.036  0.97167    
    ## ref_yearns_ibts-1-1999            -8.335e-01  1.488e+02  -0.006  0.99553    
    ## ref_yearns_ibts-1-2000            -6.081e-02  1.531e+02   0.000  0.99968    
    ## ref_yearns_ibts-1-2001             8.637e+00  1.505e+02   0.057  0.95423    
    ## ref_yearns_ibts-1-2002            -4.794e-01  1.498e+02  -0.003  0.99745    
    ## ref_yearns_ibts-1-2003             1.020e+02  1.516e+02   0.673  0.50088    
    ## ref_yearns_ibts-1-2004             2.126e-01  1.508e+02   0.001  0.99888    
    ## ref_yearns_ibts-1-2005            -2.428e-01  1.516e+02  -0.002  0.99872    
    ## ref_yearns_ibts-1-2006             1.327e-01  1.481e+02   0.001  0.99929    
    ## ref_yearns_ibts-1-2007             6.959e+00  1.508e+02   0.046  0.96320    
    ## ref_yearns_ibts-1-2008            -6.333e-01  1.481e+02  -0.004  0.99659    
    ## ref_yearns_ibts-1-2009             2.783e+00  1.491e+02   0.019  0.98511    
    ## ref_yearns_ibts-1-2010             3.520e+00  1.491e+02   0.024  0.98117    
    ## ref_yearns_ibts-1-2011             3.454e+01  1.475e+02   0.234  0.81491    
    ## ref_yearns_ibts-1-2012             3.879e+01  1.485e+02   0.261  0.79388    
    ## ref_yearns_ibts-1-2013            -9.429e-01  1.498e+02  -0.006  0.99498    
    ## ref_yearns_ibts-1-2014             9.184e-01  1.464e+02   0.006  0.99499    
    ## ref_yearns_ibts-1-2015             1.408e+00  1.478e+02   0.010  0.99240    
    ## ref_yearns_ibts-1-2016             2.643e+00  1.461e+02   0.018  0.98556    
    ## ref_yearns_ibts-1-2017             8.975e+01  1.488e+02   0.603  0.54637    
    ## ref_yearns_ibts-1-2018             1.683e+00  1.469e+02   0.011  0.99086    
    ## ref_yearns_ibts-1-2019             1.421e-01  1.478e+02   0.001  0.99923    
    ## ref_yearns_ibts-1-2020             5.509e-02  1.485e+02   0.000  0.99970    
    ## ref_yearpt_ibts-9-2005             2.383e+00  1.706e+02   0.014  0.98886    
    ## ref_yearpt_ibts-9-2006            -3.794e-01  1.618e+02  -0.002  0.99813    
    ## ref_yearpt_ibts-9-2007            -6.642e-01  1.612e+02  -0.004  0.99671    
    ## ref_yearpt_ibts-9-2008             2.519e+00  1.624e+02   0.016  0.98762    
    ## ref_yearpt_ibts-9-2009             5.562e-02  1.630e+02   0.000  0.99973    
    ## ref_yearpt_ibts-9-2010            -3.336e-01  1.601e+02  -0.002  0.99834    
    ## ref_yearpt_ibts-9-2011             1.385e+00  1.642e+02   0.008  0.99327    
    ## ref_yearpt_ibts-9-2013             5.209e+00  1.649e+02   0.032  0.97480    
    ## ref_yearpt_ibts-9-2014            -1.105e+00  1.612e+02  -0.007  0.99453    
    ## ref_yearpt_ibts-9-2015             4.745e+01  1.649e+02   0.288  0.77349    
    ## ref_yearpt_ibts-9-2016             1.346e+00  1.580e+02   0.009  0.99321    
    ## ref_yearpt_ibts-9-2017             5.766e+00  1.596e+02   0.036  0.97117    
    ## ref_yearpt_ibts-9-2018            -1.416e+00  1.566e+02  -0.009  0.99278    
    ## ref_yearrockall-8-2001            -1.650e+00  2.140e+02  -0.008  0.99385    
    ## ref_yearrockall-8-2002            -1.032e+00  2.351e+02  -0.004  0.99650    
    ## ref_yearrockall-8-2003             1.838e+01  2.250e+02   0.082  0.93488    
    ## ref_yearrockall-8-2005             1.719e+00  2.282e+02   0.008  0.99399    
    ## ref_yearrockall-8-2006             8.548e-01  2.093e+02   0.004  0.99674    
    ## ref_yearrockall-8-2007            -3.163e-01  2.071e+02  -0.002  0.99878    
    ## ref_yearrockall-8-2008            -1.147e+00  2.071e+02  -0.006  0.99558    
    ## ref_yearrockall-8-2009            -1.340e-01  2.093e+02  -0.001  0.99949    
    ## ref_yearrockall-8-2011             7.431e+02  2.011e+02   3.696  0.00022 ***
    ## ref_yearrockall-8-2012            -5.878e-02  1.870e+02   0.000  0.99975    
    ## ref_yearrockall-8-2013             5.977e+00  1.883e+02   0.032  0.97468    
    ## ref_yearrockall-8-2014             5.903e+00  1.927e+02   0.031  0.97556    
    ## ref_yearrockall-8-2015            -1.016e+00  1.870e+02  -0.005  0.99567    
    ## ref_yearrockall-8-2016             4.572e+00  1.912e+02   0.024  0.98092    
    ## ref_yearrockall-8-2017            -1.310e+00  1.883e+02  -0.007  0.99445    
    ## ref_yearrockall-8-2018            -4.976e-01  2.011e+02  -0.002  0.99803    
    ## ref_yearrockall-8-2019             1.460e-01  1.993e+02   0.001  0.99942    
    ## ref_yearrockall-8-2020            -1.355e+00  1.912e+02  -0.007  0.99434    
    ## ref_yearscotian_shelf-6-1983      -1.797e-01  2.192e+02  -0.001  0.99935    
    ## ref_yearscotian_shelf-6-1984       2.012e+00  1.993e+02   0.010  0.99194    
    ## ref_yearscotian_shelf-6-1985      -8.617e-01  2.030e+02  -0.004  0.99661    
    ## ref_yearscotian_shelf-6-1987      -6.526e-01  2.011e+02  -0.003  0.99741    
    ## ref_yearscotian_shelf-6-1988      -3.313e-01  2.030e+02  -0.002  0.99870    
    ## ref_yearscotian_shelf-6-1989      -8.188e-01  1.993e+02  -0.004  0.99672    
    ## ref_yearscotian_shelf-6-1990      -1.332e+00  2.011e+02  -0.007  0.99472    
    ## ref_yearscotian_shelf-6-1991       7.713e+00  2.093e+02   0.037  0.97060    
    ## ref_yearscotian_shelf-6-1992      -1.050e+00  2.011e+02  -0.005  0.99583    
    ## ref_yearscotian_shelf-6-1993      -1.296e-01  2.030e+02  -0.001  0.99949    
    ## ref_yearscotian_shelf-6-1994       3.498e-02  1.993e+02   0.000  0.99986    
    ## ref_yearscotian_shelf-6-1995       5.026e+00  2.011e+02   0.025  0.98006    
    ## ref_yearscotian_shelf-6-1996      -1.202e+00  1.993e+02  -0.006  0.99519    
    ## ref_yearscotian_shelf-6-1997      -8.583e-01  1.993e+02  -0.004  0.99656    
    ## ref_yearscotian_shelf-6-1998      -6.505e-01  2.071e+02  -0.003  0.99749    
    ## ref_yearscotian_shelf-6-1999      -8.871e-01  1.993e+02  -0.004  0.99645    
    ## ref_yearscotian_shelf-6-2000      -1.023e+00  1.993e+02  -0.005  0.99591    
    ## ref_yearscotian_shelf-6-2001      -4.323e-01  1.993e+02  -0.002  0.99827    
    ## ref_yearscotian_shelf-6-2002      -1.208e+00  1.993e+02  -0.006  0.99516    
    ## ref_yearscotian_shelf-6-2003      -9.500e-01  2.050e+02  -0.005  0.99630    
    ## ref_yearscotian_shelf-6-2004      -4.585e-01  1.993e+02  -0.002  0.99816    
    ## ref_yearscotian_shelf-6-2005      -3.879e-01  1.993e+02  -0.002  0.99845    
    ## ref_yearscotian_shelf-6-2006      -6.873e-01  1.993e+02  -0.003  0.99725    
    ## ref_yearscotian_shelf-6-2007      -6.671e-01  2.030e+02  -0.003  0.99738    
    ## ref_yearscotian_shelf-6-2008      -7.641e-01  1.993e+02  -0.004  0.99694    
    ## ref_yearscotian_shelf-6-2009       1.490e+00  1.993e+02   0.007  0.99403    
    ## ref_yearscotian_shelf-6-2010       1.064e+00  2.050e+02   0.005  0.99586    
    ## ref_yearscotian_shelf-6-2011      -5.155e-01  1.993e+02  -0.003  0.99794    
    ## ref_yearscotian_shelf-6-2012      -1.070e+00  1.993e+02  -0.005  0.99572    
    ## ref_yearscotian_shelf-6-2013      -1.002e+00  1.993e+02  -0.005  0.99599    
    ## ref_yearscotian_shelf-6-2014      -5.687e-01  1.993e+02  -0.003  0.99772    
    ## ref_yearscotian_shelf-6-2015      -9.444e-01  1.993e+02  -0.005  0.99622    
    ## ref_yearscotian_shelf-6-2016      -4.974e-01  1.993e+02  -0.002  0.99801    
    ## ref_yearscotian_shelf-6-2017       2.705e+00  1.993e+02   0.014  0.98917    
    ## ref_yearsoutheast-4-1990          -7.998e-01  1.452e+02  -0.006  0.99561    
    ## ref_yearsoutheast-4-1991          -4.225e-01  1.445e+02  -0.003  0.99767    
    ## ref_yearsoutheast-4-1992          -4.453e-01  1.445e+02  -0.003  0.99754    
    ## ref_yearsoutheast-4-1993          -2.151e-01  1.445e+02  -0.001  0.99881    
    ## ref_yearsoutheast-4-1994           2.004e-01  1.452e+02   0.001  0.99890    
    ## ref_yearsoutheast-4-1995           9.114e-01  1.447e+02   0.006  0.99497    
    ## ref_yearsoutheast-4-1996          -5.820e-01  1.447e+02  -0.004  0.99679    
    ## ref_yearsoutheast-4-1997          -8.544e-01  1.450e+02  -0.006  0.99530    
    ## ref_yearsoutheast-4-1998           6.270e-01  1.452e+02   0.004  0.99656    
    ## ref_yearsoutheast-4-1999          -1.162e-01  1.452e+02  -0.001  0.99936    
    ## ref_yearsoutheast-4-2000          -5.102e-01  1.442e+02  -0.004  0.99718    
    ## ref_yearsoutheast-4-2001          -2.059e-01  1.445e+02  -0.001  0.99886    
    ## ref_yearsoutheast-4-2002           1.156e+00  1.452e+02   0.008  0.99365    
    ## ref_yearsoutheast-4-2003           2.141e-01  1.450e+02   0.001  0.99882    
    ## ref_yearsoutheast-4-2004           1.121e-01  1.442e+02   0.001  0.99938    
    ## ref_yearsoutheast-4-2005          -2.805e-01  1.445e+02  -0.002  0.99845    
    ## ref_yearsoutheast-4-2006          -4.636e-01  1.450e+02  -0.003  0.99745    
    ## ref_yearsoutheast-4-2007          -3.411e-01  1.445e+02  -0.002  0.99812    
    ## ref_yearsoutheast-4-2008          -3.111e-01  1.442e+02  -0.002  0.99828    
    ## ref_yearsoutheast-4-2009           1.243e+00  1.447e+02   0.009  0.99314    
    ## ref_yearsoutheast-4-2010          -2.758e-01  1.452e+02  -0.002  0.99848    
    ## ref_yearsoutheast-4-2011           2.442e+00  1.450e+02   0.017  0.98656    
    ## ref_yearsoutheast-4-2012           1.191e+01  1.445e+02   0.082  0.93428    
    ## ref_yearsoutheast-4-2013           2.413e+00  1.445e+02   0.017  0.98667    
    ## ref_yearsoutheast-4-2014          -8.407e-01  1.450e+02  -0.006  0.99537    
    ## ref_yearsoutheast-4-2015           5.234e+00  1.445e+02   0.036  0.97110    
    ## ref_yearsoutheast-4-2016          -4.437e-01  1.440e+02  -0.003  0.99754    
    ## ref_yearsoutheast-4-2017           4.813e+00  1.442e+02   0.033  0.97337    
    ## ref_yearsoutheast-4-2018          -7.007e-01  1.455e+02  -0.005  0.99616    
    ## ref_yearswc_ibts-1-1986           -6.554e-01  1.669e+02  -0.004  0.99687    
    ## ref_yearswc_ibts-1-1987           -7.684e-01  1.714e+02  -0.004  0.99642    
    ## ref_yearswc_ibts-1-1988            1.297e+01  1.714e+02   0.076  0.93970    
    ## ref_yearswc_ibts-1-1989            7.168e-02  1.714e+02   0.000  0.99967    
    ## ref_yearswc_ibts-1-1990            1.975e+01  1.698e+02   0.116  0.90744    
    ## ref_yearswc_ibts-1-1991            1.045e-01  1.723e+02   0.001  0.99952    
    ## ref_yearswc_ibts-1-1992            2.415e+01  1.714e+02   0.141  0.88799    
    ## ref_yearswc_ibts-1-1993            4.828e+00  1.706e+02   0.028  0.97743    
    ## ref_yearswc_ibts-1-1994            1.179e-01  1.723e+02   0.001  0.99945    
    ## ref_yearswc_ibts-1-1995            1.980e+01  1.683e+02   0.118  0.90635    
    ## ref_yearswc_ibts-1-1996            2.246e-01  1.788e+02   0.001  0.99900    
    ## ref_yearswc_ibts-1-1997            5.932e-01  1.655e+02   0.004  0.99714    
    ## ref_yearswc_ibts-1-1998            2.911e-01  1.606e+02   0.002  0.99855    
    ## ref_yearswc_ibts-1-1999           -8.472e-01  1.624e+02  -0.005  0.99584    
    ## ref_yearswc_ibts-1-2000            1.499e+01  1.642e+02   0.091  0.92725    
    ## ref_yearswc_ibts-1-2001            4.569e-01  1.624e+02   0.003  0.99775    
    ## ref_yearswc_ibts-1-2002           -2.810e-01  1.655e+02  -0.002  0.99865    
    ## ref_yearswc_ibts-1-2003            2.709e+00  1.636e+02   0.017  0.98679    
    ## ref_yearswc_ibts-1-2004           -7.441e-01  1.601e+02  -0.005  0.99629    
    ## ref_yearswc_ibts-1-2005           -6.871e-01  1.601e+02  -0.004  0.99658    
    ## ref_yearswc_ibts-1-2006            3.864e+01  1.698e+02   0.228  0.82003    
    ## ref_yearswc_ibts-1-2007            1.865e+00  1.662e+02   0.011  0.99105    
    ## ref_yearswc_ibts-1-2008            5.423e-02  1.636e+02   0.000  0.99974    
    ## ref_yearswc_ibts-1-2009           -1.193e+00  1.669e+02  -0.007  0.99430    
    ## ref_yearswc_ibts-1-2010            6.056e+00  1.676e+02   0.036  0.97117    
    ## ref_yearswc_ibts-1-2011            2.916e+00  1.642e+02   0.018  0.98583    
    ## ref_yearswc_ibts-1-2012           -7.176e-01  1.590e+02  -0.005  0.99640    
    ## ref_yearswc_ibts-1-2013            8.373e+00  1.601e+02   0.052  0.95829    
    ## ref_yearswc_ibts-1-2014           -6.486e-01  1.580e+02  -0.004  0.99673    
    ## ref_yearswc_ibts-1-2015           -1.733e-01  1.618e+02  -0.001  0.99915    
    ## ref_yearswc_ibts-1-2016           -5.129e-01  1.601e+02  -0.003  0.99744    
    ## ref_yearswc_ibts-1-2017           -7.721e-01  1.662e+02  -0.005  0.99629    
    ## ref_yearswc_ibts-1-2018           -9.910e-01  1.691e+02  -0.006  0.99532    
    ## ref_yearswc_ibts-1-2019            4.221e+00  1.649e+02   0.026  0.97957    
    ## ref_yearswc_ibts-1-2020            1.273e+00  1.618e+02   0.008  0.99372    
    ## ref_yearwest_coast-5-1986          1.724e-01  1.472e+02   0.001  0.99907    
    ## ref_yearwest_coast-5-1989          1.562e+00  1.478e+02   0.011  0.99157    
    ## ref_yearwest_coast-5-1992          9.726e-01  1.481e+02   0.007  0.99476    
    ## ref_yearwest_coast-5-1995          4.601e-01  1.481e+02   0.003  0.99752    
    ## ref_yearwest_coast-5-1998          1.644e+00  1.478e+02   0.011  0.99113    
    ## ref_yearwest_coast-5-2001          5.152e+00  1.472e+02   0.035  0.97209    
    ## ref_yearwest_coast-5-2003          1.216e+02  1.535e+02   0.792  0.42818    
    ## ref_yearwest_coast-5-2004          7.086e+00  1.333e+02   0.053  0.95760    
    ## ref_yearwest_coast-5-2005         -4.479e-01  1.327e+02  -0.003  0.99731    
    ## ref_yearwest_coast-5-2006          4.072e+00  1.316e+02   0.031  0.97533    
    ## ref_yearwest_coast-5-2007          1.435e+01  1.315e+02   0.109  0.91312    
    ## ref_yearwest_coast-5-2008          1.450e+00  1.312e+02   0.011  0.99119    
    ## ref_yearwest_coast-5-2009          7.887e+00  1.315e+02   0.060  0.95219    
    ## ref_yearwest_coast-5-2010          3.577e+00  1.309e+02   0.027  0.97821    
    ## ref_yearwest_coast-5-2011          8.911e+00  1.313e+02   0.068  0.94591    
    ## ref_yearwest_coast-5-2012          5.088e+00  1.311e+02   0.039  0.96905    
    ## ref_yearwest_coast-5-2013          8.205e+00  1.311e+02   0.063  0.95011    
    ## ref_yearwest_coast-5-2014          2.035e+00  1.314e+02   0.015  0.98765    
    ## ref_yearwest_coast-5-2015          3.095e+00  1.313e+02   0.024  0.98120    
    ## ref_yearwest_coast-5-2016          4.507e-01  1.309e+02   0.003  0.99725    
    ## ref_yearwest_coast-5-2017         -6.560e-02  1.320e+02   0.000  0.99960    
    ## ref_yearwest_coast-5-2018          8.976e+00  1.316e+02   0.068  0.94564    
    ## ref_yearwest_coast-5-2019          1.016e-01  1.313e+02   0.001  0.99938    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1041 on 41367 degrees of freedom
    ## Multiple R-squared:  0.01754,    Adjusted R-squared:  0.008021 
    ## F-statistic: 1.842 on 401 and 41367 DF,  p-value: < 2.2e-16

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##   -353    -11     -5     -2 202524 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                          4.88584   41.89355   0.117  0.90716    
    ## anomIntC                             3.93337  147.20684   0.027  0.97868    
    ## regionbits                           2.94265   65.38666   0.045  0.96410    
    ## regioneastern_bering_sea            16.55899   44.87288   0.369  0.71211    
    ## regionevhoe                         -1.29633   58.18129  -0.022  0.98222    
    ## regionfr_cgfs                       -3.26495   61.14884  -0.053  0.95742    
    ## regiongulf_of_alaska                -0.49195   48.68140  -0.010  0.99194    
    ## regiongulf_of_mexico                 0.09231   48.38213   0.002  0.99848    
    ## regionie_igfs                        3.48889   56.91444   0.061  0.95112    
    ## regionnorbts                       347.28098   61.65843   5.632 1.79e-08 ***
    ## regionnortheast                     -3.42156   49.88561  -0.069  0.94532    
    ## regionns_ibts                        8.77537   48.14770   0.182  0.85538    
    ## regionpt_ibts                       -5.29849   70.36412  -0.075  0.93998    
    ## regionrockall                       62.88346   71.72442   0.877  0.38063    
    ## regionscotian_shelf                 -4.04012   57.51884  -0.070  0.94400    
    ## regionsoutheast                     -3.38812   49.20320  -0.069  0.94510    
    ## regionswc_ibts                       2.74501   53.71799   0.051  0.95925    
    ## regionwest_coast                     6.14787   46.69603   0.132  0.89526    
    ## anomIntC:regionbits                 -6.51649  165.05597  -0.039  0.96851    
    ## anomIntC:regioneastern_bering_sea  -27.81411  157.96558  -0.176  0.86023    
    ## anomIntC:regionevhoe                -3.68710  196.37329  -0.019  0.98502    
    ## anomIntC:regionfr_cgfs              -0.87366  281.46417  -0.003  0.99752    
    ## anomIntC:regiongulf_of_alaska        4.21445  182.40151   0.023  0.98157    
    ## anomIntC:regiongulf_of_mexico      -10.11949  161.70830  -0.063  0.95010    
    ## anomIntC:regionie_igfs               5.87054  185.15482   0.032  0.97471    
    ## anomIntC:regionnorbts             -769.03333  257.08275  -2.991  0.00278 ** 
    ## anomIntC:regionnortheast            -3.74748  172.41263  -0.022  0.98266    
    ## anomIntC:regionns_ibts             -14.02622  160.22300  -0.088  0.93024    
    ## anomIntC:regionpt_ibts              16.76306  213.28554   0.079  0.93736    
    ## anomIntC:regionrockall             -85.17291  206.62198  -0.412  0.68018    
    ## anomIntC:regionscotian_shelf        -2.52786  186.71283  -0.014  0.98920    
    ## anomIntC:regionsoutheast            -1.41622  173.19235  -0.008  0.99348    
    ## anomIntC:regionswc_ibts            -16.53292  207.15097  -0.080  0.93639    
    ## anomIntC:regionwest_coast          -26.84486  175.87660  -0.153  0.87869    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1045 on 41735 degrees of freedom
    ## Multiple R-squared:  0.001463,   Adjusted R-squared:  0.0006734 
    ## F-statistic: 1.853 on 33 and 41735 DF,  p-value: 0.00207

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##   -336    -10     -5     -2 202515 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                         7.32436   33.10898   0.221   0.8249    
    ## anomDays                           -0.08484    1.32928  -0.064   0.9491    
    ## regionbits                         -0.52780   51.28844  -0.010   0.9918    
    ## regioneastern_bering_sea           13.05581   36.49411   0.358   0.7205    
    ## regionevhoe                        -3.10483   43.66724  -0.071   0.9433    
    ## regionfr_cgfs                      -5.28514   49.38880  -0.107   0.9148    
    ## regiongulf_of_alaska               -0.99701   40.17772  -0.025   0.9802    
    ## regiongulf_of_mexico               -2.71423   40.91326  -0.066   0.9471    
    ## regionie_igfs                      -6.57722   49.62083  -0.133   0.8946    
    ## regionnorbts                      327.49301   53.36328   6.137 8.48e-10 ***
    ## regionnortheast                    -5.79106   40.09670  -0.144   0.8852    
    ## regionns_ibts                       2.15711   39.86251   0.054   0.9568    
    ## regionpt_ibts                      -3.43113   64.49719  -0.053   0.9576    
    ## regionrockall                      -5.34849   71.64818  -0.075   0.9405    
    ## regionscotian_shelf                -6.27450   47.91070  -0.131   0.8958    
    ## regionsoutheast                    -5.23302   40.15383  -0.130   0.8963    
    ## regionswc_ibts                     -0.15627   45.10835  -0.003   0.9972    
    ## regionwest_coast                    1.77975   37.74828   0.047   0.9624    
    ## anomDays:regionbits                 0.06410    1.93005   0.033   0.9735    
    ## anomDays:regioneastern_bering_sea  -0.08277    1.41154  -0.059   0.9532    
    ## anomDays:regionevhoe                0.04771    1.89576   0.025   0.9799    
    ## anomDays:regionfr_cgfs              0.08312    1.93834   0.043   0.9658    
    ## anomDays:regiongulf_of_alaska       0.04790    1.43578   0.033   0.9734    
    ## anomDays:regiongulf_of_mexico       0.03462    1.50818   0.023   0.9817    
    ## anomDays:regionie_igfs              0.76656    2.23501   0.343   0.7316    
    ## anomDays:regionnorbts              -2.84893    1.53370  -1.858   0.0632 .  
    ## anomDays:regionnortheast            0.08335    1.54841   0.054   0.9571    
    ## anomDays:regionns_ibts              0.17453    1.56219   0.112   0.9110    
    ## anomDays:regionpt_ibts              0.16362    2.33045   0.070   0.9440    
    ## anomDays:regionrockall              2.37135    2.99226   0.792   0.4281    
    ## anomDays:regionscotian_shelf        0.09277    1.81049   0.051   0.9591    
    ## anomDays:regionsoutheast            0.07922    1.69516   0.047   0.9627    
    ## anomDays:regionswc_ibts            -0.02191    1.87118  -0.012   0.9907    
    ## anomDays:regionwest_coast           0.03472    1.38011   0.025   0.9799    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1045 on 41735 degrees of freedom
    ## Multiple R-squared:  0.00151,    Adjusted R-squared:  0.0007203 
    ## F-statistic: 1.912 on 33 and 41735 DF,  p-value: 0.001236

Other models with region as an interaction:

    ## 
    ## Call:
    ## lm(formula = wtMtDiffProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##   -312    -10     -5     -2 202534 
    ## 
    ## Coefficients:
    ##                                   Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                        7.16625   32.83798   0.218    0.827    
    ## anomSev                           -0.26658    4.59068  -0.058    0.954    
    ## regionbits                        -0.05747   49.36814  -0.001    0.999    
    ## regioneastern_bering_sea          12.30428   35.91987   0.343    0.732    
    ## regionevhoe                       -3.26862   41.76409  -0.078    0.938    
    ## regionfr_cgfs                     -5.19043   47.54631  -0.109    0.913    
    ## regiongulf_of_alaska              -0.99047   39.42312  -0.025    0.980    
    ## regiongulf_of_mexico              -2.70386   39.78981  -0.068    0.946    
    ## regionie_igfs                     -3.76564   46.03147  -0.082    0.935    
    ## regionnorbts                     303.70696   51.73642   5.870 4.38e-09 ***
    ## regionnortheast                   -5.60762   38.48454  -0.146    0.884    
    ## regionns_ibts                      4.65157   39.28323   0.118    0.906    
    ## regionpt_ibts                     -3.47542   56.11155  -0.062    0.951    
    ## regionrockall                     48.03626   62.25813   0.772    0.440    
    ## regionscotian_shelf               -6.17770   47.55571  -0.130    0.897    
    ## regionsoutheast                   -5.06191   38.53388  -0.131    0.895    
    ## regionswc_ibts                    -0.41269   42.89723  -0.010    0.992    
    ## regionwest_coast                   1.64218   37.31772   0.044    0.965    
    ## anomSev:regionbits                 0.21750    4.86689   0.045    0.964    
    ## anomSev:regioneastern_bering_sea   0.08669    4.62626   0.019    0.985    
    ## anomSev:regionevhoe                0.22297    5.48400   0.041    0.968    
    ## anomSev:regionfr_cgfs              0.27746    5.69206   0.049    0.961    
    ## anomSev:regiongulf_of_alaska       0.18790    4.74080   0.040    0.968    
    ## anomSev:regiongulf_of_mexico       0.16529    4.79709   0.034    0.973    
    ## anomSev:regionie_igfs              1.43899    5.53301   0.260    0.795    
    ## anomSev:regionnorbts              -5.16397    4.87225  -1.060    0.289    
    ## anomSev:regionnortheast            0.25902    4.79655   0.054    0.957    
    ## anomSev:regionns_ibts              0.15499    4.95654   0.031    0.975    
    ## anomSev:regionpt_ibts              0.46270    5.48760   0.084    0.933    
    ## anomSev:regionrockall             -1.33647    6.77566  -0.197    0.844    
    ## anomSev:regionscotian_shelf        0.29447    5.37902   0.055    0.956    
    ## anomSev:regionsoutheast            0.24952    4.94823   0.050    0.960    
    ## anomSev:regionswc_ibts            -0.04317    6.07292  -0.007    0.994    
    ## anomSev:regionwest_coast           0.18759    4.64570   0.040    0.968    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1045 on 41735 degrees of freedom
    ## Multiple R-squared:  0.001407,   Adjusted R-squared:  0.0006173 
    ## F-statistic: 1.782 on 33 and 41735 DF,  p-value: 0.003771

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomIntC + anomIntC * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -1.456 -0.930 -0.531  0.141 38.110 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)                       -0.0465371  0.0779644  -0.597  0.55058   
    ## anomIntC                           0.2185464  0.2916442   0.749  0.45364   
    ## regionbits                         0.1800164  0.1073203   1.677  0.09347 . 
    ## regioneastern_bering_sea           0.0475930  0.0852995   0.558  0.57688   
    ## regionevhoe                        0.2708773  0.1038623   2.608  0.00911 **
    ## regionfr_cgfs                     -0.0066486  0.1144078  -0.058  0.95366   
    ## regiongulf_of_alaska              -0.0036524  0.0927645  -0.039  0.96859   
    ## regiongulf_of_mexico               0.0574152  0.0932134   0.616  0.53793   
    ## regionie_igfs                      0.0008359  0.0989088   0.008  0.99326   
    ## regionnorbts                      -0.0440306  0.1052837  -0.418  0.67580   
    ## regionnortheast                   -0.1396160  0.0980284  -1.424  0.15438   
    ## regionns_ibts                     -0.0629727  0.0863409  -0.729  0.46579   
    ## regionpt_ibts                     -0.0478572  0.1267515  -0.378  0.70575   
    ## regionrockall                     -0.0806674  0.1188819  -0.679  0.49743   
    ## regionscotian_shelf                0.0164309  0.1165108   0.141  0.88785   
    ## regionsoutheast                    0.0322373  0.0960864   0.336  0.73725   
    ## regionswc_ibts                    -0.0923923  0.0952033  -0.970  0.33181   
    ## regionwest_coast                   0.0633102  0.0894763   0.708  0.47922   
    ## anomIntC:regionbits               -0.4643819  0.3119295  -1.489  0.13656   
    ## anomIntC:regioneastern_bering_sea -0.2147184  0.3169767  -0.677  0.49816   
    ## anomIntC:regionevhoe              -1.0131629  0.3619047  -2.800  0.00512 **
    ## anomIntC:regionfr_cgfs             0.1896370  0.5423729   0.350  0.72661   
    ## anomIntC:regiongulf_of_alaska      0.1720146  0.3737760   0.460  0.64537   
    ## anomIntC:regiongulf_of_mexico     -0.2654985  0.3265679  -0.813  0.41622   
    ## anomIntC:regionie_igfs            -0.0422366  0.3417045  -0.124  0.90163   
    ## anomIntC:regionnorbts              0.5388058  0.4539144   1.187  0.23522   
    ## anomIntC:regionnortheast           0.6062814  0.3524635   1.720  0.08541 . 
    ## anomIntC:regionns_ibts             0.2341408  0.3082800   0.760  0.44755   
    ## anomIntC:regionpt_ibts             0.1195705  0.4044751   0.296  0.76752   
    ## anomIntC:regionrockall             0.2168838  0.3688998   0.588  0.55659   
    ## anomIntC:regionscotian_shelf      -0.0810946  0.3865196  -0.210  0.83382   
    ## anomIntC:regionsoutheast          -0.1487335  0.3538765  -0.420  0.67427   
    ## anomIntC:regionswc_ibts            0.5339155  0.3717157   1.436  0.15091   
    ## anomIntC:regionwest_coast         -0.3521334  0.3587145  -0.982  0.32627   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.326 on 58401 degrees of freedom
    ## Multiple R-squared:  0.001424,   Adjusted R-squared:  0.0008596 
    ## F-statistic: 2.523 on 33 and 58401 DF,  p-value: 3.183e-06

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomDays + anomDays * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -1.396 -0.964 -0.531  0.141 38.036 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)                       -0.0087082  0.0641994  -0.136   0.8921  
    ## anomDays                           0.0005492  0.0027475   0.200   0.8416  
    ## regionbits                        -0.0233226  0.0872374  -0.267   0.7892  
    ## regioneastern_bering_sea           0.0116690  0.0722105   0.162   0.8716  
    ## regionevhoe                        0.1067083  0.0799634   1.334   0.1821  
    ## regionfr_cgfs                      0.0355889  0.0938243   0.379   0.7045  
    ## regiongulf_of_alaska              -0.0119377  0.0793137  -0.151   0.8804  
    ## regiongulf_of_mexico               0.0470328  0.0813803   0.578   0.5633  
    ## regionie_igfs                     -0.1376338  0.0857240  -1.606   0.1084  
    ## regionnorbts                      -0.0516926  0.0916879  -0.564   0.5729  
    ## regionnortheast                   -0.0609999  0.0812075  -0.751   0.4526  
    ## regionns_ibts                     -0.0268389  0.0729986  -0.368   0.7131  
    ## regionpt_ibts                     -0.0340237  0.1170517  -0.291   0.7713  
    ## regionrockall                      0.0336015  0.1173649   0.286   0.7746  
    ## regionscotian_shelf               -0.0056041  0.0994869  -0.056   0.9551  
    ## regionsoutheast                    0.0113583  0.0809263   0.140   0.8884  
    ## regionswc_ibts                     0.0173536  0.0814692   0.213   0.8313  
    ## regionwest_coast                   0.0157274  0.0748559   0.210   0.8336  
    ## anomDays:regionbits                0.0011710  0.0035114   0.333   0.7388  
    ## anomDays:regioneastern_bering_sea -0.0006450  0.0029349  -0.220   0.8261  
    ## anomDays:regionevhoe              -0.0065954  0.0034934  -1.888   0.0590 .
    ## anomDays:regionfr_cgfs            -0.0025829  0.0038108  -0.678   0.4979  
    ## anomDays:regiongulf_of_alaska      0.0004981  0.0029912   0.167   0.8677  
    ## anomDays:regiongulf_of_mexico     -0.0023821  0.0031539  -0.755   0.4501  
    ## anomDays:regionie_igfs             0.0079208  0.0036168   2.190   0.0285 *
    ## anomDays:regionnorbts              0.0018948  0.0030326   0.625   0.5321  
    ## anomDays:regionnortheast           0.0034684  0.0032605   1.064   0.2874  
    ## anomDays:regionns_ibts             0.0019054  0.0030309   0.629   0.5296  
    ## anomDays:regionpt_ibts             0.0014318  0.0044521   0.322   0.7478  
    ## anomDays:regionrockall            -0.0018275  0.0048208  -0.379   0.7046  
    ## anomDays:regionscotian_shelf       0.0004652  0.0038022   0.122   0.9026  
    ## anomDays:regionsoutheast          -0.0007466  0.0035866  -0.208   0.8351  
    ## anomDays:regionswc_ibts           -0.0010495  0.0034696  -0.302   0.7623  
    ## anomDays:regionwest_coast         -0.0009167  0.0028652  -0.320   0.7490  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.327 on 58401 degrees of freedom
    ## Multiple R-squared:  0.0006452,  Adjusted R-squared:  8.05e-05 
    ## F-statistic: 1.143 on 33 and 58401 DF,  p-value: 0.2628

    ## 
    ## Call:
    ## lm(formula = wtMtAnomProp ~ anomSev + anomSev * region, data = .)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -1.422 -0.958 -0.530  0.141 38.042 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                      -0.0021480  0.0635440  -0.034    0.973
    ## anomSev                           0.0004780  0.0094777   0.050    0.960
    ## regionbits                       -0.0199106  0.0843995  -0.236    0.814
    ## regioneastern_bering_sea          0.0021884  0.0708612   0.031    0.975
    ## regionevhoe                       0.0945766  0.0765687   1.235    0.217
    ## regionfr_cgfs                     0.0163458  0.0898200   0.182    0.856
    ## regiongulf_of_alaska             -0.0132927  0.0774375  -0.172    0.864
    ## regiongulf_of_mexico              0.0259665  0.0786473   0.330    0.741
    ## regionie_igfs                    -0.0804201  0.0819621  -0.981    0.327
    ## regionnorbts                     -0.0320046  0.0893708  -0.358    0.720
    ## regionnortheast                  -0.0405756  0.0773238  -0.525    0.600
    ## regionns_ibts                    -0.0398659  0.0719564  -0.554    0.580
    ## regionpt_ibts                     0.0043688  0.1042664   0.042    0.967
    ## regionrockall                    -0.0587681  0.1034474  -0.568    0.570
    ## regionscotian_shelf              -0.0077514  0.0988159  -0.078    0.937
    ## regionsoutheast                   0.0292222  0.0770371   0.379    0.704
    ## regionswc_ibts                   -0.0134557  0.0779396  -0.173    0.863
    ## regionwest_coast                  0.0049132  0.0738038   0.067    0.947
    ## anomSev:regionbits                0.0010896  0.0098062   0.111    0.912
    ## anomSev:regioneastern_bering_sea -0.0002862  0.0095594  -0.030    0.976
    ## anomSev:regionevhoe              -0.0156946  0.0105280  -1.491    0.136
    ## anomSev:regionfr_cgfs            -0.0042387  0.0113830  -0.372    0.710
    ## anomSev:regiongulf_of_alaska      0.0017012  0.0098215   0.173    0.862
    ## anomSev:regiongulf_of_mexico     -0.0032050  0.0099467  -0.322    0.747
    ## anomSev:regionie_igfs             0.0115442  0.0106415   1.085    0.278
    ## anomSev:regionnorbts              0.0030979  0.0098579   0.314    0.753
    ## anomSev:regionnortheast           0.0060387  0.0099652   0.606    0.545
    ## anomSev:regionns_ibts             0.0064910  0.0099200   0.654    0.513
    ## anomSev:regionpt_ibts            -0.0007070  0.0110165  -0.064    0.949
    ## anomSev:regionrockall             0.0081708  0.0122277   0.668    0.504
    ## anomSev:regionscotian_shelf       0.0012599  0.0112956   0.112    0.911
    ## anomSev:regionsoutheast          -0.0057648  0.0103009  -0.560    0.576
    ## anomSev:regionswc_ibts            0.0028022  0.0113088   0.248    0.804
    ## anomSev:regionwest_coast         -0.0008112  0.0096058  -0.084    0.933
    ## 
    ## Residual standard error: 2.327 on 58401 degrees of freedom
    ## Multiple R-squared:  0.0005958,  Adjusted R-squared:  3.105e-05 
    ## F-statistic: 1.055 on 33 and 58401 DF,  p-value: 0.3817
