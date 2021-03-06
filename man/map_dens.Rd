% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map_dens.R
\name{map_dens}
\alias{map_dens}
\title{Plot the estimated density on map}
\usage{
map_dens(
  data,
  region,
  scale_name,
  ncol,
  shape,
  size,
  zoom_in_lon,
  zoom_in_lat,
  fig_output_dirname
)
}
\arguments{
\item{data}{dataframe made by get_dens function}

\item{region}{region of the data. please see require(maps) and unique(map_data("world")$region)}

\item{scale_name}{unit of estimated density}

\item{ncol}{number of figures in line side by side. max is no. of "Category"}

\item{shape}{shape of COG point}

\item{size}{size of shape}

\item{zoom_in_lon}{zoom in on the map if 1<, zoom out on the map if 1>, and 1 is the same size}

\item{zoom_in_lat}{zoom in on the map if 1<, zoom out on the map if 1>, and 1 is the same size}

\item{fig_output_dirname}{output directory}
}
\description{
plot the estimated density om map by species using ggplot2. scale name, plot shape, and size of plot shape can change.
}
