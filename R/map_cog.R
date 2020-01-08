#' Plot the COG on map from VAST outputs
#'
#' @param category_name names of each category. set 1 when single-species model
#' @param zone no. of UTM which was estimated when "Extrapolation_List" was made
#' @param labs setting of figure. colour is legend
#' @param ncol number of figures in line side by side. max is no. of "Category"
#' @param shape shape of COG point
#' @param size size of shape
#' @param DateFile necessary to make a COG_Table using VAST
#' @param package Spatial DeltaGLMM or FishStatsUtils
#' @param fileEncoding endoding
#'
#' @examples
#' map_cog(pcategory_name, zone, labs, ncol, shape, size, DateFile, package, fileEncoding)
#' @export


# make a COG_Table and maps of COG ------------------------------
map_cog = function(pcategory_name, zone, labs, ncol, shape, size, DateFile, package, fileEncoding){
  #load Save.RData estimated by VAST
  setwd(dir = dirname)
  load("Save.RData")
  DateFile = dirname

  #make a COG_Table using VAST package
  #!! re-make default figures of COG and Effective Area !!
  if(package == "SpatialDeltaGLMM"){
    require(SpatialDeltaGLMM)
    COG = SpatialDeltaGLMM::Plot_range_shifts(Report = Save$Report,
                                              TmbData = Save$TmbData,
                                              Sdreport = Save$Opt$SD,
                                              Znames = colnames(Save$TmbData$Z_xm),
                                              PlotDir = DateFile,
                                              use_biascorr = TRUE,
                                              Year_Set = year_set,
                                              category_names = category_name)$COG_Table
  }else{
    COG = FishStatsUtils::plot_range_index(Report = Save$Report,
                                           TmbData = Save$TmbData,
                                           Sdreport = Save$Opt$SD,
                                           Znames = colnames(Save$TmbData$Z_xm),
                                           PlotDir = DateFile,
                                           use_biascorr = TRUE,
                                           Year_Set = year_set,
                                           category_names = category_name)$COG_Table
  }

  write.csv(COG, "COG_Table.csv", fileEncoding = fileEncoding)

  #from UTM to longitude and latitude
  cog = read.csv("COG_Table.csv", fileEncoding = fileEncoding)

  tag = data.frame(rep(year_set, each = length(category_name)))
  tag$Category = rep(category_name)
  colnames(tag) = c("Year", "Category")
  #tag$Category = factor(tag$Category, levels = category_name)
  #levels(tag$Category)
  if(category_name == 1){
    cog$Category = 1
  }

  cog = merge(cog, tag, by = c("Category", "Year"))

  lat = cog[cog$m == 1, ]
  lon = cog[cog$m == 2, ]
  x = lat$COG_hat*1000
  y = lon$COG_hat*1000
  xy = cbind(x,y)
  lonlat = data.frame(project(xy, paste0("+proj=utm +zone=", zone, " ellps=WGS84"), inv = TRUE))
  colnames(lonlat) = c("lon", "lat")
  lonlat = cbind(lonlat, lat[, c("Year", "Category")])
  lonlat$Category = factor(lonlat$Category, levels = category_name)
  levels(lonlat$Category)

  #make COG maps
  map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
  world_map = map_data("world")
  jap = subset(world_map, world_map$region == "Japan")
  jap_map = map + geom_polygon(data = jap, aes(x = long, y = lat, group = group), colour = "gray 50", fill = "gray 50") + coord_map(xlim = c(min(lonlat$lon)-1, max(lonlat$lon)+1), ylim = c(min(lonlat$lat)-1, max(lonlat$lat)+1))
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
  if(category_name == 1){
    jap_map+theme_bw()+th+p+c+labs
  }else{
    jap_map+theme_bw()+th+p+f+c+labs
  }
}
