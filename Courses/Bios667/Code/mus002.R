# mus002.r : plotting the fitted curves

pdf(file = 'mus002.pdf', onefile=T)  # send plots to this PDF file

# quadratic
g2 = function(age, gender) {
  cage  = age - 12;
  cage2 = cage * cage;
  p =           -1.2135  +
  gender      *  0.1159  +
  cage        *  0.0378  +
  cage2       * -0.0175  +
  gender*cage *  0.0075  +
  gender*cage2*  0.0039  ;
  p = plogis(p)
  return(p)
}

# cubic
g3 = function(age, gender) {
  cage  = age - 12;
  cage2 = cage * cage;
  cage3 = cage2* cage;
  p =           -1.2228  +
  gender      *  0.1457  +
  cage        *  0.0078  +
  cage2       * -0.0166  +
  cage3       *  0.0018  ;
  p = plogis(p)
  return(p)
}

age = seq(6, 18, 0.1)

p2_m = g2(age, 0)
p2_f = g2(age, 1)
plot(age, p2_f, type = 'l',
       ylim=c(0.1, 0.26),
       ylab = "Estimated Probability of Obesity",
       xlab = "Age (years)" )
lines (age, p2_m, type = 'l', lty = 2 )
legend("bottomright", c("Girls","Boys"), col=1, lty=1:2)
title(main="Quadratic (Figure 13.1)")

p3_m = g3(age, 0)
p3_f = g3(age, 1)
plot(age, p3_f, type = 'l', col = 2,
       ylim=c(0.1, 0.26),
       ylab = "Estimated Probability of Obesity",
       xlab = "Age (years)" )
lines (age, p3_m, type = 'l', lty = 2, col = 2 )
legend("bottomright", c("Girls","Boys"), col=2, lty=1:2)
title(main="Cubic (Figure 13.3)")


# overlay
plot(age, p2_f, type = 'l',
       ylim=c(0.1, 0.26),
       ylab = "Estimated Probability of Obesity",
       xlab = "Age (years)" )
lines (age, p2_m, type = 'l', lty = 2 )
lines (age, p3_f, type = 'l', col = 2)
lines (age, p3_m, type = 'l', lty = 2 , col = 2)
legend("bottomright", 
            c("Girls Quadratic","Boys Quadratic", "Girls Cubic", "Boys Cubic"), 
            col=c(1,1,2,2), 
            lty=c(1,2,1,2) )
title(main="Quadratic and Cubic")

dev.off()
