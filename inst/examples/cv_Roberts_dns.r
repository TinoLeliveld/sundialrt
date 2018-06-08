Rcpp::sourceCpp(code = '#include <Rcpp.h>

using namespace Rcpp;

typedef NumericVector (*funcPtr) (double t, NumericVector y, NumericVector ydot);

// [[Rcpp::export]]
NumericVector cv_Roberts_dns (double t, NumericVector y, NumericVector ydot){
  ydot[0] = -0.04 * y[0] + 1e04 * y[1] * y[2];
  ydot[2] = 3e07 * y[1] * y[1];
  ydot[1] = -ydot[0] - ydot[2];

  return ydot;

}

// [[Rcpp::export]]
XPtr<funcPtr> putFunPtrInXPtr() {

  XPtr<funcPtr> testptr(new funcPtr(&cv_Roberts_dns), false);
  return testptr;

}')


# R code to generate time vector, IC and solve the equations
time_t <- c(0.0, 0.4, 4, 40, 4E2, 4E3, 4E4, 4E5, 4E6, 4E7, 4E8, 4E9, 4E10)
my_fun <- putFunPtrInXPtr()
df <- cvode(time_t, c(1,0,0), my_fun , 1e-04, c(1e-8,1e-14,1e-6))