# ---- enron-plot ----

library("ggplot2")
library("ggthemes")
library("reshape2")
library(scales)
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

mat <- read.csv(file="csv/enron.csv")
# Compute global throughput
mat$value <- mat$value * mat$parallelism
# Add header label
mat$parallelism <- paste("Parallelism:", mat$parallelism)
# Convert back to seconds
mat$time <- mat$time * 4
# Take every second measurement
t <- mat[seq(1, nrow(mat), 2), ]
#k <- ggplot(t, aes(x=time, y=value)) +
k <- ggplot(t, aes(x=time, y=value,fill=variable,color=variable)) +
    facet_wrap(~parallelism, nrow = 3, ncol = 2, scales="free") +
    scale_fill_brewer(name="Library", palette="Set1", labels=c("Apache Storm", "Storm-MC")) +
    scale_colour_brewer(name="Library", palette="Set1", labels=c("Apache Storm", "Storm-MC")) +
    scale_y_continuous(labels=format_si(), name="Global Throughput (Emails / s)\n") +
    theme_bw() +
    theme(legend.position="top", legend.key = element_blank()) +
    xlab("\nTime (seconds)")

k + geom_smooth(method = "lm", alpha=0.7, size=0, fill="grey",color="grey", se=TRUE, aes(group=variable)) + geom_point() + geom_line(size=0.5)
