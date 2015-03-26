# ---- countbolt-plot ----

library("ggplot2")
library("ggthemes")
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

mat <- read.csv(file="csv/count.csv")
# melt by parallelism
t <- melt(mat, id.vars=c("parallelism"))
# create plot
k <- ggplot(t, aes(x=parallelism, y=value, fill=variable, color=variable)) +
    scale_fill_grey(name="Library", labels=c("Apache Storm", "Storm-MC")) +
    scale_colour_grey(name="Library", labels=c("Apache Storm", "Storm-MC")) +
    theme_bw() +
    theme(legend.position="top")

k + geom_line(size=1.5) + geom_point(size=4, type=21) +
    scale_y_continuous(limits=c(0, 550000000), labels=format_si(), name="Tuples Processed\n") +
    scale_x_continuous(breaks=1:6, name="\nParallelism")
    #geom_hline(yintercept=0, size=0.4, color="black")

