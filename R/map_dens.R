#' Plot the estimated density on map
#'
#' plot the estimated density om map by species using ggplot2. scale name, plot shape, and size of plot shape can change.
#' @param data dataframe made by get_dens function
#' @param region region of the data. please see require(maps) and unique(map_data("world")$region)
#' @param scale_name unit of estimated density
#' @param ncol number of figures in line side by side. max is no. of "Category"
#' @param shape shape of COG point
#' @param size size of shape
#' @param zoom_in_lon zoom in on the map if 1<, zoom out on the map if 1>, and 1 is the same size
#' @param zoom_in_lat zoom in on the map if 1<, zoom out on the map if 1>, and 1 is the same size
#' @param fig_output_dirname output directory
#' @importFrom dplyr filter
#' @importFrom ggplot2 ggsave
#' @import maps
#' @import mapdata
#' @import dplyr
#' @import ggplot2
#' @import magrittr
#'
#' @export
map_dens = function(data, region, scale_name, ncol, shape, size, zoom_in_lon, zoom_in_lat, fig_output_dirname){
  setwd(dir = fig_output_dirname)

  #plot the data from VAST
  if("category_name" %in% names(data)){
    map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
    world_map = map_data("world")
    region2 = subset(world_map, world_map$region == region)
    local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "black", fill = "white") + coord_map(xlim = c(min(data$lon)-1*zoom_in_lon*(-1), max(data$lon)+1*zoom_in_lon*(-1)), ylim = c(min(data$lat)-1*zoom_in_lat*(-1), max(data$lat)+1*zoom_in_lat*(-1)))
    th = theme(panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(),
               axis.text.x = element_blank(),
               axis.text.y = element_blank(),
               axis.title.x = element_text(size = rel(1.5)),
               axis.title.y = element_text(size = rel(1.5)),
               strip.text = element_text(size = rel(1.3)),
               legend.title = element_text(size = 13))

    #single-species
    if(length(unique(data$category)) == 1){
      p = geom_point(data = data, aes(x = lon, y = lat, colour = log_abundance), shape = shape, size = size)
      f = facet_wrap( ~ year, ncol = ncol)
      c =  
      fig = local_map+theme_bw()+th+p+f+c+labs(title = "", x = "Longitude", y = "Latitude", colour = scale_name)
      ggsave(filename = "map_dens.pdf", plot = fig, units = "in", width = 8.27, height = 11.69)
    }else{
      #multi-species
      for(i in 1:length(unique(data$category))){
        data2 = data %>% filter(category == i)
        p = geom_point(data = data2, aes(x = lon, y = lat, colour = log_abundance), shape = shape, size = size)
        f = facet_wrap( ~ year, ncol = ncol)
        c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
        fig = local_map+theme_bw()+th+p+f+c+labs(x = "Longitude", y = "Latitude", colour = scale_name)
        ggsave(filename = paste0("map_dens_", unique(data2$category_name), ".pdf"), plot = fig, units = "in", width = 8.27, height = 11.69)
      }
    }
  }


  #plot the nominal data
  if("Catch_KG" %in% names(data)){
    map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
    world_map = map_data("world")
    region2 = subset(world_map, world_map$region == region)
    local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "black", fill = "white") + coord_map(xlim = c(min(data$lon)-1*zoom_in_lon*(-1), max(data$lon)+1*zoom_in_lon*(-1)), ylim = c(min(data$lat)-1*zoom_in_lat*(-1), max(data$lat)+1*zoom_in_lat*(-1)))
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
    if(!("spp" %in% names(data))){
      p = geom_point(data = data, aes(x = Lon, y = Lat, colour = Catch_KG), shape = shape, size = size)
      f = facet_wrap( ~ Year, ncol = ncol)
      c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
      fig = local_map+theme_bw()+th+p+f+c+labs(title = "", x = "Longitude", y = "Latitude", colour = scale_name)
      ggsave(filename = "map_dens_nominal.pdf", plot = fig, units = "in", width = 8.27, height = 11.69)
    }

    #multi-species
    if("spp" %in% names(data)){
      for(i in 1:length(unique(data$spp))){
        data = data %>% mutate(nspp = as.numeric(spp))
        data2 = data %>% filter(nspp == i)
        p = geom_point(data = data2, aes(x = Lon, y = Lat, colour = Catch_KG), shape = shape, size = size)
        f = facet_wrap( ~ Year, ncol = ncol)
        c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
        fig = local_map+theme_bw()+th+p+f+c+labs(title = "", x = "Longitude", y = "Latitude", colour = scale_name)
        ggsave(filename = paste0("map_dens_nominal_", unique(data2$spp), ".pdf"), plot = fig, units = "in", width = 8.27, height = 11.69)
      }
    }
  }
}
