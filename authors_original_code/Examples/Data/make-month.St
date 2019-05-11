> infile="deseas-week.csv"
> outfile="deseas-month.csv"
> ##################################################################
> dat <- read.csv(infile)
> library(zoo)
> x <- zoo(dat[,-1],as.Date(dat[,1]),freq=12)
> first.of.month <- function(x) as.Date(sub("..$", "01", format(x)))
> z <- aggregate(x,first.of.month(index(x)),mean)
# could also use partial month, by using
# where mean2 <- function(x) mean(x[1:2])
> write.zoo(z,file=outfile,sep=",")
