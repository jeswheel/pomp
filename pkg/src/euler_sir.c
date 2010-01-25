// dear emacs, please treat this as -*- C++ -*-

#include <Rmath.h>

#include "pomp.h"

static double expit (double x) {
  return 1.0/(1.0 + exp(-x));
}

static double logit (double x) {
  return log(x/(1-x));
}

static double term_time (double t, double b0, double b1) 
{
  static double correction = 0.52328767123287671233;
  double day = 365.0 * (t - floor(t));
  int tt = (day >= 7.0 && day <= 100.0) 
    || (day >= 115.0 && day <= 200.0) 
    || (day >= 252.0 && day <= 300.0) 
    || (day >= 308.0 && day <= 356.0);
  return b0 * (1.0 + b1 * (-1.0 + 2.0 * ((double) tt))) / (1.0 + correction * b1);
}

#define LOGGAMMA       (p[parindex[0]]) // recovery rate
#define LOGMU          (p[parindex[1]]) // baseline birth and death rate
#define LOGIOTA        (p[parindex[2]]) // import rate
#define LOGBETA        (p[parindex[3]]) // transmission rate
#define LOGBETA_SD     (p[parindex[4]]) // environmental stochasticity SD in transmission rate
#define LOGPOPSIZE     (p[parindex[5]]) // population size
#define LOGRHO         (p[parindex[6]]) // reporting probability
#define NBASIS         (p[parindex[7]]) // number of periodic B-spline basis functions
#define DEGREE         (p[parindex[8]]) // degree of periodic B-spline basis functions
#define PERIOD         (p[parindex[9]]) // period of B-spline basis functions

#define SUSC      (x[stateindex[0]]) // number of susceptibles
#define INFD      (x[stateindex[1]]) // number of infectives
#define RCVD      (x[stateindex[2]]) // number of recovereds
#define CASE      (x[stateindex[3]]) // number of cases (accumulated per reporting period)
#define W         (x[stateindex[4]]) // integrated white noise

#define MEASLES   (y[0])

void binom_dmeasure (double *lik, double *y, double *x, double *p, int give_log,
		     int *stateindex, int *parindex, int *covindex,
		     int ncovars, double *covars, double t) {
  *lik = dbinom(MEASLES,CASE,exp(LOGRHO),give_log);
}

void binom_rmeasure (double *y, double *x, double *p, 
		     int *stateindex, int *parindex, int *covindex,
		     int ncovars, double *covars, double t) {
  MEASLES = rbinom(CASE,exp(LOGRHO));
}

#undef MEASLES

