options(digits=3)

library(pomp)

gompertz() -> po

pomp(po,partrans=NULL,userdata=list(bob=3),
  covar=covariate_table(a=0:20,b=0:20,times="a")) -> po1
spy(po1)

po1 |>
  pomp(partrans=parameter_trans(log="r"),params=NULL,
    rinit=function(params,t0,...)params,
    paramnames="r",compile=FALSE,cfile="nancy") -> po2
spy(po2)

sir() -> sir
spy(sir)

rw2() -> rw2
spy(rw2)

sir2() -> sir2
spy(sir2)

try(spy())
try(spy(list()))

pomp(
  data=NULL,
  t0=0,times=1:10,
  userdata=list(x0=as.double(1)),
  params=c(x_0=1,a=22),
  rinit=Csnippet(r"{x = *get_userdata_double("x0");}"),
  statenames="x",
  compile=FALSE
) |>
  spy()

pomp(
  data=NULL,
  t0=0,times=1:10,
  userdata=list(x0=as.double(1)),
  params=c(x_0=1,a=22),
  globals=Csnippet("static double X0;"),
  rinit=Csnippet(r"{x = X0;}"),
  rprocess=euler(Csnippet(r"(x += rgammawn(0.1,dt);)"),delta.t=0.1),
  on_load=Csnippet(r"{X0 = *get_userdata_double("x0");}"),
  statenames="x",
  compile=FALSE
) |>
  spy()
