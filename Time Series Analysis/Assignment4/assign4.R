rm(list=ls())
setwd("/home/arturo/Documents/Time Series Analysis/Assignment4")
myData = read.table("A4_data.csv", sep =";", header = TRUE)
trainData = myData[1:90,]
testData = myData[91:94,]
 

####################### QUESTION 1: PLOTTING ############################
png("rawseries.png", width=5, height=5, units="in", res=300)
par(mfrow = c(2,2))
plot(trainData[,2],type="l", col = "blue",ylab="zip",xlab = "lag")
lines(trainData[,3],type="l", col = "red")
lines(trainData[,4],type="l", col = "green")
lines(trainData[,5],type="l", col = "orange")

plot(trainData$cpi,type="l", col = "blue",ylab="cpi",xlab = "lag")
plot(trainData$discount,type="l", col = "blue",ylab="discount",xlab = "lag")
plot(trainData$real30yr,type="l", col = "blue",ylab="real30yr",xlab = "lag")
dev.off()


#clearly the prices have a trend and are not stationary. 
#first difference. After the differentation it look much more stationary 
png("diffseriesprices.png", width=5, height=5, units="in", res=300)
par(mfrow = c(2,2))
plot(diff(trainData[,2]), type="l", col = "blue",ylab="zip2000",xlab = "lag")
plot(diff(trainData[,3]), type="l", col = "red",ylab="zip2800",xlab = "lag")
plot(diff(trainData[,4]), type="l", col = "green",ylab="zip7400",xlab = "lag")
plot(diff(trainData[,5]), type="l", col = "orange",ylab="zip8900",xlab = "lag")
dev.off()

png("diffcpi.png", width=5, height=5, units="in", res=300)
par(mfrow = c(2,2))
#and also the discount, relay30 and cpi
plot(diff(trainData$cpi),type="l", col = "blue",ylab="cpi",xlab = "lag")
plot(diff(trainData$discount),type="l", col = "blue",ylab="discount",xlab = "lag")
plot(diff(trainData$real30yr),type="l", col = "blue",ylab="real30yr",xlab = "lag")
dev.off()

png("difflogprices.png", width=5, height=5, units="in", res=300)
par(mfrow = c(2,2))
plot(diff(log(trainData[,2])), type="l", col = "blue",ylab="zip2000",xlab = "lag")
plot(diff(log(trainData[,3])), type="l", col = "red",ylab="zip2800",xlab = "lag")
plot(diff(log(trainData[,4])), type="l", col = "green",ylab="zip7400",xlab = "lag")
plot(diff(log(trainData[,5])), type="l", col = "orange",ylab="zip8900",xlab = "lag")
dev.off()

#########################  QUESTION 2: ACF, PACF, CCF  ###########################

names = cbind("acfzip200.png","acfzip2800.png","acfzip7400.png","acfzip8900.png",
              "acfcpi.png","acfdiscount.png","acfreal30yr.png")

#Plotting ACF, PACF of the series and the first difference
par(mar=c(4,4,4,4))
for (n in 1:7) {
  png(names[n], width=6, height=5, units="in", res=300)
  par(mfrow = c(2,2))
  acf(trainData[,n+1], main = names(trainData)[n+1])
  pacf(trainData[,n+1], main = names(trainData)[n+1])
  acf(diff(trainData[,n+1]), main = paste("diff",names(trainData)[n+1]))
  pacf(diff(trainData[,n+1]), main = paste("diff",names(trainData)[n+1]))
  dev.off()
}

#Plotting CCFs
dev.off()
library(stringr)
par(mar=c(3,3,3,3))
for (n in 2:8) {
  num = toString(n)
  st = cbind("ccf", num, ".png")
  png(str_c(st, collapse = ""), width=6, height=8, units="in", res=300)
  par(mfrow=c(4,2))
  for (m in 2:8) {
    plot(ccf(trainData[1:90,n], trainData[1:90,m], lag.max=20, plot=FALSE), 
         main=paste(names(trainData[n]), names(trainData[m]), sep=" and "))
  }
  dev.off()
}

##################   Question3: Univariate ARIMA model ####################
(zip2000arma110 <- arima(log(trainData$zip2000), c(1, 1, 0)))
acf(zip2000arma110$residuals)
pacf(zip2000arma110$residuals)
qqnorm(zip2000arma110$residuals)
qqline(zip2000arma110$residuals)

