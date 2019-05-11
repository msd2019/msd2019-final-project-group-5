> # deseasonalize data using stl
> infile="raw-week.csv"
> outfile="deseas-week.csv"
> freq=52
> ############################################################ 
> dat <- read.csv(infile)
> dat.ts <- ts(dat,start=c(2004,1),frequency=freq)
# to hold seasonally adjusted data
> x <- dat
> ncols <- dim(dat)[2]
# fill in columns
> for (t in 2:ncols) {
+ sss <- stl(dat.ts[,t],s.window="per")
+ x[,t] <-  dat.ts[,t]-sss$time.series[,1]}
> #fill in dates
> x[,1] <- dat[,1]
> #write file 
> write.csv(x,outfile,row.names=F)