
# packages ------------------------------------------------------
require(maps)
require(mapdata)
require(dplyr)
require(ggplot2)


# load data (nominal) -----------------------------------------------------
vast_output_dirname = "///"
setwd(dir = vast_output_dirname)
load("Save.RData")
DG = read.csv("Data_Geostat.csv")
#DG = DG %>% filter(Catch_KG > 0) #> 0データのみをプロットしたい場合

# please change here --------------------------------------------
data = df_dens #VASTの結果ならdf_dens　ノミナルならDG = read.csv("Data_Geostat.csv")
unique(map_data("world")$region)
region = "Japan" #作図する地域を選ぶ
scale_name = "Log density" #凡例　色の違いが何を表しているのかを書く
ncol = 5 #横にいくつ図を並べるか（最大数 = 年数）
shape = 16 #16はclosed dot（他はhttps://subscription.packtpub.com/book/big_data_and_business_intelligence/9781788398312/2/ch02lvl1sec16/plotting-a-shape-reference-palette-for-ggplot2を参照）
size = 1.9 #shapeの大きさ
map_output_dirname = "///"

# make function -------------------------------
# !!! DO NOT CHANGE HERE !!! ------------------------------------
map_dens = function(data, region, scale_name, ncol, shape, size, map_output_dirname){
  setwd(dir = map_output_dirname)

  #plot the data from VAST
  if("category_name" %in% names(data)){
    map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
    world_map = map_data("world")
    region2 = subset(world_map, world_map$region == region)
    local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "black", fill = "white") + coord_map(xlim = c(min(data$lon)-1, max(data$lon)+1), ylim = c(min(data$lat)-1, max(data$lat)+1))
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
      c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
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
    local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "black", fill = "white") + coord_map(xlim = c(min(data$Lon)-1, max(data$Lon)+1), ylim = c(min(data$Lat)-1, max(data$Lat)+1))
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


# run function and make figures ----------------------------------
map_dens(data = data,
         region = region,
         scale_name = scale_name,
         ncol = ncol,
         shape = shape,
         size = size,
         map_output_dirname =  map_output_dirname)