(zip2800arma010 <- arima(log(trainData$zip2800), c(0, 1, 0)))
acf(zip2800arma010$residuals)
pacf(zip2800arma010$residuals)
qqnorm(zip2800arma010$residuals)
qqline(zip2800arma010$residuals)

(zip7400arma011 <- arima(log(trainData$zip7400), c(0, 1, 1)))
acf(zip7400arma011$residuals)
pacf(zip7400arma011$residuals)
qqnorm(zip7400arma011$residuals)
qqline(zip7400arma011$residuals)

(zip8900arma011 <- arima(log(trainData$zip8900), c(0, 1, 1)))
acf(zip8900arma011$residuals)
pacf(zip8900arma011$residuals)
qqnorm(zip8900arma011$residuals)
qqline(zip8900arma011$residuals)

#modeling cpi
acf(trainData$cpi)

par(mfrow=c(1,2))
acf(diff(trainData$cpi), main="ACF: diff(cpi)")
pacf(diff(trainData$cpi), main="PACF: diff(cpi)")
(cpiarima010010 <- arima(trainData$cpi, c(0, 1, 0),
                         seasonal = list(order = c(0, 1, 0), period = 4)))
par(mfrow=c(1,2))
acf(cpiarima010010$residuals, main="ACF: residuals")
pacf(cpiarima010010$residuals, main="PACF: residuals")
(cpiarima010010 <- arima(trainData$cpi, c(0, 1, 0),
                         seasonal = list(order = c(0, 1, 1), period = 4)))
par(mfrow=c(1,2))
acf(cpiarima010010$residuals,main="ACF: residuals")
pacf(cpiarima010010$residuals,main="PACF: residuals")
qqnorm(cpiarima010010$residuals)
qqline(cpiarima010010$residuals)
res = cpiarima010010$residuals
##signTest
sign.test = function(res) {
  binom.test(sum(res[-1]*res[-length(res)]<0), length(res)-1)
}
sign.test(res)
count = 0
for(n in 1:length(res)){
  if(res[n]<0){
    count = count +1
  }
}

#modeling discount
acf(trainData$discount)
acf(diff(trainData$discount))
(discountarma110 <- arima(trainData$discount, c(1, 1, 0)))
acf(discountarma110$residuals)
pacf(discountarma110$residuals)
qqnorm(discountarma110$residuals)
qqline(discountarma110$residuals)

#modeling real30yr
acf(trainData$real30yr)
acf(diff(trainData$real30yr))
(real30yrarma110 <- arima(trainData$real30yr, c(1, 1, 0)))
acf(real30yrarma110$residuals)
pacf(real30yrarma110$residuals)
qqnorm(real30yrarma110$residuals)
qqline(real30yrarma110$residuals)

############### Pre whitening to get proper CCFs
ccf(trainData$zip2000,trainData$zip2800)
ar1 = zip2000arma110$coef
pw2000 = zip2000arma110$residuals
names1 = cbind("pw2000","pw2800","pw7400","pw8900","cpi","discount","real30yr")

par(mar=c(3,3,3,3))
png("ccfzip2000.png", width=5, height=8, units="in", res=300)
par(mfrow=c(3,2))
for(n in 1:6){
  pw <- filter(trainData[,n+2], filter = c(1,-(1+ar1), ar1), sides = 1) 
  ccf(pw2000,pw , na.action=na.omit, 
      main =paste(names1[1], names1[n+1], sep=" and "),
      ylab = "CCF")
}
dev.off()
png("zip2000ccf.png", width=5, height=8, units="in", res=300)
par(mfrow=c(3,2))
for(n in 1:6){
  pw <- filter(trainData[,n+2], filter = c(1,-(1+ar1), ar1), sides = 1) 
  ccf(pw,pw2000 , na.action=na.omit, 
      main =paste(names1[n+1], names1[1], sep=" and "),
      ylab = "CCF")
}
dev.off()


library(forecast)
pw28new <-Arima(trainData$zip7400, model=arma110)


################## Question 4: Multivariate ARIMA ########################

library(marima)
trainDatawith <- trainData[,2:8]
trainDatawith
data.train<-t(trainData[,2:8])
data.train

#Model1: First Model: cpi, discount and real30yr as regressor variables
ar<-c(1)
ma<-c(1)
difference <- matrix(c(1,1,2,1,3,1,4,1,5,4,5,1,6,1,6,1), nrow=2)
d <- define.dif(data.train, difference=difference)
Model1 <- define.model(kvar=7, ar=ar, ma=ma, reg.var = c(5,6,7),  indep=NULL)
Marima1 <- marima(d$y.dif,means=1, ar.pattern = Model1$ar.pattern, 
                  ma.pattern = Model1$ma.pattern, Check=FALSE, Plot="log.det", 
                  penalty=2)
