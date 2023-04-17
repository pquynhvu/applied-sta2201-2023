data{
   int N;                                     // # of obs
   int D;                                     // # of districts
   int A;                                     // # of age groups
   int K;                                     // # of coefficients
   int <lower=0, upper=1> gender[N];
   int <lower=0> age_gp[N];  
   int <lower=0> source[N];  
   int <lower=1, upper=D> district_id[N];
   real <lower=1> pop[D];
   real prop80plus[D];
   real stop_volume[D];
   real collision_per_stop[D];
   int<lower=1> num_of_hospitals[D];
   int <lower=0> deaths[D];                  // count outcome 
   int ctab1[D+1];
}
parameters {
  real alpha[K];
}
transformed parameters  {
  real mu[N];
  real mean_mu[D];
  
  for (i in 1:N) {
     mu[i] = exp(alpha[1]+ alpha[2]*gender[i]+ alpha[3]*age_gp[i]+ alpha[4]*source[i] + alpha[5]*prop80plus[district_id[i]] + alpha[6]*stop_volume[district_id[i]] + alpha[7]*num_of_hospitals[district_id[i]]);     
   }
  for (j in 1:D) {   
     mean_mu[j] = mean(mu[(ctab1[j]+1):ctab1[j+1]]);      
    }
}
model {
  alpha ~ normal(0, 1);                                  
  for (j in 1:D) { 
   deaths[j] ~ poisson(mean_mu[j]*pop[j]);           
  }
}
 
 