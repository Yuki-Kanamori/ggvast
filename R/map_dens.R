#' Plot the estimated density on map
#'
#' plot the estimated density om map by species using ggplot2. scale name, plot shape, and size of plot shape can change.
#' @param data dataframe made by get_dens function
#' @param region region of the data
#' \describe{
#'   \item{[1] "Aruba", "Afghanistan", "Angola"}
#'   \item{[4] "Anguilla", "Albania", "Finland"}
#'   \item{[7] "Andorra", "United Arab Emirates", "Argentina"}
#'   \item{[10] "Armenia", "American Samoa", "Antarctica"}
#'   \item{[13] "Australia", "French Southern and Antarctic Lands", "Antigua"}
#'   \item{[16] "Barbuda", "Austria", "Azerbaijan"}
#'   \item{[19] "Burundi", "Belgium", "Benin"}
#'   \item{[22] "Burkina Faso", "Bangladesh", "Bulgaria"}
#'   \item{[25] "Bahrain", "Bahamas", "Bosnia and Herzegovina"}
#'   \item{[28] "Saint Barthelemy", "Belarus", "Belize"}
#'   \item{[31] "Bermuda", "Bolivia", "Brazil"}
#'   \item{[34] "Barbados", "Brunei", "Bhutan"}
#'   \item{[37] "Botswana", "Central African Republic", "Canada"}
#'   \item{[40] "Switzerland", "Chile", "China"}
#'   \item{[43] "Ivory Coast", "Cameroon", "Democratic Republic of the Congo"}
#'   \item{[46] "Republic of Congo", "Cook Islands", "Colombia"}
#'   \item{[49] "Comoros", "Cape Verde", "Costa Rica"}
#'   \item{[52] "Cuba", "Curacao", "Cayman Islands"}
#'   \item{[55] "Cyprus", "Czech Republic", "Germany"}
#'   \item{[58] "Djibouti", "Dominica", "Denmark"}
#'   \item{[61] "Dominican Republic", "Algeria", "Ecuador"}
#'   \item{[64] "Egypt", "Eritrea", "Canary Islands"}
#'   \item{[67] "Spain", "Estonia", "Ethiopia"}
#'   \item{[70] "Fiji", "Falkland Islands", "Reunion"}
#'   \item{[73] "Mayotte", "French Guiana", "Martinique"}
#'   \item{[76] "Guadeloupe", "France", "Faroe Islands"}
#'   \item{[79] "Micronesia", "Gabon", "UK"}
#'   \item{[82] "Georgia", "Guernsey", "Ghana"}
#'   \item{[85] "Guinea", "Gambia", "Guinea-Bissau"}
#'   \item{[88] "Equatorial Guinea", "Greece", "Grenada"}
#'   \item{[91] "Greenland", "Guatemala", "Guam"}
#'   \item{[94] "Guyana", "Heard Island", "Honduras"}
#'   \item{[97] "Croatia", "Haiti", "Hungary"}
#'   \item{[100] "Indonesia", "Isle of Man", "India"}
#'   \item{[103] "Cocos Islands", "Christmas Island", "Chagos Archipelago"}
#'   \item{[106] "Ireland", "Iran", "Iraq"}
#'   \item{[109] "Iceland", "Israel", "Italy"}
#'   \item{[112] "San Marino", "Jamaica", "Jersey"}
#'   \item{[115] "Jordan", "Japan", "Siachen Glacier"}
#'   \item{[118] "Kazakhstan", "Kenya", "Kyrgyzstan"}
#'   \item{[121] "Cambodia", "Kiribati", "Nevis"}
#'   \item{[124] "Saint Kitts", "South Korea", "Kosovo"}
#'   \item{[127] "Kuwait", "Laos", "Lebanon"}
#'   \item{[130] "Liberia", "Libya", "Saint Lucia"}
#'   \item{[133] "Liechtenstein", "Sri Lanka", "Lesotho"}
#'   \item{[136] "Lithuania", "Luxembourg", "Latvia"}
#'   \item{[139] "Saint Martin", "Morocco", "Monaco"}
#'   \item{[142] "Moldova", "Madagascar", "Maldives"}
#'   \item{[145] "Mexico", "Marshall Islands", "Macedonia"}
#'   \item{[148] "Mali", "Malta", "Myanmar"}
#'   \item{[151] "Montenegro", "Mongolia", "Northern Mariana Islands"}
#'   \item{[154] "Mozambique", "Mauritania", "Montserrat"}
#'   \item{[157] "Mauritius", "Malawi", "Malaysia"}
#'   \item{[160] "Namibia", "New Caledonia", "Niger"}
#'   \item{[163] "Norfolk Island", "Nigeria", "Nicaragua"}
#'   \item{[166] "Niue", "Bonaire", "Sint Eustatius"}
#'   \item{[169] "Saba", "Netherlands", "Norway"}
#'   \item{[172] "Nepal", "Nauru", "New Zealand"}
#'   \item{[175] "Oman", "Pakistan", "Panama"}
#'   \item{[178] "Pitcairn Islands", "Peru", "Philippines"}
#'   \item{[181] "Palau", "Papua New Guinea", "Poland"}
#'   \item{[184] "Puerto Rico", "North Korea", "Madeira Islands"}
#'   \item{[187] "Azores", "Portugal", "Paraguay"}
#'   \item{[190] "Palestine", "French Polynesia", "Qatar"}
#'   \item{[193] "Romania", "Russia", "Rwanda"}
#'   \item{[196] "Western Sahara", "Saudi Arabia", "Sudan"}
#'   \item{[199] "South Sudan", "Senegal", "Singapore"}
#'   \item{[202] "South Sandwich Islands", "South Georgia", "Saint Helena"}
#'   \item{[205] "Ascension Island", "Solomon Islands", "Sierra Leone"}
#'   \item{[208] "El Salvador", "Somalia", "Saint Pierre and Miquelon"}
#'   \item{[211] "Serbia", "Sao Tome and Principe", "Suriname"}
#'   \item{[214] "Slovakia", "Slovenia", "Sweden"}
#'   \item{[217] "Swaziland", "Sint Maarten", "Seychelles"}
#'   \item{[220] "Syria", "Turks and Caicos Islands", "Chad"}
#'   \item{[223] "Togo", "Thailand", "Tajikistan"}
#'   \item{[226] "Turkmenistan", "Timor-Leste", "Tonga"}
#'   \item{[229] "Trinidad", "Tobago", "Tunisia"}
#'   \item{[232] "Turkey", "Taiwan", "Tanzania"}
#'   \item{[235] "Uganda", "Ukraine", "Uruguay"}
#'   \item{[238] "USA", "Uzbekistan", "Vatican"}
#'   \item{[241] "Grenadines", "Saint Vincent", "Venezuela"}
#'   \item{[244] "Virgin Islands", "Vietnam", "Vanuatu"}
#'   \item{[247] "Wallis and Futuna", "Samoa", "Yemen"}
#'   \item{[250] "South Africa", "Zambia", "Zimbabwe"}
#' }
#' @param scale_names unit of estimated density
#' @param ncol number of figures in line side by side. max is no. of "Category"
#' @param shape shape of COG point
#' @param size size of shape
#' @importFrom dplyr filter
#' @importFrom ggplot2 ggsave
#' @import maps
#' @import mapdata
#' @import ggplot2
#' @import magrittr
#'
#' @export