// SIR model with Euler multinomial step
// forced transmission (basis functions passed as covariates)
// constant population size as a parameter
// environmental stochasticity on transmission
void sir_euler_simulator (double *x, const double *p, 
			  const int *stateindex, const int *parindex, const int *covindex,
			  int covdim, const double *covar, 
			  double t, double dt)
{
  int nrate = 6;
  double rate[nrate];		// transition rates
  double trans[nrate];		// transition numbers
  double gamma, mu, iota, beta_sd, beta_var, popsize;
  double beta;
  double dW;
  int nseas = (int) NBASIS;	// number of seasonal basis functions
  int deg = (int) DEGREE;	// degree of seasonal basis functions
  double seasonality[nseas];

  // untransform the parameters
  gamma = exp(LOGGAMMA);
  mu = exp(LOGMU);
  iota = exp(LOGIOTA);
  beta_sd = exp(LOGBETA_SD);
  popsize = exp(LOGPOPSIZE);
  beta_var = beta_sd*beta_sd;

  if (nseas <= 0) return;
  periodic_bspline_basis_eval(t,PERIOD,deg,nseas,&seasonality[0]);
  beta = exp(dot_product(nseas,&seasonality[0],&LOGBETA));

  // test to make sure the parameters and state variable values are sane
  if (!(R_FINITE(beta)) || 
      !(R_FINITE(gamma)) ||
      !(R_FINITE(mu)) ||
      !(R_FINITE(beta_sd)) ||
      !(R_FINITE(iota)) ||
      !(R_FINITE(popsize)) ||
      !(R_FINITE(SUSC)) ||
      !(R_FINITE(INFD)) ||
      !(R_FINITE(RCVD)) ||
      !(R_FINITE(CASE)) ||
      !(R_FINITE(W)))
    return;

  if (beta_sd > 0.0) {		// environmental noise is ON
    dW = rgamma(dt/beta_var,beta_var); // gamma noise, mean=dt, variance=(beta_sd^2 dt)
    if (!(R_FINITE(dW))) return;
  } else {			// environmental noise is OFF
    dW = dt;
  }

  // compute the transition rates
  rate[0] = mu*popsize;		// birth into susceptible class
  rate[1] = (iota+beta*INFD*dW/dt)/popsize; // force of infection
  rate[2] = mu;			// death from susceptible class
  rate[3] = gamma;		// recovery
  rate[4] = mu;			// death from infectious class
  rate[5] = mu; 		// death from recovered class

  // compute the transition numbers
  trans[0] = rpois(rate[0]*dt);	// births are Poisson
  reulermultinom(2,SUSC,&rate[1],dt,&trans[1]);
  reulermultinom(2,INFD,&rate[3],dt,&trans[3]);
  reulermultinom(1,RCVD,&rate[5],dt,&trans[5]);

  // balance the equations
  SUSC += trans[0]-trans[1]-trans[2];
  INFD += trans[1]-trans[3]-trans[4];
  RCVD += trans[3]-trans[5];
  CASE += trans[3];		// cases are cumulative recoveries
  if (beta_sd > 0.0) {
    W += (dW-dt)/beta_sd;	// mean zero, variance = dt
  }

}

#define DSDT    (f[stateindex[0]])
#define DIDT    (f[stateindex[1]])
#define DRDT    (f[stateindex[2]])
#define DCDT    (f[stateindex[3]])

void sir_ODE (double *f, double *x, const double *p, 
	      const int *stateindex, const int *parindex, const int *covindex,
	      int covdim, const double *covar, double t) 
{
  int nrate = 6;
  double rate[nrate];		// transition rates
  double term[nrate];		// terms in the equations
  double gamma, mu, iota, popsize;
  double beta;
  int nseas = (int) NBASIS;	// number of seasonal basis functions
  int deg = (int) DEGREE;	// degree of seasonal basis functions
  double seasonality[nseas];
  
  // untransform the parameters
  gamma = exp(LOGGAMMA);
  mu = exp(LOGMU);
  iota = exp(LOGIOTA);
  popsize = exp(LOGPOPSIZE);

  if (nseas <= 0) return;
  periodic_bspline_basis_eval(t,PERIOD,deg,nseas,&seasonality[0]);
  beta = exp(dot_product(nseas,&seasonality[0],&LOGBETA));

  // compute the transition rates
  rate[0] = mu*popsize;		// birth into susceptible class
  rate[1] = (iota+beta*INFD)/popsize; // force of infection
  rate[2] = mu;			// death from susceptible class
  rate[3] = gamma;		// recovery
  rate[4] = mu;			// death from infectious class
  rate[5] = mu; 		// death from recovered class

  // compute the several terms
  term[0] = rate[0];
  term[1] = rate[1]*SUSC;
  term[2] = rate[2]*SUSC;
  term[3] = rate[3]*INFD;
  term[4] = rate[4]*INFD;
  term[5] = rate[5]*RCVD;

  // balance the equations
  DSDT = term[0]-term[1]-term[2];
  DIDT = term[1]-term[3]-term[4];
  DRDT = term[3]-term[5];
  DCDT = term[3];		// cases are cumulative recoveries

}

#undef DSDT
#undef DIDT
#undef DRDT
#undef DCDT

#undef SUSC
#undef INFD
#undef RCVD
#undef CASE
#undef W

#undef LOGGAMMA
#undef LOGMU
#undef LOGIOTA
#undef LOGBETA
#undef LOGBETA_SD
#undef LOGPOPSIZE
#undef LOGRHO
#undef NBASIS
#undef DEGREE
#undef PERIOD
