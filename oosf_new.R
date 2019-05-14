#######################################
# helper functions to conduct different kinds of out of sample forecast
#######################################
library(dyn)

# y = dependent variable (zoo format)
# x = predictor variables (zoo format)
# k = start predicting at observation k

# original paper's out of sample forecast
# uses lag 1 and lag 12, rolling window
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


# uses lag 1 and lag 12 with moving window.
OutOfSampleForecast0112_mw <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F)  stop("x and y must be zoo objects")
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
# the legend assumes 3 plots: y_actual, y_pred0(base model), and y_pred1(trend model) 
# plot_title the title of the plot we want to graph 
MaeReport <- function(x,t0,t1,logged=TRUE, plot_title) {
  if (is.zoo(x)==F)  stop("input must be a zoo object")
  if (missing(t0)) t0 <- start(x)
  if (missing(t1)) t1 <- end(x)
  dts <- window(x,start=t0,end=t1)
  #plot(x,plot.type="sin",col=c(1,1,"gray40"),lty=c(1,2,1),
       #main=plot_title ,ylab="log(mvp)",lwd=c(1.5,1,1))
  #legend("topright",c("actual","base","trends"),
         #lty=c(1,2,1),col=c(1,1,"gray40"),lwd=c(1.5,1,1))
  #legend("bottomleft",c("MAE improvement","Overall = 10.5%","During recession = 21.5%"))
  #plot(dts,plot.type="single",col=1:3, ann=FALSE)
  #legend("bottomright", legend=c("Actual","Base Model","Trend Model"), lty=1:1, col=1:3, cex=0.6)
  #title(main=plot_title,xlab="year", ylab="log(sales)")
  if (logged) {
    mae0 <- mean(abs(dts[,1]-dts[,2]))
    mae1 <- mean(abs(dts[,1]-dts[,3]))
  } else {
    mae0 <- mean(abs(dts[,1]-dts[,2])/dts[,1])
    mae1 <- mean(abs(dts[,1]-dts[,3])/dts[,1])
  }
  rpt <-   c(mae0,mae1,1-mae1/mae0)
  print(paste(plot_title, "MAE"))
  names(rpt) <- c("mae.base","mae.trends","mae.delta")
  return(rpt)
}


#############################################
# Below are some out of sample forecasting methods that we tested yet did not include

#No lag, only trend data
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



# some exploration of new model
OutOfSampleForecast12_newModel <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F) stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y,-1), I(lag(y, -1)^2), lag(y,-12),x)
  colnames(d) <- c("y","lagy.1","lagy.1sq","lagy.12","x")
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~lagy.1+ lagy.1sq+lagy.12,data=d[1:t,])
    reg1 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    y.pred1[t1] <- predict(reg1,newdata=d[t1:t1,])
  }
  z <- cbind(y.actual,y.pred0,y.pred1)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}


# uses lag 1 and 3
OutOfSampleForecast1_3 <- function(y,x,k) {
  if (is.zoo(x)==F | is.zoo(y)==F)  stop("x and y must be zoo objects")
  n <- length(y)
  d <- cbind(y,lag(y, -1), lag(y, -3), x)
  colnames(d) <- c("y", "lagy1", "lagy3", colnames(x))
  y.actual <- y.pred0 <- y.pred1 <- rep(NA,n)
  for (t in k:(n-1)) {
    reg0 <- lm(y~lagy1 + lagy3, data=d[1:t,])
    reg1 <- lm(y~., data=d[1:t,])
    t1 <- t+1
    y.actual[t1] <-  d[t1:t1,]$y
    y.pred0[t1] <- predict(reg0,newdata=d[t1:t1,])
    y.pred1[t1] <- predict(reg1,newdata=d[t1:t1,])
  }
  z <- cbind(y.actual,y.pred0,y.pred1)[(k+1):n,]
  z <- zoo(z,index(y)[(k+1):n])
  return(z)}

# uses lag 1 only
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