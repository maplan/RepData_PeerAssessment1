setwd("~/RepData_PeerAssessment1")
activity <- read.csv("~/RepData_PeerAssessment1/activity.csv", as.is=TRUE)
byday<-aggregate(steps~date, activity, sum)
barplot(height=byday$steps, names.arg=byday$date, xlab="date", ylab='steps', main='number of steps by day')
stepsday<-na.omit(byday)
mean(stepsday$steps, na.rm=TRUE)
median(stepsday$steps, na.rm=TRUE)
trueactivity<-na.omit(activity)
# convert trueactivity$interval into factor
trueactivity$interval <- as.factor(trueactivity$interval)
# average number of steps taken, averaged across all days
averstepsdayinterval <- tapply(trueactivity$steps, trueactivity$interval, mean)
# time series plot of the interval (x-axis) and the average number of steps taken
plot(names(averstepsdayinterval), averstepsdayinterval, type = 'l', 
xlab = "Day Interval", ylab = "Number Steps")
max <- averstepsdayinterval[which(max(averstepsdayinterval)==averstepsdayinterval)]
names(max)
unname(max)
length(which(is.na(activity$steps) == TRUE))
