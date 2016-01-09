# Exploratory Analytics

EPAData <- read.csv(file.choose(), header=T) # Air Pollution data of US
names(EPAData)
head(EPAData)

# Requirement :- For fine particles pollution (PM2.5), the annual mean averaged over 3 years
# cannot exceed 12 micro-g/m3
attach(EPAData)
summary(EPAData)
summary(pm25) # The summary shows that there are entries which are exceeding threshhold of 12 micro-g/m3

boxplot(pm25, col = "pink")
abline(h=12) # this will draw a horizi=ontal line at 12, helps to mark points above 12

hist(pm25, col = "green")
rug(pm25)

# changing the breaks or making more bars for finer details, number od breaks is basically
# hit and trial method, it shouldn't be too small(as that will make less bars and oversmoothing)
# and more bars will dimish the curve of distribution and become very noisy
hist(pm25, col = "green", breaks = 100)
rug(pm25)

# Overlaying Features

hist(pm25, col = "green")
rug(pm25)
abline (v = 12, lwd = 3, col = "blue")
abline (v = median(pm25), lwd = 4, col = "red")


barplot(table(region), col = "pink") # Categorical variable

# Two Dimension

boxplot(pm25 ~ region, col = "red")
abline(h=12)
# the plot shows that average is higher in  east but all extreme values which are not in compliance
# of 12 mg/m3 mark lies in west

# Histogram of pm25 w.r.t region
par(mfrow = c(2,1))
hist(pm25[region=="east"], col = "blue")
hist(pm25[region=="west"], col = "yellow")


#Scatterplot
par(mfrow = c(1,1))

plot(latitude, pm25) # increase in latitde shows movement towards north
abline(h=12, lwd=3, lty=3,col="red")

plot(latitude, pm25, col=region) # with color as region
abline(h=12, lwd=3, lty=3,col="blue")

par(mfrow=c(1,2))
plot(latitude[region=="east"], pm25[region=="east"])
plot(latitude[region=="west"], pm25[region=="west"])


# Plotting Systems in R
# Base system

par(mfrow=c(1,1))
library(datasets)
data(cars)
attach(cars)
names(cars)
plot(speed,dist)


# lattice System

library(lattice)
state <- data.frame(state.x77, region=state.region)
names(state)
xyplot(Life.Exp ~ Income | region, data= state, layout= c(4,1))

# Lattice plots for airquality data

library(datasets)
airqual <- data.frame(airquality)
names(airqual)
summary(airqual)
head(airqual)
attach(airqual)


airqual <- transform(airqual, Month = factor(Month))
summary(airqual)

xyplot(Ozone ~ Wind | Month, data = airqual, layout = c(5,1))

# Test lattice plot

set.seed(10)
x <- rnorm(100)
x
f <- rep(0:1, each = 50)
f
y <- x + f - f * x + rnorm(100, sd = 0.5)
y

f <- factor (f, labels = c("Group1", "Group2"))
f
xyplot(y ~ x | f , layout = c(2,1))

# ggplot
install.packages("ggplot2")
library(ggplot2)
data(mpg)
names(mpg)

str(mpg)

??mpg
qplot(displ,hwy,data=mpg)

#Adding aesthetics
qplot(displ,hwy,data=mpg, color=drv)

# Adding geoms
qplot(displ,hwy,data=mpg, geom = c("point", "smooth"))

# Single variable study
qplot(hwy, data=mpg, fill = drv)

# facets - adding panels like lattice plots
qplot(displ,hwy,data=mpg, facets = .~drv)
qplot(hwy,data=mpg, facets = drv ~., binwidth = 2)

# Density plots

qplot(hwy,data=mpg, geom = "density", color = drv) # single variable

# two variable in terms of shape rather than color, change in aesthtics

qplot(displ,hwy,data=mpg, shape = drv )

# with method = linear
qplot(displ,hwy,data=mpg, color = drv, geom = c("point", "smooth") , method ="lm")


#ggplot

g <- ggplot(mpg, aes(displ,hwy))
g + geom_point()
g + geom_point() + geom_smooth()
g + geom_point() + geom_smooth(method = "lm")
g + geom_point() + facet_grid(.~drv) + geom_smooth(method = "lm")


g + geom_point(color= "green", alpha = 1/2) + geom_smooth(method = "lm") # Constant aesthetics, color = green
g + geom_point(aes(color= drv), alpha = 1/2) + geom_smooth(method = "lm") # Aesthetics vary with factor variable drv

# adding labels
g + geom_point(aes(color= drv), alpha = 1/2) + geom_smooth(method = "lm") + labs(title = "mpg Study")
g + geom_point(aes(color= drv), alpha = 1/2) + geom_smooth(method = "lm") + labs(title = "mpg Study") + labs(x="Displacement", y = "Highway mileage")

# Changing smooth parameters

g + geom_point(aes(color= drv), alpha = 1/2) + geom_smooth(size =4, linetype= 2, method = "lm", se= FALSE) + labs(title = "mpg Study") + labs(x="Displacement", y = "Highway mileage")


# Changing theme background

g + geom_point() + geom_smooth(method = "lm") + theme_bw(base_family = "Times")

g + geom_point(aes(color= drv), alpha = 1/2) + geom_smooth(size =4, linetype= 2, method = "lm", se= FALSE) + labs(title = "mpg Study") + labs(x="Displacement", y = "Highway mileage")+ theme_bw(base_family = "Times")

