##' Approximate Bayesian computation
##'
##' The approximate Bayesian computation (ABC) algorithm for estimating the parameters of a partially-observed Markov process.
##'
##' @name abc
##' @rdname abc
##' @aliases abc,missing-method abc,ANY-method
##' @docType methods
##' @include pomp_class.R probe.R continue.R workhorses.R
##' @importFrom stats runif
##' @author Edward L. Ionides, Aaron A. King
##' @family summary statistic-based methods
##' @family estimation methods
##' @family MCMC methods
##' @family Bayesian methods
##' @concept approximate Bayesian computation
##' @inheritParams probe
##' @inheritParams pmcmc
##' @inheritParams pomp
##' @param Nabc the number of ABC iterations to perform.
##' @param scale named numeric vector of scales.
##' @param epsilon ABC tolerance.
##'
##' @inheritSection pomp Note for Windows users
##'
##' @section Running ABC:
##'
##' \code{abc} returns an object of class \sQuote{abcd_pomp}.
##' One or more \sQuote{abcd_pomp} objects can be joined to form an \sQuote{abcList} object.
##'
##' @section Re-running ABC iterations:
##'
##' To re-run a sequence of ABC iterations, one can use the \code{abc} method on a \sQuote{abcd_pomp} object.
##' By default, the same parameters used for the original ABC run are re-used (except for \code{verbose}, the default of which is shown above).
##' If one does specify additional arguments, these will override the defaults.
##'
##' @section Continuing ABC iterations:
##'
##' One can continue a series of ABC iterations from where one left off using the \code{continue} method.
##' A call to \code{abc} to perform \code{Nabc=m} iterations followed by a call to \code{continue} to perform \code{Nabc=n} iterations will produce precisely the same effect as a single call to \code{abc} to perform \code{Nabc=m+n} iterations.
##' By default, all the algorithmic parameters are the same as used in the original call to \code{abc}.
##' Additional arguments will override the defaults.
##'
##' @section Methods:
##' The following can be applied to the output of an \code{abc} operation:
##' \describe{
##' \item{\code{abc}}{repeats the calculation, beginning with the last state}
##' \item{\code{\link{continue}}}{continues the \code{abc} calculation}
##' \item{\code{plot}}{produces a series of diagnostic plots}
##' \item{\code{\link{traces}}}{produces an \code{\link[coda]{mcmc}} object, to which the various \pkg{coda} convergence diagnostics can be applied}
##' }
##'
##' @references
##'
##' \Marin2012
##'
##' \Toni2010
##'
##' \Toni2009
##'
NULL

setClass(
  "abcd_pomp",
  contains="pomp",
  slots=c(
    pars = "character",
    Nabc = "integer",
    accepts = "integer",
    probes="list",
    scale = "numeric",
    epsilon = "numeric",
    proposal = "function",
    traces = "matrix"
  ),
  prototype=prototype(
    pars = character(0),
    Nabc = 0L,
    accepts = 0L,
    probes = list(),
    scale = numeric(0),
    epsilon = 1.0,
    proposal = function (...) pStop(who="abc","proposal not specified."),
    traces=array(dim=c(0,0))
  )
)

setGeneric(
  "abc",
  function (data, ...)
    standardGeneric("abc")
)

setMethod(
  "abc",
  signature=signature(data="missing"),
  definition=function (...) {
    reqd_arg("abc","data")
  }
)

setMethod(
  "abc",
  signature=signature(data="ANY"),
  definition=function (data, ...) {
    undef_method("abc",data)
  }
)

##' @rdname abc
##' @export
setMethod(
  "abc",
  signature=signature(data="data.frame"),
  definition=function (
    data,
    ...,
    Nabc = 1, proposal, scale, epsilon,
    probes,
    params, rinit, rprocess, rmeasure, dprior,
    verbose = getOption("verbose", FALSE)
  ) {

    tryCatch(
      abc_internal(
        data,
        ...,
        Nabc=Nabc,
        proposal=proposal,
        scale=scale,
        epsilon=epsilon,
        probes=probes,
        params=params,
        rinit=rinit,
        rprocess=rprocess,
        rmeasure=rmeasure,
        dprior=dprior,
        verbose=verbose
      ),
      error = function (e) pStop(who="abc",conditionMessage(e))
    )

  }
)

