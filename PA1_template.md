# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

```r
setwd("~/RepData_PeerAssessment1")
activity <- read.csv("~/RepData_PeerAssessment1/activity.csv", as.is=TRUE)
```
##1. Make a histogram of the total number of steps taken each day

```r
byday<-aggregate(steps~date, activity, sum)
barplot(height=byday$steps, names.arg=byday$date, xlab="date", ylab='steps', main='number of steps by day')
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

## What is mean total number of steps taken per day?

```r
mean(byday$steps, na.rm=TRUE)
```

```
## [1] 10766.19
```

## What is the median total number of steps taken per day?

```r
median(byday$steps, na.rm=TRUE)
```

```
## [1] 10765
```

## What is the average daily activity pattern?

```r
trueactivity<-na.omit(activity)
```

### convert trueactivity$interval into factor

```r
trueactivity$interval <- as.factor(trueactivity$interval)
averstepsdayinterval <- tapply(trueactivity$steps, trueactivity$interval, mean)
```

### time series plot of the interval (x-axis) and the average number of steps taken

```r
plot(names(averstepsdayinterval), averstepsdayinterval, type = 'l', 
xlab = "Day Interval", ylab = "Number Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png) 

##the 5-minute interval with the maximum number of steps (on average) is:

```r
max <- averstepsdayinterval[which(max(averstepsdayinterval)==averstepsdayinterval)]
names(max)
```

```
## [1] "835"
```

##the average number of steps in this interval is:

```r
unname(max)
```

```
## [1] 206.1698
```
##Imputing missing values

##1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with `NA`s)

## The number of missing values is:

```r
length(which(is.na(activity$steps) == TRUE))
```

```
## [1] 2304
```
##2. Fill all the missing values in the dataset using the mean value.

##3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

###Hmisc package is required 


```r
newactivity <- activity
library(Hmisc)
```

```
## Warning: package 'Hmisc' was built under R version 3.1.2
```

```
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
## Loading required package: splines
## Loading required package: Formula
```

```
## Warning: package 'Formula' was built under R version 3.1.2
```

```
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```

```r
newactivity$imputed_steps <- with(newactivity, impute(steps, mean))
```
###4. Make a histogram of the total number of steps taken each day 


```r
bydaynew<-aggregate(imputed_steps~date, newactivity, sum)
barplot(height=bydaynew$imputed_steps, names.arg=bydaynew$date, xlab="date", ylab='steps', main='number of steps by day')
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png) 

##Calculate and report the **mean** and **median** total number of steps taken per day. 

```r
mean(bydaynew$imputed_steps, na.rm=TRUE)
```

```
## [1] 10766.19
```

```r
median(bydaynew$imputed_steps, na.rm=TRUE)
```

```
## [1] 10766.19
```

####These values does not differ much from the estimates from the first part of the assignment. This seem logic as the missing data have been filled by the mean values

## Are there differences in activity patterns between weekdays and weekends?

###1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

####convert date to date Class


```r
newactivity$date<-as.Date(newactivity$date)
```
####classifiy date as weekday or weeked, applying a function


```r
weekdayweekend <- function(date) {
        day <- weekdays(date)
        if (day %in% c("lunes", "martes", "miércoles", "jueves" , "viernes")) 
                return("weekday") 
        else if (day %in% c("sábado", "domingo")) 
                return("weekend") else stop("invalid date")
}
newactivity$day <- sapply(newactivity$date, FUN = weekdayweekend)
```

### average number of steps taken, averaged across weekdays or weekends and plot using ggplot2 so ggplot2 package is needed


```r
aversteps <- aggregate(imputed_steps~interval+day, newactivity, mean)
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.1.2
```

```r
ggplot(aversteps, aes(interval, imputed_steps)) + geom_line() + facet_grid(day ~ .) + xlab("5-minute interval") + ylab("Number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-16-1.png) 


