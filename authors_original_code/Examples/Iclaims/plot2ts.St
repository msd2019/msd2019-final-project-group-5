> dat <- read.csv("merged.csv")
> dat <- zoo(dat[,-1],as.Date(dat[,1]))
> 
> y1 <- dat$claims.sa
> y2 <- dat$Welfare...Unemployment
 
> plot2ts <- function(y1,y2,lab2) {
par(mar=c(6,6,2,6))
plot(y1)
par(new=TRUE)
plot(y2,ann=FALSE,yaxt="n",col="blue")
axis(4)
mtext(lab2,side=4,line=3.5)
} 

> y1.s <- rollapply(y1,7,mean)
> y2.s <- rollapply(y2,7,mean)
> plot2ts(y1.s,y2.s,lab2="y2")
> 
> 
> y2[as.Date("2010-07-17")] <- y2[as.Date("2010-07-24")] <- 47
> 
> y1.s <- rollapply(y1,7,mean)
> y2.s <- rollapply(y2,7,mean)
> plot2ts(y1.s,y2.s,lab2="y2")
> legend("topleft",legend=c("y1","y2"), lty=1:1,col=c("black","blue"))
> 