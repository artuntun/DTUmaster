rm(list=ls())

#Charge data
setwd("/home/arturo/Documents/Time Series Analysis/Assignment5")
myData = read.table("Satelliteorbit.csv", sep =",", header = FALSE)
Y = data.matrix(myData, rownames.force = NA)
Y = t(Y)

#Building system
#   x_kp1 = A*x_k + noiseState
#   y_k = Cx_k  + noiseMeasurment

A <- matrix(c(1,0,0,0,1,0,0,1,1),nrow = 3)
C <- matrix(c(1,0,0,1,0,0),ncol = 3)
Sigma1 <- matrix(c(500^2,0,0,0,0.005^2,0,0,0,0.005^2),nrow = 3)
Sigma2 <- matrix(c(2000^2,0,0,0.03^2), nrow = 2)


#Kalaman filtering
############## Kalaman filter initalization
X_estimated <- matrix(0,nrow = 3, ncol = 60)
stored_K <- matrix(0,nrow = 3, ncol = 60)
stored_klist <- list()
stored_SigmaXX <- list()

Xhat <- matrix(c(38000,0,0.0269356),nrow=3)
SigmaXXhat<- matrix(c(1000,0,0,0,0,0,0,0,0),nrow = 3) 
SigmaYYhat <- matrix(c(1,0,0,1),nrow = 2)
SigmaXYhat <- SigmaXXhat%*%t(C)

for(n in 1:50){
  #estimation
  #K = SigmaXYhat%*%solve(SigmaYYhat)
  K = SigmaXXhat%*%t(C)%*%solve(SigmaYYhat)
  Xestim = Xhat + K%*%(Y[,n]-C%*%Xhat)
  SigmaXX <- SigmaXXhat - K%*%SigmaYYhat%*%t(K)
  
  #Storing data 
  X_estimated[,n] <-Xestim
  stored_SigmaXX[[n]] <- SigmaXX
  
  #prediction
  Xhat <- A%*%Xestim
  SigmaXXhat <- A%*%SigmaXX%*%t(A) + Sigma1
  SigmaYYhat <- C%*%SigmaXXhat%*%t(C) + Sigma2
  SigmaXYhat <- SigmaXXhat%*%t(C)
}

#Predictions
num_pred = 6  #ahead steps predictions
X_predicted <- matrix(0,nrow = 3, ncol = num_pred+1)
SigmaXX_pred <- list()
Xhat = matrix(X_estimated[,50], ncol = 1)
SigmaXXhat <- stored_SigmaXX[[50]]
X_predicted[,1] <- Xhat
SigmaXX_pred[[1]] <- SigmaXXhat
for(n in 2:(num_pred+1)){
  Xhat <- A%*%Xhat
  SigmaXXhat <- A%*%SigmaXXhat%*%t(A) + Sigma1 
  X_predicted[,n] <-Xhat
  SigmaXX_pred[[n]] <- SigmaXXhat
}

############################## PLOTTING #####################################

###########  X1-radius: measurment, estimation and prediction
conf_interp = matrix(0, ncol = length(stored_SigmaXX))
conf_interm = matrix(0, ncol = length(stored_SigmaXX))
for(n in 1:length(stored_SigmaXX)){
  std = sqrt(abs(stored_SigmaXX[[n]][1,1]))
  conf_interp[n] = X_estimated[1,n] + 1.96*std
  conf_interm[n] = X_estimated[1,n] - 1.96*std
}
plot(Y[1,], xlim = cbind(0,56))
lines(X_estimated[1,1:50], col = "red")
lines(conf_interp[1:50], col = "blue",lty=3, lwd=1)
lines(conf_interm[1:50], col = "blue",lty=3, lwd=1)
lines(seq(50,56),X_predicted[1,], col = "green")
conf_interp = matrix(0, ncol = length(SigmaXX_pred))
conf_interm = matrix(0, ncol = length(SigmaXX_pred))
for(n in 1:length(SigmaXX_pred)){
  std = sqrt(SigmaXX_pred[[n]][1,1])
  conf_interp[n] = X_predicted[1,n] + 1.96*sqrt(SigmaXX_pred[[n]][1,1])
  conf_interm[n] = X_predicted[1,n] - 1.96*sqrt(SigmaXX_pred[[n]][1,1])
}
lines(seq(50,56),conf_interp[1:7], col = "orange")
lines(seq(50,56),conf_interm[1:7], col = "orange")

