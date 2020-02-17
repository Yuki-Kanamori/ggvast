#' Plot the COG on map from VAST output
#'
#' plot the COG om map using ggplot2. category names, axis names, font size and plot shape can change.
#' @param data_type VAST ot nomical
#' @param category_name names of each category
#' @param region region of the data. please see require(maps) and unique(map_data("world")$region)
#' @param ncol number of figures in line side by side. max is no. of "Category"
#' @param shape shape of COG point
#' @param size size of shape
#' @param fig_output_dirname directory for output
#' @importFrom dplyr distinct
#' @importFrom dplyr select
#' @importFrom rgdal project
#' @import TMB
#' @import magrittr
#' @import maps
#' @import mapdata
#' @import ggplot2
#' @import rgdal
#'
#' @export


map_cog = function(data_type, category_name, region, ncol, shape, size, fig_output_dirname){
  if(data_type == "VAST"){
    # make COG Table
    ### this code is from plot_range_index() in FishStatsUtils ###
    Sdreport = Save[["Opt"]][["SD"]]
    if("ln_Index_cyl" %in% rownames(TMB::summary.sdreport(Sdreport))){
      # VAST Version >= 2.0.0
      CogName = "mean_Z_cym"
      EffectiveName = "effective_area_cyl"
      Save[["TmbData"]][["n_t"]] = nrow(Save[["TmbData"]][["t_yz"]])
    }else{
      message("not available because this function does not match your VAST version (VAST Version >= 2.0.0 is needed)")
    }

    Year_Set = 1:Save$TmbData$n_t
    Years2Include = 1:Save$TmbData$n_t
    strata_names = 1:Save$TmbData$n_l
    category_names = 1:Save$TmbData$n_c
    Return = list( "Year_Set"=Year_Set )

    SD = TMB::summary.sdreport(Sdreport)
    SD_mean_Z_ctm = array( NA, dim=c(unlist(Save$TmbData[c('n_c','n_t','n_m')]),2), dimnames=list(NULL,NULL,NULL,c('Estimate','Std. Error')) )
    #use_biascorr = TRUE
    if( use_biascorr==TRUE && "unbiased"%in%names(Sdreport) ){
      SD_mean_Z_ctm[] = SD[which(rownames(SD)==CogName),c('Est. (bias.correct)','Std. Error')]
    }
    if( !any(is.na(SD_mean_Z_ctm)) ){
      message("Using bias-corrected estimates for center of gravity...")
    }else{
      message("Not using bias-corrected estimates for center of gravity...")
      SD_mean_Z_ctm[] = SD[which(rownames(SD)==CogName),c('Estimate','Std. Error')]
    }

    COG_Table = NULL
    for( cI in 1:Save$TmbData$n_c ){
      for( mI in 1:dim(SD_mean_Z_ctm)[[3]]){
        Tmp = cbind("m"=mI, "Year"=Year_Set, "COG_hat"=SD_mean_Z_ctm[cI,,mI,'Estimate'], "SE"=SD_mean_Z_ctm[cI,,mI,'Std. Error'])
        if( Save$TmbData$n_c>1 ) Tmp = cbind( "Category"=category_names[cI], Tmp)
        COG_Table = rbind(COG_Table, Tmp)
      }}
    ### end the code form plot_range_index() in FishStatsUtils ###

    #UTM to longitude and latitude
    #year_set = DG %>% select(Year) %>% distinct(Year, .keep_all = T)
    #cog = read.csv("COG_Table.csv")
    cog = COG_Table
    nyear_set = seq(min(DG$Year), max(DG$Year))
    tag = data.frame(Year = rep(1:length(unique(DG$Year))), Year2 = rep(min(DG$Year):max(DG$Year), each = length(category_name)), Category = rep(category_name))

    if(length(unique(category_name)) == 1){
      cog = cog %>% data.frame() %>% mutate(Category = category_name)
      cog = merge(cog, tag, by = c("Category", "Year")) %>% arrange(Year)
    }else{
      cog = cog %>% data.frame()
      tag2 = data.frame(ncate = unique(cog$Category), Category = category_name)
      cog = cog %>% rename(ncate = Category)
      cog = merge(cog, tag2, by = "ncate")
      cog = merge(cog, tag, by = c("Category", "Year")) %>% arrange(Year)
    }



    lat = cog[cog$m == 1, ]
    lon = cog[cog$m == 2, ]
    x = lat$COG_hat*1000
    y = lon$COG_hat*1000
    xy = cbind(x,y)
    zone = unique(DG$zone)
    lonlat = data.frame(project(xy, paste0("+proj=utm +zone=", zone, " ellps=WGS84"), inv = TRUE))
    colnames(lonlat) = c("lon", "lat")

    lonlat = cbind(lonlat, lat[, c("Year", "Category")])
    lonlat = merge(lonlat, tag, by = c("Category", "Year"))


    #make COG maps
    setwd(dir = fig_output_dirname)
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
    p = geom_point(data = lonlat, aes(x = lon, y = lat, colour = Year2), shape = shape, size = size)
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
               axis.text.x = element_text(size = rel(1.5)),
               axis.text.y = element_text(size = rel(1.5)),
               axis.title.x = element_text(size = rel(1.5)),
               axis.title.y = element_text(size = rel(1.5)),
               legend.title = element_text(size = 13))
    p = geom_point(data = cog_nom, aes(x = lon, y = lat, colour = Year), shape = shape, size = size)
    f = facet_wrap( ~ spp, ncol = ncol)
    c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
    labs = labs(x = "Longitude", y = "Latitude", colour = "Year")

    if(length(unique(cog_nom$spp)) == 1){
      fig_nom =local_map+theme_bw()+th+p+c+labs
    }else{
      fig_nom = local_map+theme_bw()+th+p+f+c+labs
    }
    ggsave(filename = "map_cog_nominal.pdf", plot = fig_nom, units = "in", width = 8.27, height = 11.69)
  }
}
