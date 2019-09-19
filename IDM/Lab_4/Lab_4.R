dat<-read.table("data.txt")
t<-as.numeric(dat[,1])
x<-as.numeric(c(dat[,2]))
f<-as.data.frame(dat)
n<-length(x)
averageLevel<-mean(x)
for( i in 1:n) if ( x[i] < averageLevel ) f[i,3] = 0 else f[i,3] = 1
lowbound<-(n+1-3*sqrt(n-1))/2
upperbound<-(n+1+3*sqrt(n-1))/2
f[1,4]=(5*f[1,2]+2*f[2,2]-f[3,2])/6
f[n,4]=(5*f[n,2]+2*f[n-1,2]-f[n-2,2])/6
for ( i in 3:n-1 ) f[i, 4]=(x[i-1]+x[i]+x[i+1])/3
f[1,5] <- -7
for ( j in 2:n ) f[j,5]=f[j-1,5]+1
for ( j in 1:n ) f[j,6]=f[j,5]*f[j,5]
for ( j in 1:n ) f[j,7]=f[j,2]*f[j,5]
a0<-sum(f[,2]) / n
a1<-sum(f[,7]) / sum(f[,6])
for ( j in 1:n ) f[j,8]=f[j,5] * a1 + a0
f
prognoz <- a1 * 8 + a0
prognoz
x<-as.numeric(f[,1])
y<-as.numeric(f[,2])
z<-as.numeric(f[,4])
u<-as.numeric(f[,8])
# исходные данные
plot(x, y, ylim=range(c(y,z, u)), type="l", col="red", lwd = 2)
par(new = TRUE)
# трехуровневая скользящая средняя
plot(x, z, ylim=range(c(y,z,u)), axes = FALSE, type="l",  col="blue", xlab = "", ylab = "", lwd = 2)
par(new = TRUE)
# метод аналитического выравнивания
plot(x, u, ylim=range(c(y,z,u)), axes = FALSE, type="l",  col="green", xlab = "", ylab = "", lwd = 2)