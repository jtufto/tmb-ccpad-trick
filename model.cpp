#include <TMB.hpp>
template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(x);
  DATA_VECTOR(y);
  DATA_FACTOR(id);
  PARAMETER_VECTOR(u);
  PARAMETER(a);
  PARAMETER(b);
  PARAMETER(log_sigma); 
  Type sigma = exp(log_sigma);
  ADREPORT(sigma);
  
  Type nll = 0;
  nll -= sum(dnorm(u, Type(0), sigma, true));
  for (int i=0; i<y.size(); i++) {
    Type eta = a + b*x(i);
    if (CppAD::Variable(log_sigma) )
      eta += u(id(i));
    nll -= dbinom(y(i), Type(1), 1/(1+exp(-eta)), true); 
  }
  return nll;
}
