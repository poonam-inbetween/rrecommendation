# Read the file

spamD <- read.table(file.choose(),header=T,sep='\t')
head(spamD)
tail(spamD)
names(spamD)
summary(spamD)
dim(spamD)
sapply(spamD,class)


spamTrain <- subset (spamD, spamD$rgroup >= 10)
dim(spamTrain)

spamTest <- subset (spamD, spamD$rgroup < 10)
dim(spamTest)

spamVars <- setdiff (colnames(spamD), list('rgroup', 'spam'))
spamVars
help(setdiff)
 


spamFormula <- as.formula (paste('spam == "spam"', paste (spamVars,collapse = ' + '),sep = ' ~ '))
spamFormula


help(as.formula)

spamModel <- glm(spamFormula, family = binomial(link='logit'), data = spamTrain)
spamModel
spamTrain$pred <- predict(spamModel, newdata = spamTrain, type = 'response')
spamTrain$pred

spamTest$pred <- predict(spamModel, newdata = spamTest, type = 'response')
spamTest$pred

print (with(spamTest,table(y=spam,glmPred=pred>0.5)))

cM <- table(truth = spamTest$spam, prediction = spamTest$pred >0.5)
cM

sample <- spamTest [c(6,19,340,478),c('spam','pred')]
sample
