# ---- wordcount-plot ----

library("ggplot2")
library("reshape2")
library(scales)
#library(RcolorBrewer)
library(grid)

format_si <- function(...) {
  # Format a vector of numeric values according
  # to the International System of Units.
  # http://en.wikipedia.org/wiki/SI_prefix
  #
  # Based on code by Ben Tupper
  # https://stat.ethz.ch/pipermail/r-help/2012-January/299804.html
  # Args:
  #   ...: Args passed to format()
  #
  # Returns:
  #   A function to format a vector of strings using
  #   SI prefix notation
  #
  
  function(x) {
    limits <- c(1e-24, 1e-21, 1e-18, 1e-15, 1e-12,
                1e-9,  1e-6,  1e-3,  1e0,   1e3,
                1e6,   1e9,   1e12,  1e15,  1e18,
                1e21,  1e24)
    prefix <- c("y",   "z",   "a",   "f",   "p",
                "n",   "µ",   "m",   " ",   "k",
                "M",   "G",   "T",   "P",   "E",
                "Z",   "Y")
  
    # Vector with array indices according to position in intervals
    i <- findInterval(abs(x), limits)
  
    # Set prefix to " " for very small values < 1e-24
    i <- ifelse(i==0, which(limits == 1e0), i)

    paste(format(round(x/limits[i], 1),
                 trim=TRUE, scientific=FALSE, ...),
          prefix[i])
  }
}



# read storm results
#cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

storm <- read.csv(file="csv/storm/executions.log",sep=";",colClasses=c('NULL', NA, 'numeric'))
# read storm-mc results
storm_mc <- read.csv(file="csv/storm_mc/executions.log",sep=";",colClasses=c('NULL', NA, 'numeric'))
# merge the two tables by component name
mat <- merge(storm, storm_mc, by=c('component'), suffixes=c(".storm",".storm_mc"))
# add an improvement columns
#mat$storm = 1
#mat$improvement <- (mat$executions.storm_mc / mat$executions.storm) - 1
mat$improvement <- mat$executions.storm_mc - mat$executions.storm
# get rid of old columns
#mat$executions.storm <- NULL
mat$executions.storm_mc <- NULL
# melt by component name
t <- melt(mat, id=c("component"))
# create plot
k <- ggplot(t, aes(x=component, y=value, fill=variable)) + scale_fill_grey() + theme_bw() # + scale_fill_manual(values="variable" ,name="Library")
# add labels
# TODO: add scale to Y axis
#k + geom_bar(stat="identity") + xlab("Component") + ylab("Improvement") + scale_y_discrete(limits=c(0, 2), labels = percent) + geom_hline(yintercept=0, size=0.4, color="black")
k + geom_bar(stat="identity") + xlab("Component") + ylab("Improvement") + scale_y_continuous(labels=format_si()) + geom_hline(yintercept=0, size=0.4, color="black")

