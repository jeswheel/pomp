options(digits=3)

library(pomp)

po <- window(ou2(),end=10)

set.seed(3434388L)
simulate(po,nsim=5,format="arrays") -> sm
x <- sm$states
y <- sm$obs[,1,]
t <- time(po)
p <- coef(po)

dmeasure(po) -> L1
dmeasure(po,x=x,y=y,times=t,params=p) -> L
dmeasure(po,x=x,y=y,times=t,params=p,log=TRUE) -> ll
dmeasure(po,x=x,y=y,times=t,log=TRUE,
  params=array(data=p,dim=length(p),dimnames=list(names(p)))) -> ll2
dmeasure(
  po,
  x=array(data=x,dim=c(dim(x),1,1),
    dimnames=list(rownames(x),NULL,NULL,NULL,NULL)),
  y=y,
  times=t,log=TRUE,
  params=array(data=p,dim=length(p),dimnames=list(names(p)))
) -> ll3
dmeasure(
  po,
  x=array(data=x[,1,1],dim=nrow(x),dimnames=list(rownames(x))),
  y=y[,1],
  times=t[1],
  params=p,
  log=TRUE
) -> ll4
stopifnot(
  dim(L1)==c(1,length(time(po))),
  all.equal(ll[,1:3],log(L[,1:3])),
  identical(dim(ll),c(5L,10L)),
  all.equal(ll,ll2),
  all.equal(ll,ll3),
  all.equal(ll[1,1],ll4[1,1])
)

try(dmeasure("ou2",x=x,y=y,times=t,params=p))
try(dmeasure(x=x,y=y,times=t,params=p))
try(dmeasure(x,y=y,times=t,params=p))
dmeasure(po,x=x,y=y,times=t) -> L1
dmeasure(po,x=x,y=y,params=p) -> L2
dmeasure(po,x=x,times=t,params=p) -> L3
dmeasure(po,y=y,times=t,params=p) -> L4
stopifnot(
  identical(L1,L2),
  dim(L3)==c(5,10),
  dim(L4)==c(1,10)
)
try(dmeasure(po,x=as.numeric(x),y=y,times=t,params=p))
try(dmeasure(po,x=x,y=as.numeric(y),times=t,params=p))
try(dmeasure(po,x=x,y=y,times=NULL,params=p))
try(dmeasure(po,x=x[,,1],y=y[,1,drop=FALSE],times=t[1],params=p))
invisible(dmeasure(po,x=x[,,1,drop=FALSE],y=y[,1],times=t[1],params=p))
stopifnot(
  all.equal(dmeasure(po,x=x[,1,,drop=FALSE],y=y,times=t,params=p),
    dmeasure(po,x=x[,1,],y=y,times=t,params=p))
)
try(dmeasure(po,x=x,y=y[1,,drop=FALSE],times=t,params=p))
try(dmeasure(po,x=x[1,,,drop=FALSE],y=y,times=t,params=p))
k <- which(names(p)=="tau")
try(dmeasure(po,x=x,y=y,times=t,params=p[-k]))

pp <- parmat(p,5)
try(dmeasure(po,x=x,y=y,times=t,params=pp[,1:3]))
dmeasure(po,x=x,y=y,times=t,params=pp) -> d
stopifnot(
  dim(d)==c(5,10),
  names(dimnames(d))==c(".id","time")
)

rmeasure(po) -> y1
rmeasure(po,x=x,times=t,params=p) -> y
stopifnot(
  dim(y1)==c(2,1,10),
  names(dimnames(y1))==c("name",".id","time"),
  dim(y)==c(2,5,10),
  names(dimnames(y))==c("name",".id","time")
)

try(rmeasure("ou2",x=x,times=t,params=p))
try(rmeasure(x=x,times=t,params=p))
try(rmeasure(x,times=t,params=p))
freeze(rmeasure(po,x=x,times=t),seed=30998684) -> xx1
freeze(rmeasure(po,x=x,params=p),seed=30998684) -> xx2
stopifnot(identical(xx1,xx2))
try(rmeasure(po,x=as.numeric(x),times=t,params=p))
try(rmeasure(po,x=x,times=NULL,params=p))
try(rmeasure(po,x=x[,,1],times=t[1],params=p))
invisible(rmeasure(po,x=x[,,1,drop=FALSE],times=t[1],params=p))
try(rmeasure(po,x=x[1,,,drop=FALSE],times=t,params=p))
k <- which(names(p)=="tau")
try(rmeasure(po,x=x,times=t,params=p[-k]))

pp <- parmat(p,5)
try(rmeasure(po,x=x,times=t,params=pp[,1:3]))
rmeasure(po,x=x,times=t,params=pp) -> y
stopifnot(
  dim(y)==c(2,5,10),
  names(dimnames(y))==c("name",".id","time")
)

po |> pomp(
  rmeasure=function(...)c(1,2,3),
  dmeasure=function(...,log)c(3,2)
) -> po1
try(po1 |> rmeasure(x=x,times=t,params=p))
try(po1 |> dmeasure(x=x,y=y[,1,],times=t,params=p))

po |> pomp(
  rmeasure=NULL,
  dmeasure=NULL
) -> po1
po1 |> rmeasure(x=x,times=t,params=p) |> is.na() |> stopifnot()
po1 |> dmeasure(x=x,y=y[,1,],times=t,params=p) |> is.na() |> stopifnot()

sir() -> sir
po <- window(sir,end=0.5)

set.seed(3434388L)
simulate(po,nsim=5,format="arrays") -> sm
x <- sm$states
y <- sm$obs[,1,,drop=FALSE]
t <- time(po)
p <- coef(po)

po |> dmeasure(x=x,y=y,params=p,times=t,log=TRUE) -> d
po |> rmeasure(x=x,params=p,times=t) -> yy

po |>
  pomp(dmeasure=function(...,log)1) |>
  dmeasure(x=x,y=y,params=p,times=t) -> d

try({
  pp <- p
  names(pp)[3] <- NA
  po |> rmeasure(x=x,params=pp,times=t)
})

try({
  pp <- p
  names(pp)[3] <- ""
  po |> rmeasure(x=x,params=pp,times=t)
})

try({
  pp <- p
  names(pp) <- NULL
  po |> rmeasure(x=x,params=pp,times=t)
})
