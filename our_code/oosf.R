#######################################
# computes 1-step ahead forecast
#######################################
library(dyn)

# y = dependent variable (zoo format)
# x = predictor variables (zoo format)
# k = start predicting at observation k

# uses lag 1
OutOfSampleForecast01 <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F)  stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y,-1),x)
  colnames(d) <- c("y","lagy",colnames(x))
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~lagy,data=d[1:t,])
    reg1 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    y.pred1[t1] <- predict(reg1,newdata=d[t1:t1,])
  }
  z <- cbind(y.actual,y.pred0,y.pred1)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}


# uses lag 1 with moving window.
OutOfSampleForecast01_mw <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F)  stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y,-1),lag(y,-12),x)
  colnames(d) <- c("y","lagy.1","lagy.12",colnames(x))
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in (k+12):(n-1)) {
    reg0 <- lm(y~lagy.1+lagy.12,data=d[(t-k):t,])
    reg1 <- lm(y~., data=d[(t-k):t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    y.pred1[t1] <- predict(reg1,newdata=d[t1:t1,])
  }
  z <- cbind(y.actual,y.pred0,y.pred1)[(k+12+1):n,]
  z <- zoo(z,index(y)[(k+12+1):n])
  return(z)}



#Do not use lag
OutOfSampleForecast00 <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F)  stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,x)
  colnames(d) <- c("y",colnames(x))
  y.actual <- y.pred0  <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    
  }
  z <- cbind(y.actual,y.pred0)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}

#use prediction correction

OutOfSampleForecast00_correction <- function(y,x,k,m) {
  if (is.zoo(x)==F | is.zoo(y)==F)  stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,x)
  colnames(d) <- c("y",colnames(x))
  y.actual <- y.pred0 <-y.pred_correction<- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,]) 
    
    
    if (t1>k+m){
      s=0
      for(r in 1:m){
        s=s+y.actual[t1-r]-y.pred0[t1-r]
      }
      y.pred_correction[t1] = y.pred0[t1] + s/m
    }
  }
  z <- cbind(y.actual,y.pred0,y.pred_correction)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}


# uses lag 1 and lag 12
OutOfSampleForecast12 <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F) stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y,-1),lag(y,-12),x)
  colnames(d) <- c("y","lagy.1","lagy.12",colnames(x))
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~lagy.1+lagy.12,data=d[1:t,])
    reg1 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    y.pred1[t1] <- predict(reg1,newdata=d[t1:t1,])
  }
  z <- cbind(y.actual,y.pred0,y.pred1)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}

#lag1 and lag2

OutOfSampleForecast1_2 <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F) stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y,-1),lag(y,-2),x)
  colnames(d) <- c("y","lagy.1","lagy.2",colnames(x))
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~lagy.1+lagy.2,data=d[1:t,])
    reg1 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    y.pred1[t1] <- predict(reg1,newdata=d[t1:t1,])
  }
  z <- cbind(y.actual,y.pred0,y.pred1)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}

# maeDates: computes mean absolute forecast error
# x= output of outOfSampleForecast01 or outOfSampleForecast12
# t0= index of start date
# t1= index of end date
# logged = TRUE if data is in logs, FALSE otherwise

MaeReport <- function(x,t0,t1,logged=TRUE) {
  if (is.zoo(x)==F)  stop("input must be a zoo object")
  if (missing(t0)) t0 <- start(x)
  if (missing(t1)) t1 <- end(x)
  dts <- window(x,start=t0,end=t1)
  plot(dts,plot.type="single",col=1:3)
  if (logged) {
    mae0 <- mean(abs(dts[,1]-dts[,2]))
    mae1 <- mean(abs(dts[,1]-dts[,3]))
  } else {
    mae0 <- mean(abs(dts[,1]-dts[,2])/dts[,1])
    mae1 <- mean(abs(dts[,1]-dts[,3])/dts[,1])
  }
  rpt <-   c(mae0,mae1,1-mae1/mae0)
  names(rpt) <- c("mae.base","mae.trends","mae.delta")
  return(rpt)
}
