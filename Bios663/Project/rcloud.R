library("ggplot2") 
library("tidyr") 
library("dplyr") 
library("cowplot") 
library("RColorBrewer") 

condition=factor(fb89$wk)
value=fb89$diffout
## And plot the data
ggplot(fb89, aes(x = condition, y = value, fill = condition, color = condition)) +
  theme_cowplot() +
  scale_shape_identity() +
  theme(legend.position = "none",
        plot.title = element_text(size = 20),
        axis.title = element_text(size = 15),
        axis.text = element_text(size = 15),
        axis.text.x = element_text(angle = 0, 
                                   hjust = 0,
                                   vjust = 0)) +
  scale_colour_brewer(palette = "Spectral") +
  scale_fill_brewer(palette = "Spectral") +
  geom_point(position = position_jitter(0.15), 
             size = 2, 
             alpha = 1, 
             aes(shape = 16)) +
  geom_violin(position = position_nudge(x = 0.2, y = 0),
              adjust = 2,
              draw_quantiles = c(0.5),
              alpha = 0.6, 
              trim = TRUE, 
              scale = "width") +
  geom_boxplot(aes(x = as.numeric(condition) + 0.2, y = value), 
               notch = FALSE, 
               width = 0.1, 
               varwidth = FALSE, 
               outlier.shape = NA, 
               alpha = 0.3, 
               colour = "black", 
               show.legend = FALSE)+
  geom_hline(yintercept=-5.75, color="black",linetype="dashed")+
  geom_hline(yintercept=3.25, color="black",linetype="dashed")+
  labs(title="Spread Error by Week", y="Error", x="Week")