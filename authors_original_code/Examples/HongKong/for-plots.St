
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

> pdf("hk.pdf",height=4, width=6)
> par(mfrow=c(3,3),mar=rep(2,4))
> for (t in 1:9) {
y <- arrive[,t]
x <- trends[,t]
reg <- dyn$lm(y~lag(y,-1)+lag(y,-12)+x)
y.pred <- predict(reg)
y.act <- window(y,start=as.Date("2005-01-01"))
plot(cbind(y.act,y.pred),col=c(1,"gray20"),plot.type="single",ylab="visitors",xlab="date",main=nms[t],lwd=c(1,.5))
} 
> graphics.off()
