library(TMB)
compile("model.cpp")
dyn.load(dynlib("model"))

# Simulate some data
n <- 1000
set.seed(2)
x <- rnorm(n)
id <- factor(rep(1:(n/50),each=50))
y <- rbinom(n, 1, plogis(.1 + .2*x + rnorm(nlevels(id), sd=2))[id])
data <- list(x=x, y=y, id=id)
parameters <- list(u = rep(0, nlevels(id)), a=0, b=0, log_sigma=log(.5))

# fit the model with random effect
obj <- MakeADFun(data, parameters, DLL="model", random="u", silent=TRUE)
opt <- do.call("optim", obj)
opt$par
opt$val

# fit model without
map <- list(log_sigma=factor(NA))
obj <- MakeADFun(data, parameters, DLL="model", random="u", map=map, silent=TRUE)
opt <- do.call("optim", obj)
opt$par
opt$val

# check results against glmmtmb
library(glmmTMB)
logLik(glmmTMB(y~x+(1|id),family=binomial))
logLik(glmmTMB(y~x,family=binomial))
