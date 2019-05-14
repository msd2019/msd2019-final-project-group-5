##############
# helper functions to run in-sample and out-of-sample forecasting, 
# and produce the resulting mae report and graphs all in one
##############
source("oosf_new.R")


# producing the result based on the paper's base and trends model 
# data input should have date format mm/dd/y
# data columns should be: date, sales, suvs, insurance
# print = 0 or 1: whether or not to print the lm summary
# graph = 0 or 1: whether or not to draw the graph
# plot_title = title of the plot we are drawing
# dateBegin: the beginning date of a time period we want to look at
# dateEnd: the end date of a time period we want to look at S
getModelandEvaluation <- function(data, print=0, graph = 0, 
                                  plot_title = "log(sales) over time",
                                  dateBegin=NULL, dateEnd=NULL) {
  zooObj <- zoo(data[,-1], as.Date(data[,1]))
  y <- log(zooObj$sales)
  x <- zooObj[, c("suvs", "insurance")]
  
  reg0 <- dyn$lm(y~lag(y,-1) + lag(y, -12))
  reg1 <- dyn$lm(y~lag(y,-1)+lag(y,-12)+suvs+insurance,data=data)
  
  if(print == 1){
    print("Summary of base model")
    print(summary(reg0))
    print("Summary of trend model")
    print(summary(reg1))
  }
  
  z <- OutOfSampleForecast12(y,x,17)
  if(!is.null(dateBegin) && !is.null(dateEnd)){
    print(MaeReport(z,dateBegin, dateEnd, plot_title = plot_title))
  }
  else{
    print(MaeReport(z, plot_title = plot_title))
    if(graph == 1) {
      plot(z,plot.type="sin",col=c(1,1,"gray40"),lty=c(1,2,1),
           main=plot_title ,ylab="log(mvp)",lwd=c(1.5,1,1))
      legend("topright",c("actual","base","trends"),
             lty=c(1,2,1),col=c(1,1,"gray40"),lwd=c(1.5,1,1))
    }
  }

}

# producing the results based on moving window forcasting method 
# and the same base and trends model as paper's
getEvaluation_0112mv <- function(data, dateBegin=NULL, dateEnd=NULL,
                                 plot_title = "log(sales) over time"){
  zooObj <- zoo(data[,-1], as.Date(data[,1]))
  y <- log(zooObj$sales)
  x <- zooObj[, c("suvs", "insurance")]
  z <- OutOfSampleForecast0112_mw(y,x,17)
  if(!is.null(dateBegin) && !is.null(dateEnd)){
    print(MaeReport(z,dateBegin, dateEnd, plot_title = plot_title))
  }
  else{
    print(MaeReport(z, plot_title = plot_title))
  }
  
}

# producing the result using paper's out of sample forecasting method 
# but new model $$y = \beta_0 + \beta_1y_{t-1} + \beta_2y_{t-2} + suvs + insurance$$
getModelandEvaluation1_2 <- function(data, print=0, 
                                     dateBegin=NULL, dateEnd=NULL,  
                                     plot_title = "log(sales) over time") {
  zooObj <- zoo(data[,-1], as.Date(data[,1]))
  y <- log(zooObj$sales)
  x <- zooObj[, c("suvs", "insurance")]
  
  reg0 <- dyn$lm(y~lag(y,-1) + lag(y, -2))
  reg1 <- dyn$lm(y~lag(y,-1)+lag(y,-2)+suvs+insurance,data=data)
  
  if(print == 1){
    print(summary(reg0))
    print(summary(reg1))
  }
  z <- OutOfSampleForecast1_2(y,x,17)
  if(!is.null(dateBegin) && !is.null(dateEnd)){
    print(MaeReport(z,dateBegin, dateEnd, plot_title = plot_title))
  }
  else{
    print(MaeReport(z, plot_title = plot_title))
  }
  
}
