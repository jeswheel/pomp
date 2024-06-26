% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/covariate_table.R, R/lookup.R
\name{covariates}
\alias{covariates}
\alias{covariate_table}
\alias{covariate_table,missing-method}
\alias{covariate_table,ANY-method}
\alias{covariate_table,numeric-method}
\alias{covariate_table,character-method}
\alias{repair_lookup_table}
\title{Covariates}
\usage{
\S4method{covariate_table}{numeric}(..., order = c("linear", "constant"), times)

\S4method{covariate_table}{character}(..., order = c("linear", "constant"), times)

repair_lookup_table(table, t, order)
}
\arguments{
\item{\dots}{numeric vectors or data frames containing time-varying covariates.
It must be possible to bind these into a data frame.}

\item{order}{the order of interpolation to be used.
Options are \dQuote{linear} (the default) and \dQuote{constant}.
Setting \code{order="linear"} treats the covariates as piecewise linear functions of time;
\code{order="constant"} treats them as right-continuous piecewise constant functions.}

\item{times}{the times corresponding to the covariates.
This may be given as a vector of (non-decreasing, finite) numerical values.
Alternatively, one can specify by name which of the given variables is the time variable.}

\item{table}{a \sQuote{covartable} object created by a call to \code{\link{covariate_table}}}

\item{t}{numeric vector;
times at which interpolated values of the covariates in \code{table} are required.}
}
\value{
\code{covariate_table} returns a lookup table suitable for inclusion of covariates in a \sQuote{pomp} object.
Specifically, this is an object of class \sQuote{covartable}.

\code{repair_lookup_table} returns a lookup table with entries at the provided values of \code{t}.
}
\description{
Incorporating time-varying covariates using lookup tables.
}
\details{
If the \sQuote{pomp} object contains covariates (specified via the \code{covar} argument), then interpolated values of the covariates will be available to each of the model components whenever it is called.
In particular, variables with names as they appear in the \code{covar} covariate table will be available to any C snippet.
When a basic component is defined using an \R function, that function will be called with an extra argument, \code{covars}, which will be a named numeric vector containing the interpolated values from the covariate table.

An exception to this rule is the prior (\code{rprior} and \code{dprior}):
covariate-dependent priors are not allowed.
Nor are parameter transformations permitted to depend upon covariates.

\code{repair_lookup_table} applies \code{\link{lookup}} at the provided values of \code{t} and returns the resulting lookup table.
If \code{order} is unsupplied, the interpolation-order from \code{table} is preserved.
\strong{\code{repair_lookup_table} should be considered experimental: its interface may change without notice}.
}
\section{Extrapolation}{

If \code{t} is outside the range of the lookup table, the values will be extrapolated, and a warning will be issued.
The type of extrapolation performed will be constant or linear according to the \code{order} flag used when creating the table.
}

\seealso{
More on implementing POMP models: 
\code{\link{Csnippet}},
\code{\link{accumvars}},
\code{\link{basic_components}},
\code{\link{betabinomial}},
\code{\link{dinit_spec}},
\code{\link{dmeasure_spec}},
\code{\link{dprocess_spec}},
\code{\link{emeasure_spec}},
\code{\link{eulermultinom}},
\code{\link{parameter_trans}()},
\code{\link{pomp-package}},
\code{\link{pomp_constructor}},
\code{\link{prior_spec}},
\code{\link{rinit_spec}},
\code{\link{rmeasure_spec}},
\code{\link{rprocess_spec}},
\code{\link{skeleton_spec}},
\code{\link{transformations}},
\code{\link{userdata}},
\code{\link{vmeasure_spec}}

More on interpolation:
\code{\link{bsplines}},
\code{\link{lookup}()}
}
\concept{covariates}
\concept{implementation information}
\concept{interpolation}
