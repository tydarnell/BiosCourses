sigma <- 1        # The standard deviation.
n <- 1          # The sample size.
theta0 <- 0       # The value of theta0 in H0.
#pow <- 0.80       # The minimum desired power.
alpha <- 0.05     # The significance level. Try 0.01, 0.05, 0.10
#beta <- 1 - pow   # The desired maximum Type II error probability.
z.alpha <- qnorm(1-alpha)  # P( Z > z.alpha ) = alpha
#z.beta <- qnorm(1-beta)    # P( Z > z.beta ) = beta

curve(pnorm(sqrt(n)*(x - theta0)/sigma - z.alpha), 
      from=theta0,                   # Left endpoint of the domain
      to=theta0+3.7*sigma/sqrt(n),   # Right endopint of the domain
      col="blue",                    # Try different colors
      main="Power Function",         # The Main Title
      xlab=expression(theta),        # Label the horizontal axis
      ylab=expression(gamma(theta)), # Label the vertical axis
      lwd=2,                         # Line width.
      xlim= c(0,1.2),               # keep same x axis
      ylim= c(0, 1),                # keep same y axis
      add=NA)     

par(new=TRUE)

curve(pnorm(sqrt(4)*(x - theta0)/sigma - z.alpha), 
      from=theta0,                   # Left endpoint of the domain
      to=theta0+3.7*sigma/sqrt(n),   # Right endopint of the domain
      col="green",                    # Try different colors
      main="Power Function",         # The Main Title
      xlab=expression(theta),        # Label the horizontal axis
      ylab=expression(gamma(theta)), # Label the vertical axis
      lwd=2,                         # Line width.
      xlim= c(0,1.2),               # keep same x axis
      ylim= c(0, 1),                # keep same y axis
      add=NA)     

par(new=TRUE)

curve(pnorm(sqrt(25)*(x - theta0)/sigma - z.alpha), 
      from=theta0,                   # Left endpoint of the domain
      to=theta0+3.7*sigma/sqrt(n),   # Right endopint of the domain
      col="yellow",                    # Try different colors
      main="Power Function",         # The Main Title
      xlab=expression(theta),        # Label the horizontal axis
      ylab=expression(gamma(theta)), # Label the vertical axis
      lwd=2,                         # Line width.
      xlim= c(0,1.2),               # keep same x axis
      ylim= c(0, 1),                # keep same y axis
      add=NA)    

par(new=TRUE)

curve(pnorm(sqrt(64)*(x - theta0)/sigma - z.alpha), 
      from=theta0,                   # Left endpoint of the domain
      to=theta0+3.7*sigma/sqrt(n),   # Right endopint of the domain
      col="orange",                    # Try different colors
      main="Power Function",         # The Main Title
      xlab=expression(theta),        # Label the horizontal axis
      ylab=expression(gamma(theta)), # Label the vertical axis
      lwd=2,                         # Line width.
      xlim= c(0,1.2),               # keep same x axis
      ylim= c(0, 1),                # keep same y axis
      add=NA)    

par(new=TRUE)

curve(pnorm(sqrt(100)*(x - theta0)/sigma - z.alpha), 
      from=theta0,                   # Left endpoint of the domain
      to=theta0+3.7*sigma/sqrt(n),   # Right endopint of the domain
      col="red",                    # Try different colors
      main="Power Function",         # The Main Title
      xlab=expression(theta),        # Label the horizontal axis
      ylab=expression(gamma(theta)), # Label the vertical axis
      lwd=2,                         # Line width.
      xlim= c(0,1.2),               # keep same x axis
      ylim= c(0, 1),                # keep same y axis
      add=NA)    