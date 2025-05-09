options(digits=3)
set.seed(58668844L)

library(pomp)

simulate(
  times=seq(1,100),t0=0,
  userdata=list(
    nbasis=9L,
    period=50.0,
    msg="hello!"
  ),
  params=setNames(runif(n=9,min=-5,max=5),sprintf("beta%d",1:9)),
  rprocess=euler(
    Csnippet(r"{
      static int first = 1;
      if (first) {
        SEXP Msg = get_userdata("msg");
        char *msg = CHAR(STRING_ELT(Msg,0));
        Rprintf("%s\n",msg);
        first = 0;
      }
      int nbasis = *(get_userdata_int("nbasis"));
      int degree = 3;
      double period = *(get_userdata_double("period"));
      double dxdt[nbasis];
      periodic_bspline_basis_eval(t,period,degree,nbasis,dxdt);
      x += dt*dot_product(nbasis,dxdt,&beta1);}"
    ),delta.t=0.01
  ),
  rmeasure=Csnippet("y = x;"),
  rinit=Csnippet("x = 0;"),
  statenames="x",obsnames="y",paramnames=c("beta1","beta2","beta3")
) -> po

try(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{
      SEXP Msg = get_userdata("bob");
      char *msg = CHAR(STRING_ELT(Msg,0));
      Rprintf("%s\n",msg);}"))))
try(po |> simulate(time=1:3))
try(po |> simulate(time=1:3,bob=77))
try(po |> simulate(times=1:3,seed=NULL,nsim=5,77))
try(po |> pomp(77))
try(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{double nbasis = *(get_userdata_double("nbasis"));}"))))
try(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{double nbasis = *(get_userdata_double("bob"));}"))))
try(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{int nbasis = *(get_userdata_int("period"));}"))))
try(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{int nbasis = *(get_userdata_int("bob"));}"))))
try(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{int nbasis = *(get_userdata_int("bob"));}")),
      userdata=list(bob=3)))
stopifnot(po |>
    simulate(rprocess=onestep(
      Csnippet(r"{int nbasis = *(get_userdata_int("bob"));}")),
      userdata=list(bob=3L)) |> class() == "pomp")
