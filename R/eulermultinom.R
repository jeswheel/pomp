##' Eulermultinomial and Gamma-whitenoise distributions
##'
##' \pkg{pomp} provides a number of probability distributions that have proved useful in modeling partially observed Markov processes.
##' These include the Euler-multinomial family of distributions and
##' the the Gamma white-noise processes.
##'
##' If \eqn{N} individuals face constant hazards of death in \eqn{K} ways
##' at rates \eqn{r_1, r_2, \dots, r_K}{r1,r2,\dots,rK},
##' then in an interval of duration \eqn{\Delta{t}}{dt},
##' the number of individuals remaining alive and dying in each way is multinomially distributed:
##' \deqn{(\Delta{n_0}, \Delta{n_1}, \dots, \Delta{n_K}) \sim \mathrm{Multinomial}(N;p_0,p_1,\dots,p_K),}{(dn0, dn1, \dots, dnK) ~ multinomial(N; p0, p1, \dots, pK),}
##' where \eqn{\Delta{n_0}=N-\sum_{k=1}^K \Delta{n_k}}{dn0 = N - sum(dnk,k=1:K)} is the number of individuals remaining alive and
##' \eqn{\Delta{n_k}}{dnk} is the number of individuals dying in way \eqn{k} over the interval.
##' Here, the probability of remaining alive is \deqn{p_0=\exp(-\sum_k r_k \Delta{t})}{p0 = exp(-sum(rk, k=1:K)*dt)}
##' and the probability of dying in way \eqn{k} is \deqn{p_k=\frac{r_k}{\sum_j r_j} (1-p_0).}{pk = (1-p0)*rk/sum(rj, j=1:K).}
##' In this case, we say that \deqn{(\Delta{n_1},\dots,\Delta{n_K})\sim\mathrm{Eulermultinom}(N,r,\Delta t),}{(dn1,\dots,dnK) ~ eulermultinom(N,r,dt),} where \eqn{r=(r_1,\dots,r_K)}{r=(r1,\dots,rK)}.
##' Draw \eqn{m} random samples from this distribution by doing \preformatted{
##'     dn <- reulermultinom(n=m,size=N,rate=r,dt=dt),
##' } where \code{r} is the vector of rates.
##' Evaluate the probability that \eqn{x=(x_1,\dots,x_K)}{x=(x1,\dots,xK)} are the numbers of individuals who have died in each of the \eqn{K} ways over the interval \eqn{\Delta t=}{dt=}\code{dt},
##' by doing \preformatted{
##'     deulermultinom(x=x,size=N,rate=r,dt=dt).
##' }
##'
##' Bretó & Ionides (2011) discuss how an infinitesimally overdispersed death process can be constructed by compounding a multinomial process with a Gamma white noise process.
##' The Euler approximation of the resulting process can be obtained as follows.
##' Let the increments of the equidispersed process be given by
##' \preformatted{
##'     reulermultinom(size=N,rate=r,dt=dt).
##' }
##' In this expression, replace the rate \eqn{r} with \eqn{r\,{\Delta{W}}/{\Delta t}}{r*dW/dt},
##' where \eqn{\Delta{W} \sim \mathrm{Gamma}(\Delta{t}/\sigma^2,\sigma^2)}{dW ~ Gamma(dt/sigma^2,sigma^2)}
##' is the increment of an integrated Gamma white noise process with intensity \eqn{\sigma}{sigma}.
##' That is, \eqn{\Delta{W}}{dW} has mean \eqn{\Delta{t}}{dt} and variance \eqn{\sigma^2 \Delta{t}}{sigma^2*dt}.
##' The resulting process is overdispersed and converges (as \eqn{\Delta{t}}{dt} goes to zero) to a well-defined process.
##' The following lines of code accomplish this:
##' \preformatted{
##'     dW <- rgammawn(sigma=sigma,dt=dt)
##' } \preformatted{
##'     dn <- reulermultinom(size=N,rate=r,dt=dW)
##' } or
##' \preformatted{
##'     dn <- reulermultinom(size=N,rate=r*dW/dt,dt=dt).
##' }
##' He et al. (2010) use such overdispersed death processes in modeling measles and the \href{https://kingaa.github.io/sbied/measles/}{"Simulation-based Inference" course} discusses the value of allowing for overdispersion more generally.
##'
##' For all of the functions described here, access to the underlying C routines is available:
##' see below.
##' @name eulermultinom
##' @rdname eulermultinom
##' @family implementation information
##' @concept probability distributions
##' @param n integer; number of random variates to generate.
##' @param size scalar integer; number of individuals at risk.
##' @param rate numeric vector of hazard rates.
##' @param sigma numeric scalar; intensity of the Gamma white noise process.
##' @param dt numeric scalar; duration of Euler step.
##' @param x matrix or vector containing number of individuals that have
##' succumbed to each death process.
##' @param log logical; if TRUE, return logarithm(s) of probabilities.
##' @section C API:
##' An interface for C codes using these functions is provided by the package.
##' Visit the package homepage to view the \href{https://kingaa.github.io/pomp/C_API.html}{\pkg{pomp} C API document}.
##' @author Aaron A. King
##' @references
##' \Breto2011
##' \He2010
##' @keywords distribution
##' @example examples/eulermultinom.R
NULL

##' @rdname eulermultinom
##' @return
##' \code{reulermultinom} returns a \code{length(rate)} by \code{n} matrix.
##' Each column is a different random draw.
##' Each row contains the numbers of individuals that have succumbed to the corresponding process.
##' @export
reulermultinom <- function (n = 1, size, rate, dt) {
  tryCatch(
    .Call(P_R_Euler_Multinom,n,size,rate,dt),
    error = function (e) pStop(who="reulermultinom",conditionMessage(e))
  )
}

##' @rdname eulermultinom
##' @return
##' \code{deulermultinom} returns a vector (of length equal to the number of columns of \code{x}).
##' This contains the probabilities of observing each column of \code{x} given the specified parameters (\code{size}, \code{rate}, \code{dt}).
##' @export
deulermultinom <- function (x, size, rate, dt, log = FALSE) {
  tryCatch(
    .Call(P_D_Euler_Multinom,as.matrix(x),size,rate,dt,log),
    error = function (e) pStop(who="deulermultinom",conditionMessage(e))
  )
}

##' @rdname eulermultinom
##' @return
##' \code{eeulermultinom} returns a \code{length(rate)}-vector
##' containing the expected number of individuals to have succumbed to the corresponding process.
##' With the notation above, if
##' \preformatted{
##'     dn <- eeulermultinom(size=N,rate=r,dt=dt),
##' }
##' then the \eqn{k}-th element of the vector \code{dn} will be \eqn{p_k N}{pk N}.
##' @export
eeulermultinom <- function (size, rate, dt) {
  tryCatch(
    .Call(P_E_Euler_Multinom,size,rate,dt),
    error = function (e) pStop(who="eeulermultinom",conditionMessage(e))
  )
}

##' @rdname eulermultinom
##' @return
##' \code{rgammawn} returns a vector of length \code{n} containing random increments of the integrated Gamma white noise process with intensity \code{sigma}.
##' @export
rgammawn <- function (n = 1, sigma, dt) {
  tryCatch(
    .Call(P_R_GammaWN,n,sigma,dt),
    error = function (e) pStop(who="rgammwn",conditionMessage(e))
  )
}
