> source("../oosf.R")
> library(dyn)
> 
> # read data
> dat <- read.csv("merged.csv")
> d <- zoo(dat[,-1],as.Date(dat[,1]))
> 
> y <- log(d$claims.sa)
> 
> # baseline AR-1 regression
> reg0 <- dyn$lm(y~lag(y,-1),data=d)
> summary(reg0)

Call:
lm(formula = dyn(y ~ lag(y, -1)), data = d)

Residuals:
      Min        1Q    Median        3Q       Max 
-0.165016 -0.023965 -0.001181  0.025482  0.254305 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.25488    0.12951   1.968   0.0498 *  
lag(y, -1)   0.98022    0.01007  97.368   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Residual standard error: 0.04362 on 388 degrees of freedom
  (1 observation deleted due to missingness)
Multiple R-squared: 0.9607,	Adjusted R-squared: 0.9606 
F-statistic:  9480 on 1 and 388 DF,  p-value: < 2.2e-16 

> # trends
> reg1 <- dyn$lm(y~lag(y,-1)+Jobs+Welfare...Unemployment,data=d)
> summary(reg1)

Call:
lm(formula = dyn(y ~ lag(y, -1) + Jobs + Welfare...Unemployment), 
    data = d)

Residuals:
      Min        1Q    Median        3Q       Max 
-0.146240 -0.027344 -0.001357  0.025533  0.254608 

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
(Intercept)            1.0563440  0.2686360   3.932 9.98e-05 ***
lag(y, -1)             0.9183560  0.0208778  43.987  < 2e-16 ***
Jobs                   0.0007069  0.0003847   1.838   0.0669 .  
Welfare...Unemployment 0.0003752  0.0001838   2.042   0.0418 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Residual standard error: 0.04297 on 386 degrees of freedom
  (1 observation deleted due to missingness)
Multiple R-squared: 0.962,	Adjusted R-squared: 0.9618 
F-statistic:  3261 on 3 and 386 DF,  p-value: < 2.2e-16 

> # out of sample forecasts
> x <- d[,c("Jobs","Welfare...Unemployment")]
> z <- OutOfSampleForecast01(y,x,200)
> 
> MaeReport(z)
   mae.base  mae.trends   mae.delta 
 0.03475288  0.03682028 -0.05948877 
> 
> #recession
> MaeReport(z,as.Date("2007-12-01"),as.Date("2009-06-30"))
  mae.base mae.trends  mae.delta 
0.03982448 0.03442258 0.13564252 
> 
> # examine turning points
> d1 <- "2009-03-01"
> d2 <- "2009-05-01"
> d3 <- "2009-12-01"
> d4 <- "2010-02-01"
> d5 <- "2010-07-15"
> d6 <- "2010-10-01"
> d7 <- "2011-01-01"
> d8 <- "2011-05-01"
> 
> MaeReport(z,as.Date(d1),as.Date(d2))
  mae.base mae.trends  mae.delta 
0.03069324 0.02398503 0.21855652 
> 
> MaeReport(z,as.Date(d3),as.Date(d4))
  mae.base mae.trends  mae.delta 
0.03568256 0.03127164 0.12361544 
> 
> MaeReport(z,as.Date(d5),as.Date(d6))
  mae.base mae.trends  mae.delta 
0.02527886 0.02446377 0.03224380 
> 
> MaeReport(z,as.Date(d7),as.Date(d8))
  mae.base mae.trends  mae.delta 
0.05135103 0.05101357 0.00657172 
> 
> # plot
> plot(window(y,start=as.Date("2008-03-01")),xlab="time",ylab="log(iclaims)",main="Initial claims SA")
> u <- par("usr")
> rect(as.Date(d1), u[3], as.Date(d2), u[4], border=0,col="grey")
> rect(as.Date(d3), u[3], as.Date(d4), u[4], border=0,col="grey")
> rect(as.Date(d5), u[3], as.Date(d6), u[4], border=0,col="grey")
> rect(as.Date(d7), u[3], as.Date(d8), u[4], border=0,col="grey")
> lines(y)
> 
> 