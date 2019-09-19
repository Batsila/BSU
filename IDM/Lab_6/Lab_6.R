library(MASS)
x1<-rnorm(20, 8)
y1<-rnorm(20, 8)
x2<-runif(10, -5, 5)
y2<-runif(10, -5, 5)
xy<-cbind(c(x1, x2),c(y1, y2))
xy
cl<-kmeans(xy,2)
n<-30
n.train<-floor(n*0.7)
n.test<-n-n.train
idx.train<-sample(1:n,n.train)
idx.test<-(1:n)[!(1:n %in% idx.train)]
data.train<-xy[idx.train,]
data.test<-xy[idx.test,] 
cl.cluster<-cl$cluster

cl.train<-cl.cluster[idx.train]
cl.test<-cl.cluster[idx.test]
model<-qda(data.train, cl.train) 
cl.test_est<-predict(model, data.test)$class
sum(cl.test_est!=cl.test) / n.test
idw<-idx.test[cl.test_est!=cl.test]
idw
plot(xy, type="n",xlab="x",ylab="y")
legend("bottomleft",legend=c("1","2", "error"),fill=c("blue","green", "red"))
points(xy[idx.train,],pch=2, col=ifelse(cl.train==1,"blue","green")) 
points(xy[idx.test,],pch=1, col=ifelse(cl.test==1,"blue","green"))
points(xy[idw,],col="red", pch=3)

idd<-sample(1:n.train,n.train * 0.2)
for(i in idd) {
  cl.train[i] <- (3 - cl.train[i])
}
model<-qda(data.train, cl.train) 
cl.test_est<-predict(model, data.test)$class
sum(cl.test_est!=cl.test)/n.test
idw<-idx.test[cl.test_est!=cl.test]
idw
plot(xy, type="n",xlab="x",ylab="y")
legend("bottomleft",legend=c("1","2", "error"),fill=c("blue","green", "red"))
points(xy[idx.train,],pch=2, col=ifelse(cl.train==1,"blue","green")) 
points(xy[idx.test,],pch=1, col=ifelse(cl.test==1,"blue","green"))
points(xy[idw,],col="red", pch=3)