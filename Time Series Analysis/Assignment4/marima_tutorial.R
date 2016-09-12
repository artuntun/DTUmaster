rm(list = ls())
library(marima)
data(austr)
all.data <- austr
all.data
old.data <- t(austr)[,1:83]
old.data
ar<-c(2)
ma<-c(1)
#Define the proper model
Model1 <- define.model(kvar=7, ar=ar, ma=ma,rem.var = c(1,6,7), indep = c(2:5))
Model1
Marima1 <- marima(old.data,means=1, ar.pattern = Model1$ar.pattern, 
                  ma.pattern = Model1$ma.pattern, Check=FALSE, Plot="none", penalty=0.0)
short.form(Marima1$ar.estimates, leading = FALSE)
short.form(Marima1$ma.estimates, leading = FALSE)

Model2 <- define.model(kvar=7, ar=2, ma=1, rem.var = c(1,6,7), indep = NULL)
Model2
Marima2 <- marima(old.data, means = 1, ar.pattern = Model2$ar.pattern,
                  ma.pattern = Model2$ma.pattern, Check =FALSE, Plot="log.det",
                  penalty=0)
short.form(Marima2$ar.estimates)
short.form(Marima2$ma.estimates, leading = FALSE)

#including legislation effect  ####
more.data<-t(austr)[,1:90]
ar<-c(1)
ma<-c(1)
Model3 <- define.model(kvar = 7, means=1, ar=ar, 
                       ma=ma, rem.var = c(1), reg.var = c(6,7))
Marima3 <- (more.data, means=1, ar.pattern = Model3$ar.pattern, 
            ma.pattern = Model3$ma.pattern, Check = FALSE, Plot="log.det")