map_dens = function(data, region, scale_name, ncol, shape, size){
  map = ggplot() + coord_fixed() + xlab("Longitude") + ylab("Latitude")
  world_map = map_data("world")
  region2 = subset(world_map, world_map$region == region)
  local_map = map + geom_polygon(data = region2, aes(x = long, y = lat, group = group), colour = "gray 50", fill = "gray 50") + coord_map(xlim = c(min(data$lon)-1, max(data$lon)+1), ylim = c(min(data$lat)-1, max(data$lat)+1))
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
  if(length(unique(data$category)) == 1){
    p = geom_point(data = data, aes(x = lon, y = lat, colour = log_abundance), shape = shape, size = size)
    f = facet_wrap( ~ year, ncol = ncol)
    c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
    fig = local_map+theme_bw()+th+p+f+c+labs(title = "", x = "Longitude", y = "Latitude", colour = scale_name)
    ggsave(filename = "map_dens.pdf", plot = fig, units = "in", width = 8.27, height = 11.69)
  }

  #multi-species
  if(length(unique(data$category)) != 1){
    for(i in 1:length(data$category)){
      data2 = data %>% filter(category == 1)
      p = geom_point(data = data2, aes(x = lon, y = lat, colour = log_abundance), shape = shape, size = size)
      f = facet_wrap( ~ year, ncol = ncol)
      c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
      fig = local_map+theme_bw()+th+p+f+c+labs(title = paste(unique(data2$category_name)), x = "Longitude", y = "Latitude", colour = scale_name)
      ggsave(filename = "map_dens.pdf", plot = fig, units = "in", width = 8.27, height = 11.69)
    }
  }
}
