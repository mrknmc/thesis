# ---- dump-plot ----
library("ggplot2")
library("reshape2")

# read results
dump <- read.csv(file="csv/dump.csv",sep=",")
dump$Time<-seq.int(nrow(dump))
b <- melt(dump, id.vars="Time")
k <- ggplot(b, aes(group=variable,y=value,x=Time,fill=variable)) + theme_bw() + scale_fill_grey()
k + geom_area()
