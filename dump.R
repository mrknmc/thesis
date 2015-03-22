# ---- dump-plot ----
library("ggplot2")
library("reshape2")
library(scales)
library(grid)
library(RColorBrewer)

# the color pallete
cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# read results
dump <- read.csv(file="csv/dump.csv",sep=",")
dump$TIMED_WAITING <- dump$TIMED_WAITING_monitor + dump$TIMED_WAITING_parking + dump$TIMED_WAITING_sleeping
dump$TIMED_WAITING_monitor <- NULL
dump$TIMED_WAITING_parking <- NULL
dump$TIMED_WAITING_sleeping <- NULL
dump$WAITING <- dump$WAITING_parking
dump$WAITING_parking <- NULL
dump$Time<-seq.int(nrow(dump))
b <- melt(dump, id.vars="Time")
k <- ggplot(b, aes(group=variable,y=value,x=Time,fill=variable)) + scale_x_discrete(breaks=seq(0,180, by=30)) + scale_y_discrete(breaks=seq(0,60, by=10)) + scale_fill_manual(values=cbPalette,name="Thread State")
k + geom_area() + ylab("# of threads") + geom_hline(yintercept=0, size=0.4, color="black")
