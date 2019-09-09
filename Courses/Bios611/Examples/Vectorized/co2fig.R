library(tidyverse)

c02_t=as.tibble(CO2)

ggplot(co2_t, aes(x=conc, y=uptake, group=Type)) +
  geom_point(size=2, alpha=0.5, aes(color=Type)) +
  geom_smooth(size=2,aes(color=Type),se=F)+
  labs(
    title=expression(paste("Quebec grasses uptake more CO"[2])),
    x = expression(paste("CO"[2], " Concentration (mL/L)")),
    y = expression(paste("CO"[2], " Uptake (",mu,"mol/m"^2, "sec)")),
    color = "Grass origin") +
  geom_vline(xintercept=375, linetype='dashed') +
  annotate('text', x=400, y=27, label = 'Uptake plateaus after 375 mL/L', hjust='left')+
theme_bw()+
theme(text= element_text(size=8))


ggsave("co2_conc.png",width=12,height=7,units="cm")