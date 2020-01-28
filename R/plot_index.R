#' Compare the nominal and standardized index
#'
#' make a figure
#' @param vast_index Standardized data
#' @param DG nominal data
#' @param category_name category name
#' @param fig_output_dirname directory for output figure
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom plyr ddply
#' @importFrom magrittr %>%
#' @importFrom plyr .
#' @import magrittr
#' @import ggplot2
#' @export


plot_index = function(vast_index, DG, category_name, fig_output_dirname){
  #single-species
  if(!("spp" %in% names(DG))){
    #calculate confidence interval
    trend = c()
    vast_index = vast_index %>% mutate(ntype = as.numeric(as.factor(type)))
    for(i in 1:length(unique(vast_index$ntype))){
      data = vast_index %>% filter(ntype == i)

      data = data %>% mutate(scaled = Estimate_metric_tons/mean(Estimate_metric_tons))
      conf = exp(qnorm(0.975)*sqrt(log(1+(data$SD_log)^2)))
      data = data %>% mutate(kukan_u = data$scaled*conf, kukan_l = data$scaled/conf)
      data = data %>% mutate(kukan_u2 = abs(scaled - kukan_u), kukan_l2 = scaled - kukan_l)

      trend = rbind(trend, data)
    }
    trend = trend %>% select(Year, kukan_u2, kukan_l2, type, scaled)

    #normarize and calculate confidence interval
    nominal = ddply(DG, .(Year), summarize, mean = mean(Catch_KG))
    nominal = nominal %>% mutate(scaled = nominal$mean/mean(nominal$mean), type = "Nominal", kukan_u2 = NA, kukan_l2 = NA)
    nominal = nominal %>% select(Year, kukan_u2, kukan_l2, type, scaled)
    trend = rbind(trend, nominal)

    #plot
    # figure --------------------------------------------------------
    g = ggplot(trend, aes(x = Year, y = scaled, colour = type))
    pd = position_dodge(.3)
    p = geom_point(size = 4, aes(colour = type), position = pd)
    e = geom_errorbar(aes(ymin = scaled - kukan_l2, ymax = scaled + kukan_u2), width = 0.3, size = .7, position = pd)
    l = geom_line(aes(colour = type), size = 1.5, position = pd)
    lb = labs(x = "Year", y = "Index", color = "Model")
    th = theme(#legend.position = c(0.18, 0.8),
      axis.text.x = element_text(size = rel(1.5)), #x軸メモリ
      axis.text.y = element_text(size = rel(1.5)), #y軸メモリ
      axis.title.x = element_text(size = rel(1.5)), #x軸タイトル
      axis.title.y = element_text(size = rel(1.5)),
      legend.title = element_text(size = rel(1.5)), #凡例タイトル
      legend.text = element_text(size = rel(1.5)),
      strip.text = element_text(size = rel(1.3)), #ファセットのタイトル
      plot.title = element_text(size = rel(1.5))) #タイトル
    fig = g+p+e+l+lb+theme_bw()+th
    setwd(dir = fig_output_dirname)
    ggsave(filename = "index.pdf", plot = fig, units = "in", width = 8.27, height = 11.69)

  }else{

    #multi-species
    trend = c()
    vast_index = vast_index %>% mutate(ntype = as.numeric(as.factor(type)))

    for(j in 1:length(unique(vast_index$Category))){
      #j = 1
      data = vast_index %>% filter(Category == j)

      #calculate confidence interval
      for(i in 1:length(unique(vast_index$ntype))){
        #i = 1
        data = vast_index %>% filter(ntype == i)

        data = data %>% mutate(scaled = Estimate_metric_tons/mean(Estimate_metric_tons))
        conf = exp(qnorm(0.975)*sqrt(log(1+(data$SD_log)^2)))
        data = data %>% mutate(kukan_u = data$scaled*conf, kukan_l = data$scaled/conf)
        data = data %>% mutate(kukan_u2 = abs(scaled - kukan_u), kukan_l2 = scaled - kukan_l)

        trend = rbind(trend, data)
      }
    }
    trend = trend %>% select(Year, kukan_u2, kukan_l2, type, scaled, Category)
    tag = data.frame(Category = unique(trend$Category), category2 = category_name)
    trend = merge(trend, tag, by = "Category")

    #normarize and calculate confidence interval
    DG2 = ddply(DG, .(Year, spp), summarize, mean = mean(Catch_KG))
    DG2 = DG2 %>% mutate(nspp = as.numeric(as.factor(spp)))
    #こっから変
    nominal = c()
    for(i in 1:length(unique(DG2$spp))){
      data2 = DG2 %>% filter(nspp == i)
      data2 = data2 %>% mutate(scaled = data2$mean/mean(data2$mean), type = "Nominal", kukan_u2 = NA, kukan_l2 = NA)
      data2 = data2 %>% select(Year, kukan_u2, kukan_l2, type, scaled, nspp)

      nominal = rbind(nominal, data2)
    }
    nominal = nominal %>% dplyr::rename(Category = nspp)
    nominal = merge(nominal, tag, by = "Category")
    trend = rbind(trend, nominal)

    #plot
    # figure --------------------------------------------------------
    g = ggplot(trend, aes(x = Year, y = scaled, colour = type))
    pd = position_dodge(.3)
    p = geom_point(size = 4, aes(colour = type), position = pd)
    e = geom_errorbar(aes(ymin = scaled - kukan_l2, ymax = scaled + kukan_u2), width = 0.3, size = .7, position = pd)
    l = geom_line(aes(colour = type), size = 1.5, position = pd)
    f = facet_wrap(~ category2, ncol = 1)
    lb = labs(x = "Year", y = "Index", color = "Model")
    th = theme(#legend.position = c(0.18, 0.8),
      axis.text.x = element_text(size = rel(1.5)), #x軸メモリ
      axis.text.y = element_text(size = rel(1.5)), #y軸メモリ
      axis.title.x = element_text(size = rel(1.5)), #x軸タイトル
      axis.title.y = element_text(size = rel(1.5)),
      legend.title = element_text(size = rel(1.5)), #凡例タイトル
      legend.text = element_text(size = rel(1.5)),
      strip.text = element_text(size = rel(1.3)), #ファセットのタイトル
      plot.title = element_text(size = rel(1.5))) #タイトル
    fig = g+p+e+l+f+lb+theme_bw()+th
    setwd(dir = fig_output_dirname)
    ggsave(filename = "index.pdf", plot = fig, units = "in", width = 8.27, height = 11.69)
  }
  message("no problem if you get warning message about geom_errorbar, because Nominal has no error bars")
}
