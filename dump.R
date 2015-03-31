# ---- dump-plot ----
library("ggplot2")
library("reshape2")
library(scales)
library(grid)

# the color pallete
#cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# read results
dump <- read.csv(file="csv/dump.csv",sep=",")
dump$TIMED_WAITING <- dump$TIMED_WAITING_monitor +
    dump$TIMED_WAITING_parking +
    dump$TIMED_WAITING_sleeping
dump$TIMED_WAITING_monitor <- NULL
dump$TIMED_WAITING_parking <- NULL
dump$TIMED_WAITING_sleeping <- NULL
dump$WAITING <- dump$WAITING_parking
dump$WAITING_parking <- NULL
dump$Time<-seq.int(nrow(dump))
b <- melt(dump, id.vars="Time")
# create plot
k <- ggplot(b, aes(group=variable,y=value,x=Time,fill=variable)) +
    scale_x_discrete(breaks=seq(0,180, by=30), name="\nTime (seconds)") +
    scale_y_discrete(breaks=seq(0,90, by=10), name="# of Threads\n") +
    scale_fill_brewer(palette="Set1", name="Thread State") +
    scale_colour_brewer(palette="Set1", name="Thread State") +
    theme_bw() +
    theme(legend.position="top", legend.key = element_blank())

k + geom_area(size=1.5)
