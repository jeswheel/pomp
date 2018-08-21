% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/covariate_table.R
\docType{methods}
\name{covariate_table}
\alias{covariate_table}
\alias{covariate_table,missing-method}
\alias{covariate_table,ANY-method}
\alias{covariate_table-ANY}
\title{Covariates}
\usage{
\S4method{covariate_table}{ANY}(..., times)
}
\arguments{
\item{\dots}{numeric vectors or data frames containing time-varying covariates}

\item{times}{the times corresponding to the covariates.
This may be given as a vector of (increasing, finite) numerical values.
Alternatively, one can indicate one of the variables given (either as a vector or as a data-frame column) by name or by index.}
}
\description{
Including time-varying covariates in a model.
}
\details{
If the \sQuote{pomp} object contains covariates (specified via the \code{covar} argument), then interpolated values of the covariates will be available to each of the model components whenever it is called.
In particular, variables with names as they appear in the \code{covar} covariate table will be available to any C snippet.
When a basic component is defined using an \R function, that function will be called with an extra argument, \code{covars}, which will be a named numeric vector containing the interpolated values from the covariate table.

An exception to this rule is the prior (\code{rprior} and \code{dprior}):
covariate-dependent priors are not allowed.
Nor are parameter transformations permitted to depend upon covariates.
}
\seealso{
Other information on model implementation: \code{\link{Csnippet}},
  \code{\link{accumulators}}, \code{\link{dmeasure_spec}},
  \code{\link{dprocess_spec}},
  \code{\link{parameter_trans}}, \code{\link{prior_spec}},
  \code{\link{rinit_spec}}, \code{\link{rmeasure_spec}},
  \code{\link{rprocess_spec}}, \code{\link{skeleton_spec}},
  \code{\link{userdata}}
}
\concept{information on model implementation}