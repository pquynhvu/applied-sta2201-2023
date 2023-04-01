data{
  int<lower=1> N;              // number of weeks
  vector[N] t;                 // week
  real<lower = 0> y[N];        // logged deaths
}
parameters {
  real<lower = 0> alpha; 
  real<lower = 0> beta; 
  real<lower = 0> K;
  real<lower = 0> T; 
  real<lower = 0> sigma; 
}
transformed parameters {
  vector[N] mu;
  for(i in 1:N){
    mu[i] = alpha + beta*exp(- exp(- K*(t[i] - T)));
  }
}
model {
  // priors
  alpha ~ normal(0, 1);
  beta ~ normal(0,1);
  K ~ exponential(1);
  T ~ normal(0,1);
  sigma ~ student_t(3, 0, 1000);
  // likelihood
  for(n in 1:N){
    target += normal_lpdf(y[n] | mu[n], sigma);
  }
}
generated quantities{
  vector[N] y_rep; 
  vector[N] log_lik; 
  for (n in 1:N) { 
    y_rep[n] = normal_rng(mu[n], sigma); 
    log_lik[n] = normal_lpdf(y[n] | mu[n], sigma);  
  } 
}
