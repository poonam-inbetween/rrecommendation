SF_TestData <- read.table(file.choose(),header=T, sep=",")
names(SF_TestData)
summary(SF_TestData)

SF_TrainData <- read.table(file.choose(),header=T, sep=",")


SF_ExpectedOutput <- read.table(file.choose(),header=T, sep=",")
