# tlc009.r : sample R code
#
#**************************************************************

# read data
infile = "tlc.dat" 
x = read.table(infile,  header=T)

# generate a PDF file
pdf(file = 'tlc009.pdf', onefile=T)  # send plots to this PDF file

# Four occasions per group
boxplot(x[x$group=='P',3:6], main="Group P")  
boxplot(x[x$group=='A',3:6], main="Group A")  

# Two groups at each occasion 
boxplot(split(x$week0, x$group ), main = "week 0")
boxplot(split(x$week1, x$group ), main = "week 1")
boxplot(split(x$week4, x$group ), main = "week 4")
boxplot(split(x$week6, x$group ), main = "week 6")

plot(x$week0, x$week1, col = 1 + (x$group == 'A'), pch=19 )
title(main = "Week 1 vs baseline")

plot(x$week0, x$week4, col = 1 + (x$group == 'A'), pch=19 )
title(main = "Week 4 vs baseline")

plot(x$week0, x$week6, col = 1 + (x$group == 'A'), pch=19 )
title(main = "Week 6 vs baseline")

av146 = (x$week1 + x$week4 + x$week6) / 3
plot(x$week0, av146, col = 1 + (x$group == 'A'), pch=19 )
title(main = "Average weeks 1, 4, 6 vs baseline")

pairs(x[,3:6], col = 1 + (x$group == 'A'), pch=19 )

# Change from baseline
# Two groups at each occasion 
dif1 = x$week1 - x$week0
dif4 = x$week4 - x$week0
dif6 = x$week6 - x$week0
boxplot(split(dif1, x$group ), main = "week1 - week0")
boxplot(split(dif4, x$group ), main = "week4 - week0")
boxplot(split(dif6, x$group ), main = "week6 - week0")
pairs(cbind(dif1,dif4,dif6), col = 1 + (x$group == 'A'), pch=19 )


# Spaghetti plot
timepoints = c(0, 1, 4, 6)
i = 1
plot(timepoints, x[i,3:6], ylim=c(0, 65), type = 'l', 
     col = 1 + (x$group[i] == 'A') )
for (i in 2:length(x$id)) {
  lines(timepoints, x[i,3:6], type = 'l', col = 1 + (x$group[i] == 'A') )
}
title(main = "Time plot with joined line segments")

dev.off()   # close the PDF file

# generate an output text file
sink('tlc009.lst')  # screen output -> file

table(x$group)
A = (x$group == 'A')
summary(x[!A, 3:6])      # Placebo
summary(x[A,  3:6])      # Active

summary(glm(x$week6[A]  ~ x$week0[A] ))   # group A
summary(glm(x$week6[!A] ~ x$week0[!A]))   # group P

sink()   # close the output file
