#' Plot the estimated density on map
#'
#' plot the estimated density om map by species using ggplot2. scale name, plot shape, and size of plot shape can change.
#' @param data dataframe made by get_dens function
#' @param region region of the data.
#' @param scale_names unit of estimated density
#' @param ncol number of figures in line side by side. max is no. of "Category"
#' @param shape shape of COG point
#' @param size size of shape
#' @importForm magrittr %>%
#' @importFrom dplyr filter
#' @importFrom ggplot2 ggsave
#' @import maps
#' @import mapdata
#' @import ggplot2
#' @import magrittr
#'
#' @export

map_dens = function(data, region, scale_name, ncol, shape, size){
  map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
  world_map = map_data("world")
  region2 = subset(world_map, world_map$region == region)
  local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "gray 50", fill = "gray 50") + coord_map(xlim = c(min(data$lon)-1, max(data$lon)+1), ylim = c(min(data$lat)-1, max(data$lat)+1))
  th = theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             #axis.text.x = element_text(size = rel(0.7), angle = 90),
             axis.text.x = element_blank(),
             #axis.text.y = element_text(size = rel(0.7)),
             axis.text.y = element_blank(),
             axis.title.x = element_text(size = rel(1.5)),
             axis.title.y = element_text(size = rel(1.5)),
             strip.text = element_text(size = rel(1.3)),
             legend.title = element_text(size = 13))

  #single-species
  if(length(unique(data$category)) == 1){
    p = geom_point(data = data, aes(x = lon, y = lat, colour = log_abundance), shape = shape, size = size)
    f = facet_wrap( ~ year, ncol = ncol)
    c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
    fig = local_map+theme_bw()+th+p+f+c+labs(title = "", x = "Longitude", y = "Latitude", colour = scale_name)
    #ggsave(fig, )
  }

  #multi-species
  if(length(unique(data$category)) != 1){
    for(i in 1:length(data$category)){
      data2 = data %>% filter(category == 1)
      p = geom_point(data = data2, aes(x = lon, y = lat, colour = log_abundance), shape = shape, size = size)
      f = facet_wrap( ~ year, ncol = ncol)
      c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
      fig = local_map+theme_bw()+th+p+f+c+labs(title = paste(unique(data2$category_name)), x = "Longitude", y = "Latitude", colour = scale_name)
      #ggsave(fig, )
    }
  }
}
