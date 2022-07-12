# note: this takes a while to run and is set up in parallel--don't just hit "run"!

library(tidyverse)
set.seed(42)
library(here)
library(doParallel)
detectCores()
registerDoParallel(cores=24)
mhw_summary_sat_sst_5_day <- read_csv(here("processed-data","MHW_satellite_sst_5_day_threshold.csv")) # MHW summary stats from satellite SST record, defining MHWs as events >=5 days

survey_summary <-read_csv(here("processed-data","survey_biomass_with_CTI.csv")) %>% inner_join(mhw_summary_sat_sst_5_day)
survey_names <- read_csv(here('processed-data','survey_names.csv'))

###########
# power analysis
###########

powerdat <- survey_summary %>%
  group_by(survey) %>% 
  arrange(year) %>%  
  mutate(lagwt = lag(wt, 1))

# sanity check the approach against some real data (and try a few surveys)
# 
# tData = powerdat %>% filter(survey=='PT-IBTS')
# tGompertz = lm( log(wt) ~ 1 + log(lagwt), data=tData )
# 
# # Gompertz parameters
# talpha = tGompertz$coef['(Intercept)']
# trho = tGompertz$coef['log(lagwt)']
# tconditional_sd = sqrt(mean(tGompertz$residuals^2))
# 
# # dial back perfect autocorrelation so that the marginal standard deviation doesn't go to infinity 
# trho <- ifelse( abs(trho)>0.95, sign(trho)*0.95, trho )
# 
# # Stationary properties (for initial condition)
# tmarginal_sd = tconditional_sd / sqrt(1-trho^2)
# tmarginal_mean = talpha / (1-trho)
# 
# # what's the actual SD of the data and how does it compare to the simulation?
# abs(sd(log(tData$wt))-tmarginal_sd)
# 
# tlogB_t=rep(NA, 10000)
# tlogB_t[1] = rnorm( n=1, mean=tmarginal_mean, sd=tmarginal_sd )
# 
#   # Project every year 
#   #  Gompertz:  log(N(t+1)) = alpha + rho * log(N(t)) + effects + error
#   for( tI in 2:10000){
#     tlogB_t[tI] = talpha + trho*tlogB_t[tI-1] + rnorm( n=1, mean=0, sd=tconditional_sd )
#   }
# 
# plot(seq(1, 10000, 1), tlogB_t)
# lines(x=(tData$year-min(tData$year)+1), y=log(tData$wt), col="red")

iters <- 1000
trialyrs <- c(seq(10, 200, 10), 24, 25) # 435 / 18 = 24.17 which is the average years/survey we have in the actual data 

# PART 1 
# based on the effect sizes in Cheung et al. (6% overall biomass loss in worst-case scenario), how much data would we have needed, given the actual variance in the data? 

# create a function that takes a dataset, a list of surveys, and a list of year lengths, and simulates MHW effects in each survey for that number of years based on Cheung et al.'s estimate of true biomass effects of MHWs 
fn_sim_yr <- function(powerdat, surv, trialyrs, a){
  
  Data = powerdat %>% filter(survey==surv)
  Gompertz = lm( log(wt) ~ 1 + log(lagwt) + mhw_yes_no, data=Data )
  
  # Gompertz parameters
  alpha = Gompertz$coef['(Intercept)']
  rho = Gompertz$coef['log(lagwt)']
  conditional_sd = sqrt(mean(Gompertz$residuals^2))
  
  # MHW frequency and intensity
  prob_mhw = mean( ifelse(Data[,'mhw_yes_no']=="yes",1,0), na.rm=TRUE )
  #gamma = Gompertz$coef['mhw_yes_noyes']
  gamma = log(0.94) # from Cheung et al. 2021
  
  # dial back perfect autocorrelation so that the marginal standard deviation doesn't go to infinity 
  rho <- ifelse( abs(rho)>0.95, sign(rho)*0.95, rho )
  
  # Stationary properties (for initial condition)
  marginal_sd = conditional_sd / sqrt(1-rho^2)
  marginal_mean = alpha / (1-rho)
  
  sim_yrs <- NULL
  
  for(j in trialyrs){
    n_years = j
    logB_t = rep(NA,n_years)
    MHW_t = rbinom(n_years, size=1, prob=prob_mhw)
    
    # Initialize
     logB_t[1] = rnorm( n=1, mean=marginal_mean, sd=marginal_sd )
  #  logB_t[1] = marginal_mean # variance was too big for initializing 
    
    # Project every year 
    #  Gompertz:  log(N(t+1)) = alpha + rho * log(N(t)) + effects + error
    for( tI in 2:n_years){
      logB_t[tI] = alpha + rho*logB_t[tI-1] + gamma*MHW_t[tI] + rnorm( n=1, mean=0, sd=conditional_sd )
    }
    
    # set up dataframe to write out the results 
    tmp <- tibble(wt = exp(logB_t), year = seq(1, n_years, 1), mhw_yes_no = MHW_t, n_years = n_years, gamma = gamma, survey = unique(Data$survey), iter = a) %>% 
      arrange(year) %>% 
      mutate(wt_mt_log = log(wt / lag(wt))) 
    
    sim_yrs <- rbind(sim_yrs, tmp)
  } # close j loop (nyears)
  
  return(sim_yrs)
}

