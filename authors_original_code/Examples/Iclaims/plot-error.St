> source("../oosf.R")
> library(dyn)
> # read data
> dat <- read.csv("merged.csv")
> d <- zoo(dat[,-1],as.Date(dat[,1]))
> y <- log(d$claims.sa)
> # out of sample forecasts
> x <- d[,c("Jobs","Welfare...Unemployment")]
> z <- OutOfSampleForecast01(y,x,200)
> d[200,1]
2007-11-03 
    327000 
> z.ts <- ts(z,start=c(2007,44),freq=52)
> res0 <- z.ts[,1]-z.ts[,2]
> res1 <- z.ts[,1]-z.ts[,3]
> # chart
>  
> layout(matrix(c(1,2)),heights=c(2,1.5))
> ts.plot(z.ts[,1],z.ts[,2],col=1:2,lty=1:2,ylab="log(iclaims)",main="Initial claims, actual and predicted") 
> ts.plot(abs(res0)-abs(res1),type="h",ylab="diff error",main="Base - trends absolute forecast error")
> q()
Save workspace image? [y/n/c]: n

Process R finished at Sun Nov 27 13:55:35 2011