short.form(Marima1$ar.estimates, leading = FALSE)
short.form(Marima1$ma.estimates, leading = FALSE)

round(short.form(Marima1$ar.fvalues, leading = FALSE), 2)
round(short.form(Marima1$ma.fvalues, leading = FALSE), 2)

round(Marima1$data.cov[1:4,1:4],4)
round(1-(diag(Marima1$resid.cov[1:7,1:7])/diag(Marima1$data.cov[1:7,1:7])),2)
round(diag(Marima1$resid.cov/Marima1$resid.cov)[1:7], 2)

###################### Question 5: predictions #########################


pred.data <- cbind(data.train, NA, NA, NA, NA)
pred <- arma.forecast(pred.data, nstart=90, nstep=4, marima=Marima1,dif.poly=d$dif.poly)

#png("myplot.png", width=5, height=5, units="in", res=300)
par(mfrow = c(2,2))
plot(trainData$zip2000,ylab="zip2000",xlab = "lag")
lines(pred$forecasts[1,], col="blue")
plot(trainData$zip2800,ylab="zip2800",xlab = "lag")
lines(pred$forecasts[2,], col="blue")
plot(trainData$zip7400,ylab="zip7400",xlab = "lag")
lines(pred$forecasts[3,], col="blue")
plot(trainData$zip8900,ylab="zip8900",xlab = "lag")
lines(pred$forecasts[4,], col="blue")
#dev.off()

par(mfrow=c(2,2))
#zip2000
plot(trainData$zip2000,xlim = range(1:96))
lines(pred$forecasts[1,1:90], col = "blue")
lines(cbind(91,92,93,94),pred$forecasts[1,91:94], col = "red")
lines(cbind(91,92,93,94),pred$forecasts[1,91:94], col = "red")
lines(cbind(91,92,93,94),
      pred$forecasts[1,91:94]+qnorm(0.975)*sqrt(pred$pred.var[1,1,])
      , col = "red")
lines(cbind(91,92,93,94),
      pred$forecasts[1,91:94]-qnorm(0.975)*sqrt(pred$pred.var[1,1,])
      , col = "red")
lines(cbind(91,92,93,94),testData$zip2000, col = "green")

#zip2800
plot(trainData$zip2800, xlim = range(1:96))
lines(pred$forecasts[2,1:90], col = "blue")
lines(cbind(91,92,93,94),pred$forecasts[2,91:94], col = "red")
lines(cbind(91,92,93,94),pred$forecasts[2,91:94], col = "red")
lines(cbind(91,92,93,94),
      pred$forecasts[2,91:94]+qnorm(0.975)*sqrt(pred$pred.var[2,2,])
      , col = "red")
lines(cbind(91,92,93,94),
      pred$forecasts[2,91:94]-qnorm(0.975)*sqrt(pred$pred.var[2,2,])
      , col = "red")

lines(cbind(91,92,93,94),testData$zip2800, col = "green")


#zip7400
plot(trainData$zip7400,xlim = range(1:96))
lines(pred$forecasts[3,1:90], col = "blue")
lines(cbind(91,92,93,94),pred$forecasts[3,91:94], col = "red")
lines(cbind(91,92,93,94),
      pred$forecasts[3,91:94]+qnorm(0.975)*sqrt(pred$pred.var[3,3,])
      , col = "red" )
lines(cbind(91,92,93,94),
      pred$forecasts[3,91:94]-qnorm(0.975)*sqrt(pred$pred.var[3,3,])
      , col = "red" )
lines(cbind(91,92,93,94),testData$zip7400, col = "green")

#zip8900
plot(trainData$zip8900,xlim = range(1:96))
lines(pred$forecasts[4,1:90], col = "blue")
lines(cbind(91,92,93,94),pred$forecasts[4,91:94], col = "red")
lines(cbind(91,92,93,94),
      pred$forecasts[4,91:94]+qnorm(0.975)*sqrt(pred$pred.var[4,4,])
      , col = "red" )
lines(cbind(91,92,93,94),
      pred$forecasts[4,91:94]-qnorm(0.975)*sqrt(pred$pred.var[4,4,])
      , col = "red" )
lines(cbind(91,92,93,94),testData$zip8900, col = "green")

