data{
  int<lower=1> N;              // number of weeks
  vector[N] t;                 // time
  real<lower = 0> y[N];        // logged total cases
}
parameters {
  real<lower = 0> A; 
  real<lower = 0> C; 
  real<lower = 0> k;
  real<lower = 0> T; 
}
transformed parameters {
  vector[N] mu;
  for(i in 1:N){
    mu[i] = A + C*exp(- exp(- k*(t[i] - T)));
  }
}
model {
  // priors
  A ~ normal(0, 1);
  C ~ normal(0,1);
  k ~ exponential(1);
  T ~ normal(0,1);
  // likelihood
  for(n in 1:N){
    target += normal_lpdf(y[n] | mu[n], 1);
  }
}
generated quantities{
  vector[N] y_rep; 
  vector[N] log_lik; 
  for (n in 1:N) { 
    y_rep[n] = normal_rng(mu[n], 1); 
    log_lik[n] = normal_lpdf(y[n] | mu[n], 1);  
  } 
}
