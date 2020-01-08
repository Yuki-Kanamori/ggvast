vast_output_dirname =
category_name =

get_dens = function(vast_output_dirname, ){
  setwd(dir = vast_dirname)
  load("Save.RData")
  Year = read.csv("Data_Geostat.csv") %>% select(Year) %>% distinct(Year, .keep_all = T)
  DG = read.csv("Data_Geostat.csv") %>% distinct(knot_i, Lon, Lat, .keep_all = T) %>% select(Lon, Lat, knot_i)

  #estimated density
  est_d = c()
  if("D_xt" %in% names(Save$Report)){ #SpatialDeltaGLMM
    for(i in 1:n_c){
      temp = log(Save$Report$D_xt[,i,])
      est_d = rbind(est_d, temp)
    }
  }
  if("D_xct" %in% names(Save$Report)){ #VAST Version < 2.0.0
    for(i in 1:n_c){
      temp = log(Save$Report$D_xct[,i,])
      est_d = rbind(est_d, temp)
    }
  }
  if("D_xcy" %in% names(Save$Report)){ #VAST Version >= 2.0.0
    for(i in 1:n_c){
      temp = log(Save$Report$D_xcy[,i,])
      est_d = rbind(est_d, temp)
    }
  }
  est_d = data.frame(est_d)

  est_d = est_d %>% mutate(knot_i = rep(1:n_x, n_c), category = rep(1:n_c, each = n_x))
  est_d = est_d %>% tidyr::gather(key = x_year, value = log_abundance, 1:n_t)
  tag = data_frame(x_year = paste0("X", rep(1:n_t)), year = rep(min(Year$Year):max(Year$Year)))
  est_d = merge(est_d, tag, by = "x_year")

  #add latitude/longitude information to estimated density
  DG = read.csv("Data_Geostat.csv") %>% distinct(knot_i, Lon, Lat, .keep_all = T) %>% select(Lon, Lat, knot_i)
  DG = merge(DG, est_d, by = "knot_i") %>% select(-x_year)
}
test = get_dens()
