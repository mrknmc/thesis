# ---- threads-plot ----
library("ggplot2")
library("reshape2")

# read results
threads <- read.csv(file="csv/threads.csv",sep=",")
t <- melt(threads, id.vars=c("parallelism"))
k <- ggplot(t, aes(x=parallelism, y=value, fill=variable, color=variable)) +
    scale_fill_brewer(palette="Set1",  name="Library", labels=c("Apache Storm", "Storm-MC")) +
    scale_colour_brewer(palette="Set1",name="Library", labels=c("Apache Storm", "Storm-MC")) +
    theme_bw() +
    theme(legend.position="top", legend.key = element_blank())

k + geom_line(size=1) + geom_point(size=4, type=21) +
    scale_y_continuous(name="# of Threads\n") +
    scale_x_continuous(breaks=1:10, name="\nParallelism")
