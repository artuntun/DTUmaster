## Examples from lecture 7
arma11 <- arima.sim(model=list(ar=c(0.8), ma=0.6), n=250)
plot(arma11)
acf(arma11)
pacf(arma11)

fit.ar1 <- arima(arma11,order =c(1,0,0) )
acf(fit.ar1$residuals)
pacf(fit.ar1$residuals)
tsdiag(fit.ar1)

fit.arma11 <- arima(arma11,order =c(1,0,1) )
acf(fit.arma11$residuals)
pacf(fit.arma11$residuals)
tsdiag(fit.arma11)

fit.arma11.css <- arima(arma11,order =c(1,0,1) , method="CSS")

fit.arma11.css
fit.arma11


## Simulating some data ...
arms1 <- arima.sim(model=list(ar=c(.4,-.3,.6), ma=0.41), n=250)
plot(arms1)

## ACF and PACF
par(mfrow=c(2,1),mar=c(3,3,1,1),mgp=c(2,0.7,0))
acf(arms1)
pacf(arms1)

## First model
fit1 <- arima(arms1,order=c(2,0,1))
fit1
tsdiag(fit1)
pacf(fit1$residuals)

## Suggestions for extension
fit2 <- arima(arms1,order=c(3,0,1))
fit2
tsdiag(fit2)
pacf(fit2$residuals)

## Now what does the object contain
names(fit2)
str(fit2)

## Likelihood ratio test
fit1$loglik - fit2$loglik
1 - pchisq(-2 * ( fit1$loglik - fit2$loglik ), df=1)
# Alternatively
pchisq(-2 * ( fit1$loglik - fit2$loglik ), df=1, lower.tail = FALSE)

## F-test
s1 <- sum(fit1$residuals^2)
s2 <- sum(fit2$residuals^2)
n1 <- 4
n2 <- 5
f.stat <- (s1-s2)/(n2-n1) / (s2/(length(fit1$residuals)-n2))
pf(f.stat , df1 = n2 - n1, df2 = (length(fit1$residuals)-n2), lower.tail = FALSE)


###################
## Next example ####
dat <- read.csv("data.lecture7.csv")$x

par(mfrow=c(3,1),mar=c(3,3,1,1),mgp=c(2,0.7,0))
plot(dat,type="l")
acf(dat)
pacf(dat)

## we want that collection of plots a lot so let's wrap it in a function.

diagtool <- function(residuals){
    par(mfrow=c(3,1),mar=c(3,3,1,1),mgp=c(2,0.7,0))
    plot(residuals, type="l")
    acf(residuals)
    pacf(residuals)
}
diagtool(dat)

# insert the values for the model you wish to apply

analyse0 <- arima(dat,order=c(2,0,2),include.mean=F,method="ML")
analyse0
diagtool(analyse0$residuals)
tsdiag(analyse0)

arima(dat,order=c(4,0,2),include.mean=F,method="ML")
analyse0 <- arima(dat,order=c(4,0,2),include.mean=F,method="ML")
diagtool(analyse0$residuals)
tsdiag(analyse0)

## Looking at distributional assumption
hist(analyse0$residuals,probability=T,col='blue')
curve(dnorm(x,sd=sqrt(analyse0$sigma2)), col=2, lwd=3, add = TRUE)
 
qqnorm(analyse0$residuals)
qqline(analyse0$residuals,col=2)
 
 
## Comparing with random numbers ...
par(mfrow=c(2,1))
ts.plot(analyse0$residuals)
ts.plot(ts(rnorm(length(analyse0$residuals))*sqrt(analyse0$sigma2)),
         ylab='Simulated residuals')
 
# sign test mean and sd:
N <- length(analyse0$residuals)
(N-1)/2
### sd:
sqrt((N-1)/4) 
### 95% interval:
(N-1)/2 +  c(-1,1) * 1.96 * sqrt(N-1/4) 
### test:
res <- analyse0$residuals
(N.sign.changes <- sum( res[-1] * res[-length(res)]<0 ))



### or:
binom.test(N.sign.changes, length(analyse0$residuals)-1)
## 0.5 is within the interval so OK 
  
### test in the acf, 15 lags (exchange the number of
### degrees of freedom according to your model:
## First extracting the ACF estimates
acfvals <- acf(analyse0$residuals,type="correlation",plot=FALSE)$acf[2:15]
## Calculating the test statistic
test.stat <- sum(acfvals^2)*  (length(analyse0$residuals)-1)
## Performing the test in the naive way ..
1 - pchisq(test.stat, length(acfvals)-length(analyse0$coef)) ## Numerical issue ... next line is better
pchisq(test.stat, length(acfvals)-length(analyse0$coef),lower.tail = FALSE) 


analyse0
cpgram(dat)
cpgram(analyse0$residuals)

## Testing a single parameter ... e.g. ma2
p <- length(analyse0$coef)
pt(0.2237/0.0612, df = N-p,lower.tail = FALSE) * 2

