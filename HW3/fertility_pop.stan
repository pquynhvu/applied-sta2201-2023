data {
  int <lower=1> N;                           // number of observations
  int <lower=1> K;
  int<lower=0, upper=1> formerly_married[N]; 
  int<lower=0, upper=1> married[N]; 
  int<lower=1> A;                           // # of age groups
  int<lower=1> E;                           // # of education levels
  int<lower=1> age[N];                    // age factor levels
  int<lower=0> edu[N];                    // education factor levels
  int<lower=0, upper =1> y[N];              // outcome
}
parameters{
  vector[K] beta;
  vector[A] alpha_age;
  vector[E] alpha_edu;
  real sigma_age;
  real sigma_edu;
}
transformed parameters{
  vector[N] lin_pred; 
  for (i in 1:N){
    lin_pred[i] = beta[1]+beta[2]*formerly_married[i]+beta[3]*married[i]+alpha_age[age[i]]+alpha_edu[edu[i]];
 }
}
model {
  y[1:N] ~ bernoulli_logit(lin_pred[1:N]);
  sigma_age ~ normal(0, 1);
  sigma_edu ~ normal(0, 1);
  beta ~ normal(0, 1);
  alpha_age[1] ~ normal(0, 1);
  alpha_age[2:A] ~ normal(alpha_age[1:(A-1)], sigma_age);
  alpha_edu[1:E] ~ normal(0, sigma_edu);
}
