
#Import packages

library("readr", lib.loc="~/R/win-library/3.4")
library("caret", lib.loc="~/R/win-library/3.4")
library("corrplot", lib.loc="~/R/win-library/3.4")
library("mlbench", lib.loc="~/R/win-library/3.4")
library("ROCR", lib.loc="~/R/win-library/3.4")
library("dplyr", lib.loc="~/R/win-library/3.4")

#Import data and store in variable named "News"
News = read_csv("OnlineNewsPopularity2.csv")

#View and observe the data
str(News)
summary(News)

#Get correlation matrix of News2
correlations = cor(News)
corrplot(correlations, method = "circle")


#get a random sample of 5000 rows
set.seed(48)
Trainset = sample(nrow(News), 35000)
NewsTrain = News[Trainset, ]
NewsTest = News[-Trainset, ]

#build training model
model = glm(sharesbinary ~ ., data = NewsTrain, family = binomial)
modelProb = predict(model, NewsTrain, type = "response")
modelPred = rep("0", nrow(NewsTrain))
modelPred[modelProb > .5] = "1"
table(NewsTrain$sharesbinary, modelPred)
#67% accuracy, not bad

#take a look at the ROC curve for the training data to ge the most ideal threshold
ROCRpred = prediction(modelProb, NewsTrain$sharesbinary)
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize = TRUE)

#.42 seems to be the optimal cutoff in order to be conservative
# and reduce the number of times we call a non popular article popular
modelPred = rep("0", nrow(NewsTrain))
modelPred[modelProb > .42] = "1"
table(NewsTrain$sharesbinary, modelPred)
#66% Accuracy with type one error down to 11%


#run on test set
modelTestProb = predict(model, NewsTest, type = "response")
modelTestPred = rep("0", nrow(NewsTest))
modelTestPred[modelTestProb > .42] = "1"
table(NewsTest$sharesbinary, modelTestPred)
#62.7% accuracy on the test sample (34,644 rows) with this model
#type 1 error remained at 11%

#take a look at the ROC curve for the test data to ge the most ideal threshold
ROCRpred = prediction(modelTestProb, NewsTest$sharesbinary)
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize = TRUE)



