
# packages ------------------------------------------------------
require(plyr)
require(dplyr)


# please change here --------------------------------------------
vast_output_dirname = "/Users/Yuki/Dropbox/iwac/iwac_MacPro/vast2019-07-19_lnorm_log100sardine"

# load data -----------------------------------------------------
setwd(dir = vast_output_dirname)
DG = read.csv("Data_Geostat_sar.csv")


# make function -------------------------------
# !!! DO NOT CHANGE HERE !!! ------------------------------------
get_cog = function(data){
  #no. of category
  n_spp = length(unique(DG$spp))

  #single-species
  if(n_spp == 1){
    #cog = sum_{year}{Catch_KG*Lon}/sum_{year}{Catch_KG}を計算
    dg = DG %>% select(Catch_KG, Lon, Lat) %>% mutate(cog_lon = Catch_KG*Lon, cog_lat = Catch_KG*Lat)

    lon_nume = ddply(dg, .(Year), summarize, nume = sum(cog_lon))
    lon_deno = ddply(dg, .(Year), summarize, deno = sum(Catch_KG))
    cog_lon = merge(lon_nume, lon_deno, by = "Year") %>% mutate(lon = nume/deno) %>% select(Year, lon)

    lat_nume = ddply(dg, .(Year), summarize, nume = sum(cog_lat))
    lat_deno = ddply(dg, .(Year), summarize, deno = sum(Catch_KG))
    cog_lat = merge(lat_nume, lat_deno, by = "Year") %>% mutate(lat = nume/deno) %>% select(Year, lat)

    cog_nom = merge(cog_lon, cog_lat, by = "Year")
  }

  #multi-species
  if(n_spp != 1){
    #cog = sum_{year}{Catch_KG*Lon}/sum_{year}{Catch_KG}を計算
    dg = DG %>% select(Catch_KG, Lon, Lat) %>% mutate(cog_lon = Catch_KG*Lon, cog_lat = Catch_KG*Lat)

    lon_nume = ddply(df, .(Year, spp), summarize, nume = sum(cog_lon))
    lon_deno = ddply(df, .(Year, spp), summarize, deno = sum(Catch_KG))
    cog_lon = merge(lon_nume, lon_deno, by = c("Year", "spp")) %>% mutate(lon = nume/deno) %>% select(Year, lon, spp)

    lat_nume = ddply(df, .(Year, spp), summarize, nume = sum(cog_lat))
    lat_deno = ddply(df, .(Year, spp), summarize, deno = sum(Catch_KG))
    cog_lat = merge(lat_nume, lat_deno, by = c("Year", spp)) %>% mutate(lat = nume/deno) %>% select(Year, lat, spp)

    cog_nom = merge(cog_lon, cog_lat, by = c("Year", "spp"))
  }
}


# run function and make data-frame ----------------------------------
cog_nom = get_cog(data = DG)
