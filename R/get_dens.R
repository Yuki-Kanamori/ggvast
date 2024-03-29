#' Get the estimated density in each knot and make dataframe
#'
#' Get the estimated density in each knot from Save.RData.
#' @param category_name category name
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr distinct
#' @importFrom dplyr select
#' @importFrom tidyr gather
#' @importFrom magrittr %>%
#' @import magrittr
#' @export

get_dens = function(category_name){
  options(warn = -1)

  n_c = Save$TmbData$n_c #category (month)
  n_t = Save$TmbData$n_t #year
  n_x = Save$TmbData$n_x #knot

  if (is.null(n_x)) n_x = Save$TmbData$n_g

  year_set = DG %>% select(Year) %>% distinct(Year, .keep_all = T)
  latlon_list = DG %>% distinct(knot_i, Lon, Lat, .keep_all = T) %>% select(Lon, Lat, knot_i)

  # get estimated density from Save.RData
  # memo: add if() in reference to FishStatsUtils::plot_maps()
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
  if ("D_gcy" %in% names(Save$Report)) { # VAST Version 8.0.0 through 9.3.0
    for (i in 1:n_c) {
      temp = log(Save$Report$D_gcy[, i, ])
      est_d = rbind(est_d, temp)
    }
  }
  if ("D_gct" %in% names(Save$Report)) { # VAST Version >= 6.4.0
    for (i in 1:n_c) {
      temp = log(Save$Report$D_gct[, i, ])
      est_d = rbind(est_d, temp)
    }
  }

  est_d = data.frame(est_d)

  est_d = est_d %>% mutate(knot_i = rep(1:n_x, n_c), category = rep(1:n_c, each = n_x))
  est_d = est_d %>% tidyr::gather(key = x_year, value = log_abundance, 1:n_t)
  tag = data_frame(x_year = paste0("X", rep(1:n_t)), year = rep(min(year_set$Year):max(year_set$Year)))
  est_d = merge(est_d, tag, by = "x_year")

  #add latitude/longitude information
  df = merge(latlon_list, est_d, by = "knot_i") %>% select(-x_year)
  df = df %>% dplyr::rename(lat = Lat, lon = Lon)

  tag2 = data_frame(category_name = category_name, category = rep(1:length(category_name)))
  df = merge(df, tag2, by = "category") %>% arrange(knot_i, year, category, lat, lon)
}
