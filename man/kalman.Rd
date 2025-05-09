% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kalman.R
\name{kalman}
\alias{kalman}
\alias{enkf,ANY-method}
\alias{enkf,missing-method}
\alias{eakf,ANY-method}
\alias{eakf,missing-method}
\alias{enkf,data.frame-method}
\alias{enkf}
\alias{enkf,pomp-method}
\alias{enkf,kalmand_pomp-method}
\alias{eakf,data.frame-method}
\alias{eakf}
\alias{eakf,pomp-method}
\title{Ensemble Kalman filters}
\usage{
\S4method{enkf}{data.frame}(
  data,
  ...,
  Np,
  params,
  rinit,
  rprocess,
  emeasure,
  vmeasure,
  verbose = getOption("verbose", FALSE)
)

\S4method{enkf}{pomp}(data, ..., Np, verbose = getOption("verbose", FALSE))

\S4method{enkf}{kalmand_pomp}(data, ..., Np, verbose = getOption("verbose", FALSE))

\S4method{eakf}{data.frame}(
  data,
  ...,
  Np,
  params,
  rinit,
  rprocess,
  emeasure,
  vmeasure,
  verbose = getOption("verbose", FALSE)
)

\S4method{eakf}{pomp}(data, ..., Np, verbose = getOption("verbose", FALSE))
}
\arguments{
\item{data}{either a data frame holding the time series data,
or an object of class \sQuote{pomp},
i.e., the output of another \pkg{pomp} calculation.
Internally, \code{data} will be coerced to an array with storage-mode \code{double}.}

\item{...}{additional arguments are passed to \code{\link{pomp}}.
This allows one to set, unset, or modify \link[=basic_components]{basic model components} within a call to this function.}

\item{Np}{integer; the number of particles to use, i.e., the size of the ensemble.}

\item{params}{optional; named numeric vector of parameters.
This will be coerced internally to storage mode \code{double}.}

\item{rinit}{simulator of the initial-state distribution.
This can be furnished either as a C snippet, an \R function, or the name of a pre-compiled native routine available in a dynamically loaded library.
Setting \code{rinit=NULL} sets the initial-state simulator to its default.
For more information, see \link[=rinit_spec]{rinit specification}.}

\item{rprocess}{simulator of the latent state process, specified using one of the \link[=rprocess_spec]{rprocess plugins}.
Setting \code{rprocess=NULL} removes the latent-state simulator.
For more information, see \link[=rprocess_spec]{rprocess specification for the documentation on these plugins}.}

\item{emeasure}{the expectation of the measured variables, conditional on the latent state.
This can be specified as a C snippet, an \R function, or the name of a pre-compiled native routine available in a dynamically loaded library.
Setting \code{emeasure=NULL} removes the emeasure component.
For more information, see \link[=emeasure_spec]{emeasure specification}.}

\item{vmeasure}{the covariance of the measured variables, conditional on the latent state.
This can be specified as a C snippet, an \R function, or the name of a pre-compiled native routine available in a dynamically loaded library.
Setting \code{vmeasure=NULL} removes the vmeasure component.
For more information, see \link[=vmeasure_spec]{vmeasure specification}.}

\item{verbose}{logical; if \code{TRUE}, diagnostic messages will be printed to the console.}
}
\value{
An object of class \sQuote{kalmand_pomp}.
}
\description{
The ensemble Kalman filter and ensemble adjustment Kalman filter.
}
\section{Note for Windows users}{


Some Windows users report problems when using C snippets in parallel computations.
These appear to arise when the temporary files created during the C snippet compilation process are not handled properly by the operating system.
To circumvent this problem, use the \code{\link[=pomp]{cdir}} and \code{\link[=pomp]{cfile}} options to cause the C snippets to be written to a file of your choice, thus avoiding the use of temporary files altogether.
}

\references{
\Evensen1994

\Anderson2001

\Evensen2009
}
\seealso{
\code{\link{kalmanFilter}}

More on sequential Monte Carlo methods: 
\code{\link{bsmc2}()},
\code{\link{cond_logLik}()},
\code{\link{eff_sample_size}()},
\code{\link{filter_mean}()},
\code{\link{filter_traj}()},
\code{\link{mif2}()},
\code{\link{pfilter}()},
\code{\link{pmcmc}()},
\code{\link{pred_mean}()},
\code{\link{pred_var}()},
\code{\link{saved_states}()},
\code{\link{wpfilter}()}

More on \pkg{pomp} elementary algorithms: 
\code{\link{elementary_algorithms}},
\code{\link{pfilter}()},
\code{\link{pomp-package}},
\code{\link{probe}()},
\code{\link{simulate}()},
\code{\link{spect}()},
\code{\link{trajectory}()},
\code{\link{wpfilter}()}
}
\author{
Aaron A. King
}
\concept{Kalman filter}
\concept{elementary algorithms}
\concept{particle filter methods}
