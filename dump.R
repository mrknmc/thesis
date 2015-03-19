# ---- dump-plot ----
library("ggplot2")
library("reshape2")

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
k <- ggplot(b, aes(group=variable,y=value,x=Time,fill=variable)) + theme_bw() + scale_fill_grey()
k + geom_area()
