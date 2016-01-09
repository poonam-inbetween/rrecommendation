data("AirPassengers")
AP <- AirPassenger
class(AP)
??AirPassengers


start(AP)
end(AP)
frequency(AP)
summary(AP)


plot(AP)
cycle(AP)
aggregate(AP, FUN=mean)
plot(aggregate(AP))
boxplot(AP)
boxplot(AP~cycle(AP))
