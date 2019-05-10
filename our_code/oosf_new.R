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

# uses lag 1 and lag 12
# rolling window
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

#fixed moving window
OutOfSampleForecast12_fixed <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F) stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y,-1),lag(y,-12),x)
  colnames(d) <- c("y","lagy.1","lagy.12",colnames(x))
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~lagy.1+lagy.12,data=d[(t-k):t,])
    reg1 <- lm(y~., data=d[(t-k):t,])
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
  if (missing(t0)) t0 <- start(x) #picks start date if not given 
  if (missing(t1)) t1 <- end(x) #picks end date
  dts <- window(x,start=t0,end=t1) #makes an obj w/ col's: date, y-actual, y-pred0, y-pred1 in range t0-t1
  plot(dts,plot.type="single",col=1:3)
  legend("bottomright",legend=c("actual", "base model", "model with Trend data"), 
         lty=1:1,col=1:3, cex=0.6)
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
