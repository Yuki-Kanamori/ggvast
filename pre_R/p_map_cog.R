
# packages ------------------------------------------------------
require(rgdal)
require(maps)
require(mapdata)
require(tidyverse)
require(ggplot2)
require(FishStatsUtils)
#require(SpatialDeltaGLMM) #if nedded

# please change here --------------------------------------------
### single species
vast_output_dirname = "///"
data_type = c("VAST", "nominal")[1]
category_name = c("spotted") #カテゴリーの名前（魚種名や銘柄など）　nominalの場合はNULL
unique(map_data("world")$region)
region = "Japan" #作図する地域を選ぶ
ncol = 5 #横にいくつ図を並べるか（最大数 = カテゴリー数）
shape = 16 #16はclosed dot（他はhttps://subscription.packtpub.com/book/big_data_and_business_intelligence/9781788398312/2/ch02lvl1sec16/plotting-a-shape-reference-palette-for-ggplot2を参照）
size = 1.9 #shapeの大きさ
package = c("SpatialDeltaGLMM", "FishStatsUtils")[2]
map_output_dirname = "///"
fileEncoding = "CP932"


# load data -----------------------------------------------------
setwd(dir = vast_output_dirname)
load("Save.RData")
DG = read.csv("Data_Geostat.csv")

# make function -------------------------------
# !!! DO NOT CHANGE HERE !!! ------------------------------------
map_cog = function(data_type, category_name, region, ncol, shape, size, package, map_output_dirname, fileEncoding){

  setwd(dir = map_output_dirname)
  nyear_set = seq(min(DG$Year), max(DG$Year))

  #VAST data
  if(data_type == "VAST"){
    #get the COG information
    if(package == "SpatialDeltaGLMM"){
      COG = SpatialDeltaGLMM::Plot_range_shifts(Report = Save$Report,
                                                TmbData = Save$TmbData,
                                                Sdreport = Save$Opt$SD,
                                                Znames = colnames(Save$TmbData$Z_xm),
                                                PlotDir = vast_output_dirname,
                                                use_biascorr = TRUE,
                                                Year_Set = nyear_set,
                                                category_names = category_name)$COG_Table
    }else{
      COG = FishStatsUtils::plot_range_index(Report = Save$Report,
                                             TmbData = Save$TmbData,
                                             Sdreport = Save$Opt$SD,
                                             Znames = colnames(Save$TmbData$Z_xm),
                                             PlotDir = vast_output_dirname,
                                             use_biascorr = TRUE,
                                             Year_Set = nyear_set,
                                             category_names = category_name)$COG_Table
    }
    setwd(dir = vast_output_dirname)
    write.csv(COG, "COG_Table.csv", fileEncoding = fileEncoding)

    cog = read.csv("COG_Table.csv")

    #UTM to longitude and latitude
    #year_set = DG %>% select(Year) %>% distinct(Year, .keep_all = T)
    tag = data.frame(rep(min(DG$Year):max(DG$Year), each = length(category_name)))
    #tag = data.frame(rep(year_set, each = length(category_name)))
    tag$Category = rep(category_name)
    colnames(tag) = c("Year", "Category")

    if(length(unique(category_name)) == 1){
      cog = cbind(cog, Category = category_name)
    }

    head(cog)
    head(tag)
    cog = merge(cog, tag, by = c("Category", "Year"))

    lat = cog[cog$m == 1, ]
    lon = cog[cog$m == 2, ]
    x = lat$COG_hat*1000
    y = lon$COG_hat*1000
    xy = cbind(x,y)
    zone = unique(DG$zone)
    lonlat = data.frame(project(xy, paste0("+proj=utm +zone=", zone, " ellps=WGS84"), inv = TRUE))
    colnames(lonlat) = c("lon", "lat")
    lonlat = cbind(lonlat, lat[, c("Year", "Category")])


    #make COG maps
    setwd(dir = map_output_dirname)
    map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
    world_map = map_data("world")
    region2 = subset(world_map, world_map$region == region)
    local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "black", fill = "white") + coord_map(xlim = c(min(lonlat$lon)-1, max(lonlat$lon)+1), ylim = c(min(lonlat$lat)-1, max(lonlat$lat)+1))
    th = theme(panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(),
               axis.text.x = element_text(size = rel(1.5)),
               axis.text.y = element_text(size = rel(1.5)),
               axis.title.x = element_text(size = rel(1.5)),
               axis.title.y = element_text(size = rel(1.5)),
               legend.title = element_text(size = 13))
    p = geom_point(data = lonlat, aes(x = lon, y = lat, colour = Year), shape = shape, size = size)
    f = facet_wrap( ~ Category, ncol = ncol)
    c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
    labs = labs(x = "Longitude", y = "Latitude", colour = "Year")

    if(length(unique(category_name)) == 1){
      fig = local_map+theme_bw()+th+p+c+labs
    }else{
      fig = local_map+theme_bw()+th+p+f+c+labs
    }
    ggsave(filename = "map_cog.pdf", plot = fig, units = "in", width = 11.69, height = 8.27)
  }




  #nominal data
  if(data_type == "nominal"){
    #make COG maps
    map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
    world_map = map_data("world")
    region2 = subset(world_map, world_map$region == region)
    local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "black", fill = "white") + coord_map(xlim = c(min(cog_nom$lon)-1, max(cog_nom$lon)+1), ylim = c(min(cog_nom$lat)-1, max(cog_nom$lat)+1))
    th = theme(panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(),
               axis.text.x = element_text(size = rel(1.5), angle = 90),
               axis.text.y = element_text(size = rel(1.5)),
               axis.title.x = element_text(size = rel(1.5)),
               axis.title.y = element_text(size = rel(1.5)),
               legend.title = element_text(size = 13))
    p = geom_point(data = cog_nom, aes(x = lon, y = lat, colour = Year), shape = shape, size = size)
    f = facet_wrap( ~ spp, ncol = ncol)
    c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
    labs = labs(x = "Longitude", y = "Latitude", colour = "Year")

    if(!("spp" %in% names(cog_nom))){
      fig_nom =local_map+theme_bw()+th+p+c+labs
    }else{
      fig_nom = local_map+theme_bw()+th+p+f+c+labs
    }
    ggsave(filename = "map_cog_nominal.pdf", plot = fig_nom, units = "in", width = 8.27, height = 11.69)
  }
}


# run function and make figures ----------------------------------
map_cog(data_type = data_type,
        category_name = category_name,
        region = region,
        ncol = ncol,
        shape = shape,
        size = size,
        package = package,
        map_output_dirname = map_output_dirname,
        fileEncoding = fileEncoding)
