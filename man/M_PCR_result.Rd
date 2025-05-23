% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/M_PCR_result.R
\name{M_PCR_result}
\alias{M_PCR_result}
\title{Estimating the age using M_PCR method}
\usage{
M_PCR_result(x, y)
}
\arguments{
\item{x}{the name of inputted ply file of the whole auricular surface}

\item{y}{the name of inputted ply file of the apex of the auricular surface}
}
\value{
estimated result gets printed to the console
}
\description{
M_PCR method is the principal component linear regression analysis with multi-population (M_PCR) method using the Dirichlet Normal Energy (DNE).
The function automatically calculates the DNE on the auricular surface
It provides the estimated age and standard errors (SE, 10.2yrs).
}
