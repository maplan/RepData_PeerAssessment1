setwd("~/RepData_PeerAssessment1")
activity <- read.csv("~/RepData_PeerAssessment1/activity.csv", as.is=TRUE)
byday<-aggregate(steps~date, activity, sum)
barplot(height=byday$steps, names.arg=byday$date, xlab="date", ylab='steps', main='number of steps by day')
stepsday<-na.omit(byday)
mean(byday$steps, na.rm=TRUE)
median(byday$steps, na.rm=TRUE)
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
# create a new dataset
newactivity <- activity

library(Hmisc)

newactivity$imputed_steps <- with(newactivity, impute(steps, mean))
bydaynew<-aggregate(imputed_steps~date, newactivity, sum)
barplot(height=bydaynew$imputed_steps, names.arg=bydaynew$date, xlab="date", ylab='steps', main='number of steps by day')
mean(bydaynew$imputed_steps, na.rm=TRUE)
median(bydaynew$imputed_steps, na.rm=TRUE)
#convert date to a date class
newactivity$date<-as.Date(newactivity$date)

weekdayweekend <- function(date) {
        day <- weekdays(date)
        if (day %in% c("lunes", "martes", "miércoles", "jueves" , "viernes")) 
                return("weekday") else if (day %in% c("sábado", "domingo")) 
                        return("weekend") else stop("invalid date")
}
newactivity$day <- sapply(newactivity$date, FUN = weekdayweekend)

# average number of steps taken, averaged across weekdays or weekends
aversteps <- aggregate(imputed_steps~interval+day, newactivity, mean)
library(ggplot2)
ggplot(aversteps, aes(interval, imputed_steps)) + geom_line() + facet_grid(day ~ .) + 
        xlab("5-minute interval") + ylab("Number of steps")