# parallelize implementing this function over iterations, year lengths, and surveys

pwrout_yrs <- foreach(surv=survey_names$survey, .combine='rbind') %:% 
  foreach(a = seq(1, iters, 1), .combine='rbind') %dopar% {
    fn_sim_yr(powerdat=powerdat, surv=surv, trialyrs=trialyrs, a=a)
  }
# is it the right size?
(iters * sum(trialyrs) * nrow(survey_names)) == nrow(pwrout_yrs)

# analyze simulated data 
# note that this is now for all surveys; so while we filter for the length of the trial (n_years), there are 18 "replicates" within the trial pooled together with log ratio biomass + MHW yes/no data 
sim_test_yrs <- NULL
for(j in trialyrs){
  for(i in 1:iters){
    tmp10 <- pwrout_yrs %>% 
      filter(n_years==j,
             iter==i) 
    tmp10_no <- tmp10 %>% filter(wt_mt_log > -Inf, wt_mt_log < Inf, mhw_yes_no == 0) %>% pull(wt_mt_log)
    tmp10_yes <- tmp10 %>% filter(wt_mt_log > -Inf, wt_mt_log < Inf, mhw_yes_no == 1) %>% pull(wt_mt_log)
    tmp10_t <- t.test(tmp10_no, tmp10_yes)
    if(!class(tmp10_t)=="try-error"){
      tmpdat <- tibble(t = tmp10_t$statistic, df = tmp10_t$parameter, p.value = tmp10_t$p.value, mean_no_mhw = mean(tmp10_no), mean_mhw = mean(tmp10_yes), sd_no_mhw = sd(tmp10_no), sd_mhw = sd(tmp10_yes), n_years = j, iter=i)
    } else{
      # if rho goes to 1, marginal sd goes to Inf, which breaks the model; the catch to keep abs(rho)<0.95 above should fix this, but just in case: 
      tmpdat <- tibble(t = NA, df = NA, p.value = NA, mean_no_mhw = NA, mean_mhw = NA, sd_no_mhw = NA, sd_mhw = NA, n_years = j, iter=i)
    }
    sim_test_yrs <- rbind(sim_test_yrs, tmpdat)
  }
}

# how many regions/simulations, if any, created an error?
sim_test_yr_error <- sim_test_yrs %>% 
  filter(is.na(t))
nrow(sim_test_yr_error) == 0 # TRUE

sim_test_summ_yrs <- sim_test_yrs %>% 
  group_by(n_years) %>% 
  summarise(propsig <- length(p.value[p.value<=0.05])/length(p.value)) %>% 
  mutate(n_years_tot = n_years * length(unique(powerdat$survey)))

# PART 2: given the data we have, what effect size could we detect? 
# note that unlike the function above, which applies the same duration to each survey, this holds each survey at its actual number of sample-years and just varies the true effect size to see what we would have detected with our methods 

