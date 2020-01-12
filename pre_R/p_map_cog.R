vast_output_dirname = ##
setwd(dir = vast_output_dirname)
load("Save.RData")
DG = read.csv("Data_Geostat_sar.csv")

map_cog = function(category_name, zone, region, labs, ncol, shape, size, package){
  #make a COG_Table using VAST package
  #re-make default figures of COG and Effective Area
  if(package == "SpatialDeltaGLMM"){
    require(SpatialDeltaGLMM)
    cog = SpatialDeltaGLMM::Plot_range_shifts(Report = Save$Report,
                                              TmbData = Save$TmbData,
                                              Sdreport = Save$Opt$SD,
                                              Znames = colnames(Save$TmbData$Z_xm),
                                              PlotDir = DateFile,
                                              use_biascorr = TRUE,
                                              Year_Set = year_set,
                                              category_names = category_name)$COG_Table
  }else{
    cog = FishStatsUtils::plot_range_index(Report = Save$Report,
                                           TmbData = Save$TmbData,
                                           Sdreport = Save$Opt$SD,
                                           Znames = colnames(Save$TmbData$Z_xm),
                                           PlotDir = DateFile,
                                           use_biascorr = TRUE,
                                           Year_Set = year_set,
                                           category_names = category_name)$COG_Table
  }

  #from UTM to longitude and latitude
  year_set = DG %>% select(Year) %>% distinct(Year, .keep_all = T)
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

  #make COG maps
  map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
  world_map = map_data("world")
  region2 = subset(world_map, world_map$region == region)
  local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "gray 50", fill = "gray 50") + coord_map(xlim = c(min(data$lon)-1, max(data$lon)+1), ylim = c(min(data$lat)-1, max(data$lat)+1))
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
    local_map+theme_bw()+th+p+c+labs
  }else{
    local_map+theme_bw()+th+p+f+c+labs
  }
}

