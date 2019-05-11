> source("../oosf.R")
> library(dyn)
> 
> # read data
> dat <- read.csv("merged.csv")
> d <- zoo(dat[,-1],as.Date(dat[,1]))
> y <- log(d$claims.sa)
> # out of sample forecasts
> x <- d[,c("Jobs","Welfare...Unemployment")]
> z <- OutOfSampleForecast01(y,x,200)
> 
> d[200,1]
2007-11-03 
> # week 44
> z.ts <- ts(z,start=c(2007,44),freq=52)
> res0 <- z.ts[,1]-z.ts[,2]
> res1 <- z.ts[,1]-z.ts[,3]
> par(mfrow=c(2,1))
> ts.plot(z.ts[,1],z.ts[,2],col=1:2,lty=1:2) 
> ts.plot(abs(res1)-abs(res0),type="h")
> abline(c(0,0))
> 
> 