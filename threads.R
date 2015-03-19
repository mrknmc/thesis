# ---- threads-plot ----
library("ggplot2")

# read results
threads <- read.csv(file="csv/threads.csv",sep=",")
k <- ggplot(threads, aes(x=components))
k + geom_area(aes(y=storm_threads, fill="storm_threads")) + geom_area(aes(y=storm_mc_threads, fill="storm_mc_threads"))
