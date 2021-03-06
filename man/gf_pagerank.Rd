% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gf_pagerank.R
\name{gf_pagerank}
\alias{gf_pagerank}
\title{PageRank}
\usage{
gf_pagerank(x, tol = NULL, reset_prob = 0.15, max_iter = NULL,
  source_id = NULL, ...)
}
\arguments{
\item{x}{An object coercable to a GraphFrame (typically, a
\code{gf_graphframe}).}

\item{tol}{tolerance}

\item{reset_prob}{reset probability}

\item{max_iter}{maximum number of iterations}

\item{source_id}{(Optional) source vertex for a personalized pagerank}

\item{...}{Optional arguments, currently not used.}
}
\description{
PageRank
}
