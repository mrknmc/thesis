# ---- wordcount-plot ----

library("ggplot2")
library("reshape2")
# read storm results
storm <- read.csv(file="csv/storm/executions.log",sep=";",colClasses=c('NULL', NA, 'numeric'))
# read storm-mc results
storm_mc <- read.csv(file="csv/storm_mc/executions.log",sep=";",colClasses=c('NULL', NA, 'numeric'))
# merge the two tables by component name
mat <- merge(storm, storm_mc, by=c('component'), suffixes=c(".storm",".storm_mc"))
# add an improvement columns
mat$storm = 1
mat$improvement <- (mat$executions.storm_mc / mat$executions.storm) - 1
# get rid of old columns
mat$executions.storm <- NULL
mat$executions.storm_mc <- NULL
# melt by component name
t <- melt(mat, id=c("component"))
# create plot
k <- ggplot(t, aes(x=component, y=value, fill=variable))
# add labels
# TODO: add scale to Y axis
k + geom_bar(stat="identity") + xlab("Component") + ylab("Improvement") + ylim(0,2)
