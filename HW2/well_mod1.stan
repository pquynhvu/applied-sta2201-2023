data {
  int<lower = 0> N; // number of obs    
  int<lower = 0> K; // number of coefficients
  vector[N] dist_c;    
  vector[N] arsenic_c;     
  int<lower=0, upper=1> y[N] ;  
}
transformed data {
  vector[N] Inter; 
  Inter = dist_c.*arsenic_c; // element-wise multiplication
}
parameters {
  vector[K] beta;
}
model{
  beta[1] ~ normal(0, 1);
  beta[2] ~ normal(0, 1);
  beta[3] ~ normal(0, 1);
  beta[4] ~ normal(0, 1);
  
  y ~ bernoulli_logit(beta[1] + beta[2]*dist_c + beta[3]*arsenic_c + beta[4]*Inter);
}
generated quantities {
  vector[N] yrep; 
  vector[N] log_lik;
  
  for (n in 1:N) {
    real y_hat_n = beta[1] + beta[2]*dist_c[n] + beta[3]*arsenic_c[n] + beta[4]*Inter[n];
    log_lik[n] = bernoulli_logit_log(y[n], y_hat_n);
    yrep[n] = bernoulli_logit_rng(y_hat_n);
  }
}
