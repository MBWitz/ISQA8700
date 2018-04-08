#Import packages

library(readr)
library(cluster)

news = read_csv("MBA/ISQA8700/ClassProject/OnlineNewsPopularity/OnlineNewsPopularityClean.csv")

drops <- c("1800","shares")
news = news[ , !(names(news) %in% drops)]

index <- sample(1:nrow(news), 1000)
train= news[index, ]

train <- na.omit(train) 
train <- scale(train) 

rows= (nrow(train)-1)
trainSum = sum(apply(train,2,var))

wss <- rows*trainSum
for (i in 1:23) wss[i] <- sum(kmeans(train, centers=i)$withinss)
  	
  	
plot(1:23, wss, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")

fit <- kmeans(train, 2)

# get cluster means 
aggregate(train,by=list(fit$cluster),FUN=mean)


cluster <- data.frame(train, fit$cluster)

clusplot(train, cluster[,"fit.cluster"], main='Cluster Solution',color=TRUE, shade=TRUE, labels=2, lines=0,xlab = "Component 1", ylab = "Component 2")

news <- na.omit(news) 
news <- scale(news) 

fit2 <- kmeans(news, fit[["centers"]], 2)

# get cluster means 
aggregate(news,by=list(fit2$cluster),FUN=mean)


cluster <- data.frame(news, fit2$cluster)

clusplot(news, cluster[,"fit2.cluster"], main='Cluster Solution',color=TRUE, shade=TRUE, labels=2, lines=0,xlab = "Component 1", ylab = "Component 2")

