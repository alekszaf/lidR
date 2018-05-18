#' Find the flighlines hulls
#'
#' Find the flightline hulls from a catalog. The function works only if the field 'PointSourceID'
#' is properly populated. The function first load a random fraction of the catalog then compute a concave
#' hull for each flighline. Flighline are expected to be recorded in 'PointSourceID'. If not the function
#' will run anyway but will find a single flighline being the whole dataset itself.
#'
#' The concave hull method under the hood is described in Park & Oh (2012). The function relies on
#' the \link[concaveman:concaveman]{concaveman} function which itself is a wrapper around the
#' \href{https://github.com/mapbox/concaveman}{Vladimir Agafonking's implementation}.
#'
#' @param ctg A \link[lidR:catalog]{LAScatalog} object.
#' @param concavity numeric. If \code{type = "concave"}, a relative measure of concavity. 1 results
#' in a relatively detailed shape, Infinity results in a convex hull.
#' @param length_threshold numeric. If \code{type = "concave"}, when a segment length is under this
#' threshold, it stops being considered for further detalization. Higher values result in simpler shapes.
#' @param density numeric. To compute the concave hull of each flighline in a reasonnable timeframe and using
#' a little amount of memory, only a random fraction is loaded. This random fraction represent this number
#' a point per square unit. Default is 0.1 i.e. approximately 0.1 pt per square meter. This is enought
#' to get a fairly accurate hulls.
#' @return A \code{SpatialPolygonDataFrame}.
#' @export
#'
#' @examples
#' \dontrun{
#' # Using file for which the PointSourceID is properly populated
#' ctg = catalog("folder/")
#'
#' flightlines =  catalog_flightlines(ctg)
#'
#' col = adjustcolor(col = rainbow(length(flightlines)), alpha.f = 0.6)
#' sp::plot(flightlines, col = col)
#' }
catalog_flightlines = function(ctg, concavity = 2, length_threshold = 50, density = 0.1)
{
  message("This is un experimental function. User should check twice the output!")

  npoints  <- sum(ctg@data$`Number of point records`)
  surface  <- area(ctg)
  pdensity <- npoints/surface
  fraction <- round(density/pdensity,3)

  filter = paste("-keep_random_fraction", fraction)
  las = suppressWarnings(readLAS(ctg, select = "xyzp", filter = "-keep_random_fraction 0.01"))
  spdf = tree_hulls(las, "concave", concavity, length_threshold, field = "PointSourceID")

  return(spdf)
}
