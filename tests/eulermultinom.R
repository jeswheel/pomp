library(pomp)

set.seed(2130639172L)

reulermultinom(n=5,size=100,rate=c(1,2,3),dt=0.1)
reulermultinom(n=5,size=-3,rate=c(1,2,3),dt=0.1)
reulermultinom(n=5,size=100,rate=c(1,-2,3),dt=0.1)
reulermultinom(n=5,size=100,rate=c(1,NA,3),dt=0.1)
reulermultinom(n=5,size=100.3,rate=c(1,2,3),dt=0.1)
reulermultinom(n=0,size=100,rate=c(1,2,3),dt=0.1)
reulermultinom(n=5,size=100,rate=c(1,2,3),dt=Inf)
try(reulermultinom(n=-2,size=100,rate=c(1,2,3),dt=0.1))
reulermultinom(n=1,size=100,rate=c(1,2e400,3),dt=0.1)
reulermultinom(n=1,size=100,rate=c(1,2,3),dt=c(0.1,0.2,0.3,Inf))
reulermultinom(n=1,size=c(100,200,300),rate=c(1,2,3),dt=0.2)
reulermultinom(n=1,size=0,rate=c(1,2,3),dt=0.2)
reulermultinom(n=1,size=10,rate=c(1,Inf,1),0.1)
reulermultinom(n=1,size=Inf,rate=c(1,100,1),0.1)
try(reulermultinom(n=NA,size=100,rate=c(1,2,3),dt=1))
reulermultinom(n=5,size=NA,rate=c(1,2,3),dt=1)
reulermultinom(n=5,size=100,rate=c(1,NA,3),dt=1)
reulermultinom(n=5,size=100,rate=c(1,2,3),dt=NA)
reulermultinom(n=5,size=100,rate=c(0,0,0,0),dt=1)

x <- reulermultinom(n=3,size=100,rate=c(3,2,1),dt=0.1)
try(deulermultinom(rbind(x,c(0,1,0)),size=100,rate=c(3,2,1),dt=0.1))
deulermultinom(x,size=c(100,NA),rate=c(3,2,1),dt=0.1)
deulermultinom(x,size=100,rate=c(3,2,1),dt=c(0.1,0.2,0.3,Inf))
deulermultinom(x,size=100,rate=c(3,2,1),dt=Inf)
deulermultinom(x=c(3,4,0),size=10,rate=c(1,1,1),dt=0-.1)
deulermultinom(x=c(3,4,0),size=10,rate=c(1,1,-1),dt=0.1)
deulermultinom(x=c(3,-4,0),size=10,rate=c(1,1,1),dt=0.1)
deulermultinom(x=c(3,6,3),size=10,rate=c(1,1,0),dt=0.1,log=TRUE)

eeulermultinom(size=100,rate=c(1,2,3),dt=0.1)
eeulermultinom(size=-3,rate=c(1,2,3),dt=0.1)
eeulermultinom(size=100,rate=c(1,-2,3),dt=0.1)
eeulermultinom(size=100,rate=c(1,NA,3),dt=0.1)
eeulermultinom(size=100.3,rate=c(1,2,3),dt=0.1)
eeulermultinom(size=100,rate=c(1,2,3),dt=0.1)
eeulermultinom(size=100,rate=c(1,2,3),dt=Inf)
eeulermultinom(size=100,rate=c(1,2e400,3),dt=0.1)
eeulermultinom(size=100,rate=c(1,2,3),dt=c(0.1,0.2,0.3,Inf))
eeulermultinom(size=100,rate=c(1,2,3),dt=c(0.1,0.2,0.3,0.5))
eeulermultinom(size=c(100,200,300),rate=c(1,2,3),dt=0.2)
eeulermultinom(size=0,rate=c(1,2,3),dt=0.2)
eeulermultinom(size=10,rate=c(1,Inf,1),0.1)
eeulermultinom(size=Inf,rate=c(1,100,1),0.1)
eeulermultinom(size=NA,rate=c(1,2,3),dt=1)
eeulermultinom(size=100,rate=c(1,NA,3),dt=1)
eeulermultinom(size=100,rate=c(1,2,3),dt=NA)
eeulermultinom(size=100,rate=c(0,0,0,0),dt=1)

rgammawn(n=5,sigma=2,dt=0.1)
rgammawn(n=5,sigma=1:5,dt=0.1)
rgammawn(n=5,sigma=1,dt=rep(1,5))
rgammawn(n=3,sigma=1:5,dt=rep(1,5))
rgammawn(n=2,sigma=-5,dt=1)
rgammawn(n=2,sigma=10,dt=-1)
rgammawn(n=2,sigma=0,dt=1)
try(rgammawn(n=-5,sigma=-5,dt=-1))