##' @rdname abc
##' @export
setMethod(
  "abc",
  signature=signature(data="pomp"),
  definition=function (
    data,
    ...,
    Nabc = 1, proposal, scale, epsilon,
    probes,
    verbose = getOption("verbose", FALSE)
  ) {

    tryCatch(
      abc_internal(
        data,
        ...,
        Nabc=Nabc,
        proposal=proposal,
        scale=scale,
        epsilon=epsilon,
        probes=probes,
        verbose=verbose
      ),
      error = function (e) pStop(who="abc",conditionMessage(e))
    )

  }
)

##' @rdname abc
##' @export
setMethod(
  "abc",
  signature=signature(data="probed_pomp"),
  definition=function (
    data,
    ...,
    probes,
    verbose = getOption("verbose", FALSE)
  ) {

    if (missing(probes)) probes <- data@probes

    abc(
      as(data,"pomp"),
      ...,
      probes=probes,
      verbose=verbose
    )

  }
)

##' @rdname abc
##' @export
setMethod(
  "abc",
  signature=signature(data="abcd_pomp"),
  definition=function (
    data,
    ...,
    Nabc, proposal, scale, epsilon,
    probes,
    verbose = getOption("verbose", FALSE)
  ) {

    if (missing(Nabc)) Nabc <- data@Nabc
    if (missing(proposal)) proposal <- data@proposal
    if (missing(scale)) scale <- data@scale
    if (missing(epsilon)) epsilon <- data@epsilon
    if (missing(probes)) probes <- data@probes

    abc(
      as(data,"pomp"),
      ...,
      Nabc=Nabc,
      proposal=proposal,
      scale=scale,
      epsilon=epsilon,
      probes=probes,
      verbose=verbose
    )

  }
)

##' @rdname continue
##' @param Nabc positive integer; number of additional ABC iterations to perform
##' @export
setMethod(
  "continue",
  signature=signature(object="abcd_pomp"),
  definition=function (
    object,
    ...,
    Nabc = 1
  ) {

    ndone <- object@Nabc
    accepts <- object@accepts

    obj <- abc(object,...,Nabc=Nabc,.ndone=ndone,.accepts=accepts)

    obj@traces <- rbind(
      object@traces[,colnames(obj@traces)],
      obj@traces[-1,]
    )
    names(dimnames(obj@traces)) <- c("iteration","name")
    obj@Nabc <- as.integer(ndone+Nabc)
    obj@accepts <- as.integer(accepts+obj@accepts)

    obj
  }
)

