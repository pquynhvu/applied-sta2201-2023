// hierarchical model
data {
  int<lower = 1> N;                             
  int y[N];     
  vector[N] formerly_married; 
  vector[N] married; 
  int<lower = 1> J;                             
  int<lower = 1> K;
  int<lower = 1> age[N];                      
  int<lower = 0> edu[N];                      
}
parameters {
  vector[3] beta;
  vector[J] alpha_age;
  vector[K] alpha_edu;
  real<lower = 0> sigma_age;
  real<lower = 0> sigma_edu;
}
transformed parameters {
  vector[N] lin_pred;
  
  for(i in 1:N){
    lin_pred[i] = beta[1] + beta[2]*formerly_married[i] + beta[3]*married[i] + alpha_age[age[i]] + alpha_edu[edu[i]];
  }
}
model {
  target += bernoulli_logit_lpmf(y|lin_pred);
  
  alpha_age[1] ~ normal(0, sigma_age);
  alpha_age[2:J] ~ normal(alpha_age[1:(J-1)], sigma_age);
  alpha_edu[1:K] ~ normal(0, sigma_edu);
  sigma_age ~ normal(0, 1);
  sigma_edu ~ normal(0, 1);
  beta[1] ~ normal(0, 1);
  beta[2] ~ normal(0, 1);
  beta[3] ~ normal(0, 1);
}
