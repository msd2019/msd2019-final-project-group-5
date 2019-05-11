
> library(dyn)
> dat <- read.csv("merged.csv")
> dat <- zoo(dat[,-1],as.Date(dat[,1]))
> y <- log(dat$sales)
> x <- dat[,c(2,3)]
> 
> reg0 <- dyn$lm(y~lag(y,-1)+lag(y,-12))
> summary(reg0)

Call:
lm(formula = dyn(y ~ lag(y, -1) + lag(y, -12)))

Residuals:
      Min        1Q    Median        3Q       Max 
-0.209554 -0.034684  0.002482  0.040477  0.220976 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.67266    0.76355   0.881 0.381117    
lag(y, -1)   0.64345    0.07332   8.776 3.59e-13 ***
lag(y, -12)  0.29565    0.07282   4.060 0.000118 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Residual standard error: 0.07985 on 76 degrees of freedom
  (12 observations deleted due to missingness)
Multiple R-squared: 0.7185,	Adjusted R-squared: 0.7111 
F-statistic:    97 on 2 and 76 DF,  p-value: < 2.2e-16 

> # trends model
> reg1 <- dyn$lm(y~lag(y,-1)+lag(y,-12)+suvs+insurance,data=dat)
> summary(reg1)

Call:
lm(formula = dyn(y ~ lag(y, -1) + lag(y, -12) + suvs + insurance), 
    data = dat)

Residuals:
      Min        1Q    Median        3Q       Max 
-0.161327 -0.043774  0.002998  0.036651  0.159219 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.45798    0.78438  -0.584 0.561081    
lag(y, -1)   0.61947    0.06318   9.805 5.09e-15 ***
lag(y, -12)  0.42865    0.06535   6.559 6.45e-09 ***
suvs         1.05721    0.16686   6.336 1.66e-08 ***
insurance   -0.52966    0.15206  -3.483 0.000835 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Residual standard error: 0.06509 on 74 degrees of freedom
  (12 observations deleted due to missingness)
Multiple R-squared: 0.8179,	Adjusted R-squared: 0.808 
F-statistic: 83.08 on 4 and 74 DF,  p-value: < 2.2e-16 

> source("../oosf.R")
> z <- OutOfSampleForecast12(y,x,17)
> # overall fit
> MaeReport(z)
  mae.base mae.trends  mae.delta 
0.06343984 0.05667658 0.10660890 
> 
> # recession fit
> MaeReport(z,"2007-12-01","2009-06-30")
  mae.base mae.trends  mae.delta 
0.08869325 0.06965812 0.21461753 
> 
> pdf("autos.pdf",width=8,height=4.5)
> plot(z,plot.type="sin",col=c(1,1,"gray40"),lty=c(1,2,1),main="Motor Vehicles and Parts",ylab="log(mvp)",lwd=c(1.5,1,1))
> legend("topright",c("actual","base","trends"),lty=c(1,2,1),col=c(1,1,"gray40"),lwd=c(1.5,1,1))
> legend("bottomleft",c("MAE improvement","Overall = 10.5%","During recession = 21.5%"))
> graphics.off()
> 