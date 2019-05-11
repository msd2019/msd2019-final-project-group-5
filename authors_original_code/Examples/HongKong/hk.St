
> library(dyn)
> setwd("~/Working/Examples/HongKong/")
> trends <- read.csv("hk-trends-2-weeks.csv")
> trends <- zoo(trends[,-1],as.Date(trends[,1]))
> arrive <- read.csv("hk-arrival.csv")
> arrive <- zoo(arrive[,-1],as.Date(arrive[,1]))
> arrive <- window(arrive,start=as.Date("2004-01-01"),end=as.Date("2011-02-01"))
> 
> ##############################
> nms <- names(arrive)
> par(mfrow=c(3,3))
> for (t in 1:9) {
+ y <- arrive[,t]
+ x <- trends[,t]
+ reg <- dyn$lm(y~lag(y,-1)+lag(y,-12)+x)
+ y.pred <- predict(reg)
+ y.act <- window(y,start=as.Date("2005-01-01"))
+ plot(cbind(y.act,y.pred),col=1:2,lty=1:2,plot.type="single",ylab="visitors",xlab="date",main=nms[t])
+ print(c(nms[t],summary(reg)$r.squared))}
[1] "US"                "0.623219246734627"
[1] "CA"                "0.702726273572627"
[1] "GB"                "0.743416076587638"
[1] "DE"                "0.821339906291026"
[1] "FR"               "0.69518180752415"
[1] "IT"                "0.679807015929593"
[1] "AU"                "0.759282739649871"
[1] "JP"                "0.307810143833464"
[1] "IN"               "0.84204362453386"
> 
> r2 <- rep(0,9)
> 
>  for (t in 1:9) {
y <- arrive[,t]
x <- trends[,t]
reg <- dyn$lm(y~lag(y,-1)+lag(y,-12)+x)
r2[t] <- summary(reg)$r.squared
}
 for (t in 1:9) {
+ y <- arrive[,t]
+ x <- trends[,t]
+ reg <- dyn$lm(y~lag(y,-1)+lag(y,-12)+x)
+ r2[t] <- summary(reg)$r.squared
+ }
> 
> mean(r2)
[1] 0.6860919
> mean(r2[-8])
[1] 0.7333771
> 
> ## for png plots
> # png("hk.png",height=400, width=600)
> # par(mfrow=c(3,3),mar=rep(2,4))
> 