> infile="trucks-and-suvs.csv"
> outfile="trucks-and-suvs-first-week.csv"
> dat <- read.csv(infile)
> dat <- dat[5:400,]
> dat[,1] <- substr(dat[,1],1,10)
> names(dat) <- c("Index","y")

> library(zoo)
> x <- zoo(dat[,-1],as.Date(dat[,1]),freq=52)
> first.of.month <- function(x) as.Date(sub("..$", "01", format(x)))
> first.element <- function(x) x[1]
> z <- aggregate(x,first.of.month(index(x)),first.element)
> write.zoo(z,file=outfile,sep=",")
> 