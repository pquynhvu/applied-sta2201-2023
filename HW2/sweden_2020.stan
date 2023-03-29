data {
  int<lower = 0> N;
  int X[N]; // age
  int P[N]; // pop
  int y[N]; // deaths 
}
parameters {
  real <lower = 0> alpha; 
  real <lower = 0> beta;
}
transformed parameters{
  vector[N] eta;
  for(i in 1:N){
    eta[i] = beta*X[i] + log(alpha*P[i]);
  }
}
model {
  target += normal_lpdf(alpha | 0.5, 0.002); 
  target += normal_lpdf(beta | 0.03, 0.0055);
  for (i in 1:N) { 
      target += poisson_log_lpmf(y[i] | eta[i]); 
  } 
}
generated quantities { 
  int<lower=0> y_rep[N]; 
  vector[N] log_lik; 
  
  for (i in 1:N) { 
    if (eta[i] > 20) { 
        y_rep[i] = poisson_log_rng(20); 
    }else{
        y_rep[i] = poisson_log_rng(eta[i]); 
    }
    log_lik[i] = poisson_log_lpmf(y[i] | eta[i]);  
  } 
} 
