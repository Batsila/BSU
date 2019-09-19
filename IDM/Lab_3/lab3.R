dat=read.table("data.txt")
dat1=read.table("data.txt")
dat
plot(dat,type="p",main="Корреляционное поле",xlab="X", ylab="Y")
numericXData <- as.numeric(unlist(dat[1])) # coerce to numeric format
numericYData <- as.numeric(unlist(dat[2]))
myLength <- length(numericXData) # number of X values
mySigma <- sd(numericXData) # standard deviation
t<- rep(0,3*4)
dim(t)<- c(3,4)
t
for (i in 1:3) t[i,1]<-1
t
disp <- var (dat[,1])
disp
deviat <- sqrt (disp)
deviat
aver <- mean (dat[,1])
aver
gr1 <- subset (dat[,1], ((aver - deviat) <= dat[,1]) & (dat[,1] <= (aver + deviat)))
gr1
gr2 <- subset (dat[,1], ((aver - 2 * deviat) <= dat[,1]) & (dat[,1] <= (aver + 2 * deviat)))
gr2
gr3 <- subset (dat[,1], ((aver - 3 * deviat) <= dat[,1]) & (dat[,1] <= (aver + 3 * deviat)))
gr3
intervals <- rep(0, 3*2) # to store the intervals
dim(intervals) <- c(3,2)
for (i in 1:3){ # fill the intervals
  intervals[i,1] <- aver - i*mySigma
  intervals[i,2] <- aver + i*mySigma
  # sep attribute eliminates additional spaces
  t[i,1] <- paste( sep = "", '(', as.character(intervals[i,1]), ',',
                   as.character(intervals[i,2]), ')' )
}
t
normalizedIndexes <- which(numericXData < intervals[3,2] & numericXData > intervals[3,1])
normalizedXData <- numericXData[normalizedIndexes]
normalizedYData <- numericYData[normalizedIndexes]
normalizedLength <- length(normalizedXData)
normalizedXSd <- sd(normalizedXData)
normalizedYSd <- sd(normalizedYData)
normalizedXMean <- mean(normalizedXData)
normalizedYMean <- mean(normalizedYData)
correlationCoefficient <- 1/normalizedLength * 
  sum( ((normalizedXData - normalizedXMean)/normalizedXSd) * 
         ((normalizedYData - normalizedYMean)/normalizedYSd) )
correlationCoefficient
tab2 <- matrix (0, 3, 4)
tab2[1,4] <- "x - sigm, x + sigm"
tab2[2,4] <- "x - 2 * sigm, x + 2 * sigm"
tab2[3,4] <- "x - 3 * sigm, x + 3 * sigm"
for (i in 1:3){
  # count number of such elements as a sum of 1 in a logical vector
  number <- sum(numericXData  > intervals[i,1] & numericXData < intervals[i, 2])
  tab2[i,2] <- number
  tab2[i,3] <- number / myLength * 100
}
tab2[1:4,1] <- c (length (gr1), length (gr2), length(gr3))
tab2[1:4,2] <- tab2[1:3,1]/length (dat[,1]) * 100
tab2[1:4,3] <- c (68.3, 95.4, 99.7)
tab2
range <- max (dat[,1]) - min (dat[,1])
range
k <- 1 + floor (log (length (dat[,1]), 2))
h <- range / k
sa <- sort (dat[,1])
dat1[order(dat1$V1),]

groupsNumber <- 1 + floor(log2(normalizedLength))

groupsTable <- rep(0, groupsNumber*4)
dim(groupsTable) <- c(groupsNumber, 4)

groupsIntervals <- rep(0, groupsNumber*2)
dim(groupsIntervals) <- c(groupsNumber,2)

range <- max(normalizedXData) - min(normalizedXData)
step <- range / groupsNumber
minX <- min(normalizedXData)
for (i in 1:groupsNumber){
  if (i == 1)
    groupsIntervals[i,1] = min(normalizedXData)
  else
    groupsIntervals[i,1] = groupsIntervals[i-1,2]
  groupsIntervals[i,2] = groupsIntervals[i,1] + step
  groupsTable[i,1] <- paste( sep = "", '[', as.character(groupsIntervals[i,1]), ',',
                             as.character(groupsIntervals[i,2]) )
  if (i < groupsNumber) 
    groupsTable[i,1] <- paste0(groupsTable[i,1], ')') # equivalent to paste(sep="",...)
  else
    groupsTable[i,1] <- paste0(groupsTable[i,1], ']')
}

for (i in 1:groupsNumber){
  if (i < groupsNumber)
    appropriateIndexes <- which(normalizedXData >= groupsIntervals[i,1] &
                                  normalizedXData < groupsIntervals[i,2])
  else
    appropriateIndexes <- which(normalizedXData >= groupsIntervals[i,1] &
                                  normalizedXData <= groupsIntervals[i,2])
  groupsTable[i,2] <- length(appropriateIndexes)
  groupsTable[i,3] <- sum(normalizedYData[appropriateIndexes])
  groupsTable[i,4] <- mean(normalizedYData[appropriateIndexes])
}
groupsTable

v <- length (dat[,1]) - 2
T <- abs (correlationCoefficient) * sqrt (v / (1 - correlationCoefficient ^2))
T
lm (dat[,2]~dat[,1])
tab2
k 
h
correlationCoefficient
coefB <- correlationCoefficient * normalizedYSd / normalizedXSd
coefA <- normalizedYMean - coefB * normalizedXMean
coefA
coefB
abline(coefA,coefB)