library(tidyverse)
source("https://gist.githubusercontent.com/benmarwick/2a1bb0133ff568cbe28d/raw/fb53bd97121f7f9ce947837ef1a4c65a73bffb3f/geom_flat_violin.R")

#create raincloud theme
raincloud_theme <- theme(
  text = element_text(size = 10),
  axis.title.x = element_text(size = 16),
  axis.title.y = element_text(size = 16),
  axis.text = element_text(size = 14),
  axis.text.x = element_text(angle = 45, vjust = 0.5),
  legend.title = element_text(size = 16),
  legend.text = element_text(size = 16),
  legend.position = "right",
  plot.title = element_text(lineheight = .8, face = "bold", size = 16),
  panel.border = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank(),
  axis.line.x = element_line(colour = "black", size = 0.5, linetype = "solid"),
  axis.line.y = element_line(colour = "black", size = 0.5, linetype = "solid"))


#raincloud function
rain_cloud <- function(Data, X,Y,xlab="X",ylab="Y") {
  ggplot(data = Data, 
         aes_string(x = X, y = Y, fill = X)) +
    geom_flat_violin(position = position_nudge(x = .2, y = 0), alpha = .8) +
    geom_point(aes_string(y = Y, color = X), 
               position = position_jitter(width = .15), size = .5, alpha = 0.8) +
    geom_boxplot(width = .1, outlier.shape = NA, alpha = 0.5) +
    expand_limits(x = 5.25) +
    guides(fill = FALSE) +
    guides(color = FALSE) +
    labs(x=xlab,y=ylab) +
    scale_color_brewer(palette = "Set1") +
    scale_fill_brewer(palette = "Set1")+ # flip or not
    theme_bw()+coord_flip()+
    raincloud_theme
}
