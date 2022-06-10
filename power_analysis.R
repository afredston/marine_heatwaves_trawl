library(tidyverse)
set.seed(42)
library(here)
library(doParallel)
detectCores()
registerDoParallel(cores=4)
survey_summary <-read_csv(here("processed-data","survey_biomass_with_CTI.csv")) %>% inner_join(mhw_summary_sat_sst_5_day)
survey_names <- read_csv(here('processed-data','survey_names.csv'))

###########
# power analysis
###########

powerdat <- survey_summary %>%
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(lagwt = lag(wt, 1))

iters <- 100
trialyrs <- seq(10, 100, 10)

# PART 1 
# based on the effect sizes in Cheung et al. (6% overall biomass loss in worst-case scenario), how much data would we have needed, given the actual variance in the data? 

# create a function that takes a dataset, a list of surveys, and a list of year lengths, and simulates MHW effects in each survey for that number of years based on Cheung et al.'s estimate of true biomass effects of MHWs 
sim_power_by_yr <- function(powerdat, surv, trialyrs, a){
  
  Data = powerdat %>% filter(survey==surv)
  Gompertz = lm( log(wt) ~ 1 + log(lagwt) + mhw_yes_no, data=Data )
  
  # Gompertz parameters
  alpha = Gompertz$coef['(Intercept)']
  beta = Gompertz$coef['log(lagwt)']
  conditional_sd = sqrt(mean(Gompertz$residuals^2))
  
  # MHW frequency and intensity
  prob_mhw = mean( ifelse(Data[,'mhw_yes_no']=="yes",1,0), na.rm=TRUE )
  #gamma = Gompertz$coef['mhw_yes_noyes']
  gamma = log(0.94) # from Cheung et al. 2021
  
  # Stationary properties (for initial condition)
  marginal_sd = conditional_sd / (1-beta)^2
  marginal_mean = alpha / (1-beta)
  
  pwr_results <- NULL
  
  for(j in trialyrs){
    n_years = j
    logB_t = rep(NA,n_years)
    MHW_t = rbinom(n_years, size=1, prob=prob_mhw)
    
    # Initialize
    # logB_t[1] = rnorm( n=1, mean=marginal_mean, sd=marginal_sd )
    logB_t[1] = marginal_mean # variance was too big for initializing 
    
    # Project every year 
    #  Gompertz:  log(N(t+1)) = alpha + beta * log(N(t)) + effects + error
    for( tI in 2:n_years){
      logB_t[tI] = alpha + beta*logB_t[tI-1] + gamma*MHW_t[tI] + rnorm( n=1, mean=0, sd=conditional_sd )
    }
    
    # set up dataframe to write out the results 
    tmp <- tibble(wt = exp(logB_t), year = seq(1, n_years, 1), mhw_yes_no = MHW_t, n_years = n_years, gamma = gamma, survey = unique(Data$survey), iter = a) %>% 
      arrange(year) %>% 
      mutate(wt_mt_log = log(wt / lag(wt))) 
    
    pwr_results <- rbind(pwr_results, tmp)
  } # close j loop (nyears)
  
  return(pwr_results)
}

# parallelize implementing this function over iterations, year lengths, and surveys

pwrout <- foreach(surv=survey_names$survey, .combine='rbind') %:% 
  foreach(a = seq(1, iters, 1), .combine='rbind') %dopar% {
    sim_power_by_yr(powerdat=powerdat, surv=surv, trialyrs=trialyrs, a=a)
  }
# is it the right size?
(iters * sum(trialyrs) * nrow(survey_names)) == nrow(pwrout)

# analyze simulated data 
sim_test <- NULL
for(j in trialyrs){
  for(i in 1:iters){
    tmp10 <- pwrout %>% 
      filter(n_years==j,
             iter==i) 
    tmp10_no <- tmp10 %>% filter(wt_mt_log > -Inf, wt_mt_log < Inf, mhw_yes_no == 0) %>% pull(wt_mt_log)
    tmp10_yes <- tmp10 %>% filter(wt_mt_log > -Inf, wt_mt_log < Inf, mhw_yes_no == 1) %>% pull(wt_mt_log)
    tmp10_t <- t.test(tmp10_no, tmp10_yes)
    if(!class(tmp10_t)=="try-error"){
      tmpdat <- tibble(t = tmp10_t$statistic, df = tmp10_t$parameter, p.value = tmp10_t$p.value, mean_no_mhw = mean(tmp10_no), mean_mhw = mean(tmp10_yes), sd_no_mhw = sd(tmp10_no), sd_mhw = sd(tmp10_yes), n_years = j, iter=i)
    } else{
      tmpdat <- tibble(t = NA, df = NA, p.value = NA, mean_no_mhw = NA, mean_mhw = NA, sd_no_mhw = NA, sd_mhw = NA, n_years = j, iter=i)
    }
    sim_test <- rbind(sim_test, tmpdat)
  }
}

sim_test_summ <- sim_test %>% 
  group_by(n_years) %>% 
  summarise(propsig <- length(p.value[p.value<=0.05])/length(p.value))

# PART 2: given the data we have, what effect size could we detect? 

effectout <- NULL
for(surv in survey_names$survey){
  Data = powerdat %>% filter(survey==surv)
  Gompertz = lm( log(wt) ~ 1 + log(lagwt) + mhw_yes_no, data=Data )
  
  # Gompertz parameters
  alpha = Gompertz$coef['(Intercept)']
  beta = Gompertz$coef['log(lagwt)']
  conditional_sd = sqrt(mean(Gompertz$residuals^2))
  
  #
  n_years = length(unique(Data$year))
  
  # MHW frequency and intensity
  prob_mhw = mean( ifelse(Data[,'mhw_yes_no']=="yes",1,0), na.rm=TRUE )
  
  gamma = log(0.90) # vary to evaluate how much of a decrease we could detect 
  
  # Stationary properties (for initial condition)
  marginal_sd = conditional_sd / (1-beta)^2
  marginal_mean = alpha / (1-beta)
  
  #
  logB_t = rep(NA,n_years)
  MHW_t = rbinom(n_years, size=1, prob=prob_mhw)
  
  # Initialize
  #  logB_t[1] = rnorm( n=1, mean=marginal_mean, sd=marginal_sd )
  logB_t[1] = mean = marginal_mean # variance was too big for initializing 
  
  # Project
  #  Gompertz:  log(N(t+1)) = alpha + beta * log(N(t)) + effects + error
  for( tI in 2:n_years){
    logB_t[tI] = alpha + beta*logB_t[tI-1] + gamma*MHW_t[tI] + rnorm( n=1, mean=0, sd=conditional_sd )
  }
  
  tmp <- tibble(wt = exp(logB_t), year = seq(1, n_years, 1), mhw_yes_no = MHW_t, n_years = n_years, gamma = gamma, survey = unique(Data$survey))
  
  effectout <- rbind(effectout, tmp)
}

effecttest <- effectout %>% 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(wt_mt_log = log(wt / lag(wt))) %>% 
  filter(wt_mt_log > -Inf, wt_mt_log < Inf) 

effecttest_mhw <- effecttest %>% 
  filter(mhw_yes_no == 1) %>% 
  pull(wt_mt_log)

effecttest_no_mhw <- effecttest %>% 
  filter(mhw_yes_no == 0) %>% 
  pull(wt_mt_log)

t.test(effecttest_no_mhw, effecttest_mhw) 
