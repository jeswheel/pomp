library(pomp)

gompertz() -> po

set.seed(530370883)

coef(po)
coef(po,transform=TRUE)
coef(po,c("r","tau"))
try(coef(po,c("bob","tau")))
try(coef(po) <- c(1,2,3))
try(coef(po,transform=TRUE) <- c(1,2,3))
coef(po) <- list(as.list(coef(po)))
coef(po,"r") <- 0.2
coef(po,"r") <- list(r=0.2)
coef(po,c("r","theta")) <- list(r=0.2)
coef(po,"sigma",transform=TRUE) <- 0
coef(po)
coef(po) <- NULL
stopifnot(identical(coef(po),numeric(0)))
coef(po,c("r","sigma")) <- 1
stopifnot(all.equal(coef(po),c(r=1,sigma=1)))
coef(po) <- NULL
try(coef(po,c("r","sigma"),transform=TRUE) <- 0)
coef(po) <- NULL
coef(po) <- c(r=1,sigma=1)
stopifnot(all.equal(coef(po),c(r=1,sigma=1)))
coef(po) <- NULL
coef(po,transform=TRUE) <- c(r=0,sigma=0,K=0,tau=0,X_0=0)
stopifnot(all.equal(coef(po),c(r=1,sigma=1,K=1,tau=1,X_0=1)))

ou2() -> po
po1 <- simulate(po)

as(po,"data.frame") |> head()
as.data.frame(po1) |> head()

obs(po)[,1:3]
obs(po,"y2")[,1:3]
try(obs(po,c("y2","z")))

states(po)
states(po1,"x1")[,1:3]
try(states(po1,"z"))
states(po1)[,1:3]
states(ricker())[,1:3]

time(po)[1:3]
time(po,t0=TRUE)[1:3]

time(po) <- 1:10
try(time(po) <- c("bob","nancy"))
time(po1,t0=TRUE) <- 0:10
try(time(po) <- 10:0)
try(time(po,t0=TRUE) <- c(4,1:10))
time(po1) <- c(1:5,5,5:10)
stopifnot(obs(po1)[,6:7]==obs(po1)[,5],
  states(po1)[,6:7]==states(po1)[,5])

window(po,end=5)
window(po,start=5)
window(po,start=5,end=10)
try(window(po,start=5,end=3))
try(window(po,start=NA,end=3))
try(window(po,start=1,end=NULL))

timezero(po)
timezero(po) <- -3
try(timezero(po) <- NA)
try(timezero(po) <- c(1,2,3))
try(timezero(po) <- 20)

coef(po)
coef(po,c("alpha_3","tau"))
try(coef(po,c("alpha_3","z")))

coef(po,"alpha_3") <- 4
coef(po,"z") <- 9
coef(po)
coef(po) <- NULL
coef(po)
coef(po) <- list(a=3,b=12)

gompertz() -> gompertz
gompertz -> po

pos <- c(po,po,po)
stopifnot(
  dim(coef(pos))==c(5,3),
  length(obs(pos))==3,
  all(sapply(obs(pos),length)==100),
  length(states(pos))==3,
  all(sapply(states(pos),length)==100)
)

coef(po)
coef(po,transform=TRUE,pars=c("r","K"))
coef(po,"sigma",transform=TRUE) <- 0
coef(po)
coef(po,c("r","K","sigma","tau","X_0")) <- c(a=1,b=2,c=3,d=4,e=5)
coef(po) <- c(r=1,K=1)
coef(po) <- NULL
try(coef(po,transform=FALSE) <- c(5,3))
try(coef(po,transform=TRUE) <- c(5,3))
coef(po)
po |>
  window(start=5,end=20) |>
  pomp(covar=covariate_table(times=0:20,q=0:20),
    userdata=list(larry=3L)) -> po1
as(po1,"data.frame") |> head()

dim(as.data.frame(c(a=po1,b=po1)))