abc_internal <- function (
  object,
  ...,
  Nabc, proposal, scale, epsilon, probes,
  verbose,
  .ndone = 0L, .accepts = 0L, .gnsi = TRUE
) {

  verbose <- as.logical(verbose)

  object <- pomp(object,...,verbose=verbose)

  if (undefined(object@rprocess) || undefined(object@rmeasure))
    pStop_(paste(sQuote(c("rprocess","rmeasure")),collapse=", ")," are needed basic components.")

  if (missing(proposal)) proposal <- NULL
  if (missing(probes)) probes <- NULL
  if (missing(scale)) scale <- NULL
  if (missing(epsilon)) epsilon <- NULL

  gnsi <- as.logical(.gnsi)
  scale <- as.numeric(scale)
  epsilon <- as.numeric(epsilon)
  epssq <- epsilon*epsilon
  .ndone <- as.integer(.ndone)
  .accepts <- as.integer(.accepts)

  params <- coef(object)

  Nabc <- as.integer(Nabc)
  if (!is.finite(Nabc) || Nabc < 0)
    pStop_(sQuote("Nabc")," must be a positive integer.")

  param.names <- names(params)
  if (is.null(param.names) || !is.numeric(params))
    pStop_(sQuote("params")," must be a named numeric vector.")

  if (is.null(proposal))
    pStop_(sQuote("proposal")," must be specified.")
  if (!is.function(proposal))
    pStop_(sQuote("proposal")," must be a function.")

  if (is.null(probes))
    pStop_(sQuote("probes")," must be specified.")
  if (!is.list(probes)) probes <- list(probes)
  if (!all(vapply(probes,is.function,logical(1L))))
    pStop_(sQuote("probes")," must be a function or a list of functions.")
  if (!all(vapply(probes,\(f)length(formals(f))==1L,logical(1L))))
    pStop_("each probe must be a function of a single argument.")

  if (length(scale)==0)
    pStop_(sQuote("scale")," must be specified.")

  if (length(epsilon)==0)
    pStop_("abc match criterion, ",sQuote("epsilon"),", must be specified.")

  pompLoad(object,verbose=verbose)
  on.exit(pompUnload(object,verbose=verbose))

  ## test proposal distribution
  theta <- tryCatch(
    proposal(params,.n=0),
    error = function (e)
      pStop_("in proposal function: ",conditionMessage(e))
  )
  if (is.null(names(theta)) || !is.numeric(theta) || any(!nzchar(names(theta))))
    pStop_(sQuote("proposal")," must return a named numeric vector.")

  theta <- params
  log.prior <-dprior(object,params=theta,log=TRUE,.gnsi=gnsi)

  if (!is.finite(log.prior))
    pStop_("non-finite log prior at starting parameters.")

  ## we suppose that theta is a "match",
  ## which does the right thing for continue() and
  ## should have negligible effect unless doing many short calls to continue()

  traces <- matrix(
    data=NA,
    nrow=Nabc+1,
    ncol=length(theta),
    dimnames=list(
      iteration=seq(from=0,to=Nabc,by=1),
      name=names(theta)
    )
  )

  ## apply probes to data
  datval <- tryCatch(
    .Call(P_apply_probe_data,object,probes),
    error = function (e) {
      pStop_("applying probes to data: ",conditionMessage(e))
    }
  )

  if (length(scale) != 1 && length(scale) != length(datval))
    pStop_(sQuote("scale")," must have either length 1 or length equal to the",
      " number of probes (here, ",length(datval),").")

  traces[1,names(theta)] <- theta

  for (n in seq_len(Nabc)) { # main loop

    theta.prop <- tryCatch(
      proposal(theta,.n=n+.ndone,.accepts=.accepts,verbose=verbose),
      error = function (e)
        pStop_("in proposal function: ",conditionMessage(e))
    )
    log.prior.prop <- dprior(object,params=theta.prop,log=TRUE,
      .gnsi=gnsi)

    if (is.finite(log.prior.prop) && runif(1) < exp(log.prior.prop-log.prior)) {

      ## compute the probes for the proposed new parameter values

      simval <- tryCatch(
        .Call(P_apply_probe_sim,object=object,nsim=1L,params=theta.prop,
          probes=probes,datval=datval,gnsi=gnsi),
        error = function (e)
          pStop_("applying probes to simulations: ",conditionMessage(e))
      )

      ## ABC update rule
      distance <- sum(((datval-simval)/scale)^2)
      if( (is.finite(distance)) && (distance<epssq) ){
        theta <- theta.prop
        log.prior <- log.prior.prop
        .accepts <- .accepts+1L
      }

    }

    ## store a record of this iteration
    traces[n+1,names(theta)] <- theta
    if (verbose && (n%%5==0))
      cat("ABC iteration",n+.ndone,"of",Nabc+.ndone,
        "completed\nacceptance ratio:",
        round(.accepts/(n+.ndone),3),"\n")

    gnsi <- FALSE

  }

  pars <- apply(traces,2L,\(x)diff(range(x))>0)
  pars <- names(pars[pars])

  new(
    "abcd_pomp",
    object,
    params=theta,
    pars=pars,
    Nabc=Nabc,
    accepts=.accepts,
    probes=probes,
    scale=scale,
    epsilon=epsilon,
    proposal=proposal,
    traces=traces
  )

}
