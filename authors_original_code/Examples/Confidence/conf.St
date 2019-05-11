> library(dyn)
> dat <- read.csv("merged.csv")
> d <- zoo(dat[,-1],as.Date(dat[,1]))
> y <- log(d$rmindex)
> 
> # baseline regression
> reg0 <- dyn$lm(y~lag(y,-1))
> summary(reg0)

Call:
lm(formula = dyn(y ~ lag(y, -1)))

Residuals:
      Min        1Q    Median        3Q       Max 
-0.128303 -0.018526  0.003309  0.034031  0.067927 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.52068    0.23141    2.25   0.0270 *  
lag(y, -1)   0.89052    0.04859   18.33   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Residual standard error: 0.04423 on 85 degrees of freedom
  (1 observation deleted due to missingness)
Multiple R-squared: 0.798,	Adjusted R-squared: 0.7957 
F-statistic: 335.9 on 1 and 85 DF,  p-value: < 2.2e-16 

> # trends regression
> reg1 <- dyn$lm(y~lag(y,-1)+ Crime...Justice + Trucks...SUVs + Hybrid...Alternative.Vehicles,data=dat)
> summary(reg1)

Call:
lm(formula = dyn(y ~ lag(y, -1) + Crime...Justice + Trucks...SUVs + 
    Hybrid...Alternative.Vehicles), data = dat)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.11233 -0.02170  0.00747  0.02710  0.07288 

Coefficients:
                                Estimate Std. Error t value Pr(>|t|)    
(Intercept)                    1.5172617  0.2795356   5.428 5.67e-07 ***
lag(y, -1)                     0.6839436  0.0584158  11.708  < 2e-16 ***
Crime...Justice               -0.0009664  0.0002404  -4.020 0.000129 ***
Trucks...SUVs                  0.0010600  0.0005346   1.983 0.050735 .  
Hybrid...Alternative.Vehicles -0.0007869  0.0001482  -5.308 9.26e-07 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Residual standard error: 0.03772 on 82 degrees of freedom
  (1 observation deleted due to missingness)
Multiple R-squared: 0.8583,	Adjusted R-squared: 0.8514 
F-statistic: 124.2 on 4 and 82 DF,  p-value: < 2.2e-16 

> # insample prediction
> y.pred0 <- predict(reg0)
> y.pred1 <- predict(reg1)
> 
> m0 <- mean(abs(y-y.pred0))
> m1 <- mean(abs(y-y.pred1))
> c(m0,m1,1-m1/m0)
[1] 0.03326027 0.02904668 0.12668555
> 
> # outsample prediction
> source("/home/hal/Working/Examples/oosf.R")
> x <- d[,c("Crime...Justice","Trucks...SUVs","Hybrid...Alternative.Vehicles")]
> z <- OutOfSampleForecast01(y,x,6)
> MaeReport(z)
  mae.base mae.trends  mae.delta 
0.03632425 0.03294871 0.09292812 
> 
> # spike in 2008 appears to be due to spike in hybrid vehicles
> plot(x)
> 