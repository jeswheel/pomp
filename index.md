---
title: pomp, an R package for statistical inference using partially observed Markov processes
id: about
layout: pomp
---

<span class="firstcharacter">**pomp**</span> provides a very general realization of nonlinear partially-observed Markov processes (also known as nonlinear stochastic dynamical systems, hidden Markov models, and state space models).
These are a generalization of linear state-space and hidden Markov models to nonlinear, non-Gaussian processes in either discrete or continuous time.
In **pomp**, one can implement a model by specifying its unobserved process and measurement components;
the package uses these functions in algorithms to simulate, analyze, and fit the model to data.

Currently, **pomp** provides support for

- basic particle filtering (AKA sequential importance sampling or sequential Monte Carlo),
- trajectory matching,
- the approximate Bayesian sequential Monte Carlo algorithm of Liu&nbsp;&amp;&nbsp;West&nbsp;(2001),
- the particle Markov chain Monte Carlo method of Andrieu et al.&nbsp;(2010),
- approximate Bayesian computation (ABC; Toni et al.&nbsp;2009)
- the improved iterated filtering method (Ionides et al. 2015),
- probe-matching methods based on synthetic likelihood (e.g., Kendall et al. 1999, Wood et al. 2010)
- the nonlinear forecasting method of Ellner&nbsp;&amp;&nbsp;Kendall,
- the ensemble Kalman filter of Evensen (1994, 2009), and
- the ensemble adjustment Kalman filter of Anderson (2001), and
- power-spectrum-matching methods of Reuman et al. (2006).

**pomp** is also a platform upon which general inference algorithms for partially observed Markov processes can be implemented.
We welcome contributions in the form of codes, examples, improvements to the documentation, bug reports, feature requests, and requests for help!

This website contains [installation instructions](/install.html), a wide range of [tutorials and examples](/docs.html), access to the [source code](https://github.com/kingaa/pomp/), a facility for [reporting issues with the package](https://github.com/kingaa/pomp/issues), and an extensive but incomplete [bibliography](/biblio.html) of publications describing **pomp** methods and **pomp** applications.

Please let the developers know if you find **pomp** useful, if you publish results obtained using it, [if you come up with improvements, find bugs, or have suggestions or feature requests!](https://github.com/kingaa/pomp/issues){:target="_blank"}
There is also a [wiki](https://github.com/kingaa/pomp/wiki/pimp-my-pomp){:target="_blank"}:
you are invited to contribute snippets of code, interesting results, references to papers, and so on.

Although **pomp** is a mature package, it is being actively maintained and new features are under development.
To keep abreast of **pomp** news, view the [**pomp** news blog](https://kingaa.github.io/pomp/blog.html) and/or subscribe to the [**pomp** RSS feed](./pomp.atom).