######## X2-angle: measur,estimation and prediction
conf_interp = matrix(0, ncol = length(stored_SigmaXX))
conf_interm = matrix(0, ncol = length(stored_SigmaXX))
for(n in 1:length(stored_SigmaXX)){
  std = sqrt(stored_SigmaXX[[n]][2,2])
  conf_interp[n] = X_estimated[2,n] + 1.96*sqrt(stored_SigmaXX[[n]][2,2])
  conf_interm[n] = X_estimated[2,n] - 1.96*sqrt(stored_SigmaXX[[n]][2,2])
}
plot(Y[2,], ylim = cbind(0,1.75), xlim = cbind(0,56))
lines(X_estimated[2,1:50], col = "green")
lines(conf_interp[1:50], col = "blue",lty=3, lwd=1)
lines(conf_interm[1:50], col = "blue",lty=3, lwd=1)
lines(seq(50,56),X_predicted[2,], col = "red")
conf_interp = matrix(0, ncol = length(SigmaXX_pred))
conf_interm = matrix(0, ncol = length(SigmaXX_pred))
for(n in 1:length(SigmaXX_pred)){
  std = sqrt(SigmaXX_pred[[n]][2,2])
  conf_interp[n] = X_predicted[2,n] + 1.96*sqrt(SigmaXX_pred[[n]][2,2])
  conf_interm[n] = X_predicted[2,n] - 1.96*sqrt(SigmaXX_pred[[n]][2,2])
}
lines(seq(50,56),conf_interp[1:7], col = "orange")
lines(seq(50,56),conf_interm[1:7], col = "orange")

############## X3-velocity: estimated and prediction
conf_interp = matrix(0, ncol = length(stored_SigmaXX))
conf_interm = matrix(0, ncol = length(stored_SigmaXX))
for(n in 1:length(stored_SigmaXX)){
  conf_interp[n] = X_estimated[3,n] + 1.96*sqrt(stored_SigmaXX[[n]][3,3])
  conf_interm[n] = X_estimated[3,n] - 1.96*sqrt(stored_SigmaXX[[n]][3,3])
}
plot(X_estimated[3,1:50], ylim = cbind(-0.01,max(conf_interp)), xlim = cbind(0,56))
lines(conf_interp[1:50], col = "blue",lty=3, lwd=1)
lines(conf_interm[1:50], col = "blue",lty=3, lwd=1)
lines(seq(50,56),X_predicted[3,], col = "green")
conf_interp = matrix(0, ncol = length(SigmaXX_pred))
conf_interm = matrix(0, ncol = length(SigmaXX_pred))
for(n in 1:length(SigmaXX_pred)){
  std = sqrt(SigmaXX_pred[[n]][3,3])
  conf_interp[n] = X_predicted[3,n] + 1.96*sqrt(SigmaXX_pred[[n]][3,3])
  conf_interm[n] = X_predicted[3,n] - 1.96*sqrt(SigmaXX_pred[[n]][3,3])
}
lines(seq(50,56),conf_interp[1:7], col = "orange")
lines(seq(50,56),conf_interm[1:7], col = "orange")

############# Plotting trajectory: measu, estimation and prediction
ang_est <- X_estimated[2,1:50]
x_est <- X_estimated[1,1:50]*cos(ang_est)
y_est <- X_estimated[1,1:50]*sin(ang_est)
ang <- Y[2,1:50]
x <- Y[1,1:50]*cos(ang)
y <- Y[1,1:50]*sin(ang)
ang <- X_predicted[2,]
x_pred <- X_predicted[1,]*cos(ang)
y_pred <- X_predicted[1,]*sin(ang)
plot(x,y, xlim = cbind(-3500,30000))
lines(x_est,y_est, col = "green")
points(x_pred, y_pred, pch = 20, col="red")
png("predicts.pdf", width=5, height=8, units="in", res=300)
par(mfrow=c(3,2))
for(n in 2:7){
  ang <- X_predicted[2,n]
  x_pred <- X_predicted[1,n]*cos(ang)
  y_pred <- X_predicted[1,n]*sin(ang)
  std = sqrt(SigmaXX_pred[[n]][1,1])
  r <- seq(X_predicted[1,n]-1.96*std,X_predicted[1,n]+1.96*std,0.005)
  x_intm <- r*cos(ang)
  y_intm <- r*sin(ang)
  std = sqrt(SigmaXX_pred[[n]][2,2])
  ang1 <- seq(ang-1.96*std,ang+1.96*std,0.005)
  x_intmang <- (X_predicted[1,n])*cos(ang1)
  y_intmang <- (X_predicted[1,n])*sin(ang1)
  #plotting
  plot(x,y, xlim = cbind(-7500,20000), ylim = cbind(20000,43000))
  lines(x_est,y_est, col = "green")
  points(x_pred[1],y_pred[1], pch = 20, col="red")
  lines(x_intm,y_intm, pch = 20, col = "blue",lty=3, lwd=1)
  lines(x_intmang,y_intmang, pch = 20, col = "blue",lty=3, lwd=1)
}
dev.off()