fn_sim_gamma <- function(powerdat, surv, gammas, a){
  
  Data = powerdat %>% filter(survey==surv)
  n_years = length(unique(Data$year))
  Gompertz = lm( log(wt) ~ 1 + log(lagwt) + mhw_yes_no, data=Data )
  
  # Gompertz parameters
  alpha = Gompertz$coef['(Intercept)']
  rho = Gompertz$coef['log(lagwt)']
  conditional_sd = sqrt(mean(Gompertz$residuals^2))
  
  # MHW frequency and intensity
  prob_mhw = mean( ifelse(Data[,'mhw_yes_no']=="yes",1,0), na.rm=TRUE )
  gamma = log(0.90) # vary to evaluate how much of a decrease we could detect 

  # dial back perfect autocorrelation so that the marginal standard deviation doesn't go to infinity 
  rho <- ifelse( abs(rho)>0.95, sign(rho)*0.95, rho )
  
  # Stationary properties (for initial condition)
  marginal_sd = conditional_sd / sqrt(1-rho^2)
  marginal_mean = alpha / (1-rho)
  
  sim_gamma <- NULL
  
  logB_t = rep(NA,n_years)
  MHW_t = rbinom(n_years, size=1, prob=prob_mhw)
  
  # Initialize
  # logB_t[1] = rnorm( n=1, mean=marginal_mean, sd=marginal_sd )
  logB_t[1] = marginal_mean # variance was too big for initializing 
  
  for(g in gammas){
  for( tI in 2:n_years){
    logB_t[tI] = alpha + rho*logB_t[tI-1] + g*MHW_t[tI] + rnorm( n=1, mean=0, sd=conditional_sd )
  }
  
  # set up dataframe to write out the results 
  tmp <- tibble(wt = exp(logB_t), year = seq(1, n_years, 1), mhw_yes_no = MHW_t, n_years = n_years, gamma = g, survey = unique(Data$survey), iter = a) %>% 
    arrange(year) %>% 
    mutate(wt_mt_log = log(wt / lag(wt))) 
  
  sim_gamma <- rbind(sim_gamma, tmp)
  }
  return(sim_gamma)
}


# parallelize implementing this function over iterations, gamma values, and surveys

# theoretical biomass loss from 70% to 1%
gammas <- c(sapply(seq(0.7, 0.9, 0.05), log), sapply(seq(0.91, 0.99, 0.01), log))

pwrout_gamma <- foreach(surv=survey_names$survey, .combine='rbind') %:% 
  foreach(a = seq(1, iters, 1), .combine='rbind') %dopar% {
    fn_sim_gamma(powerdat=powerdat, surv=surv, gammas=gammas, a=a)
  }

# analyze simulated data 
sim_test_gamma <- NULL
for(j in gammas){
  for(i in 1:iters){
    tmp11 <- pwrout_gamma %>% 
      filter(gamma==j,
             iter==i) 
    tmp11_no <- tmp11 %>% filter(wt_mt_log > -Inf, wt_mt_log < Inf, mhw_yes_no == 0) %>% pull(wt_mt_log)
    tmp11_yes <- tmp11 %>% filter(wt_mt_log > -Inf, wt_mt_log < Inf, mhw_yes_no == 1) %>% pull(wt_mt_log)
    tmp11_t <- t.test(tmp11_no, tmp11_yes)
    if(!class(tmp11_t)=="try-error"){
      tmpdat2 <- tibble(t = tmp11_t$statistic, df = tmp11_t$parameter, p.value = tmp11_t$p.value, mean_no_mhw = mean(tmp11_no), mean_mhw = mean(tmp11_yes), sd_no_mhw = sd(tmp11_no), sd_mhw = sd(tmp11_yes), gamma=j, iter=i)
    } else{
      tmpdat2 <- tibble(t = NA, df = NA, p.value = NA, mean_no_mhw = NA, mean_mhw = NA, sd_no_mhw = NA, sd_mhw = NA, gamma = j, iter=i)
    }
    sim_test_gamma <- rbind(sim_test_gamma, tmpdat2)
  }
}

# how many regions/simulations, if any, created an error?
sim_test_gamma_error <- sim_test_gamma %>% 
  filter(is.na(t))
nrow(sim_test_yr_error) == 0 # TRUE

sim_test_summ_gamma <- sim_test_gamma %>% 
  mutate(exp_gamma = exp(gamma)) %>% 
  group_by(exp_gamma) %>% 
  summarise(propsig <- length(p.value[p.value<=0.05])/length(p.value)) 

saveRDS(sim_test_yrs, file=here("processed-data","sim_test_yrs.rds"))
saveRDS(sim_test_gamma, file=here("processed-data","sim_test_gamma.rds"))
saveRDS(pwrout_gamma, file=here("processed-data","pwrout_gamma.rds"))
saveRDS(pwrout_yrs, file=here("processed-data","pwrout_yrs.rds"))
saveRDS(sim_test_summ_gamma, file=here("processed-data","sim_test_summ_gamma.rds"))
saveRDS(sim_test_summ_yrs, file=here("processed-data","sim_test_summ_yrs.rds"))