library(ggplot2)
library(ggdendro)
library(magrittr)

hc <- hclust(dist(USArrests[1:4, ]), "ave")
dhc <- as.dendrogram(hc)
hcdata <- dendro_data(dhc, type = "rectangle")
p <- ggplot(segment(hcdata)) +
  geom_segment(aes(
    x = x,
    y = y, xend = xend, yend = yend
  )) +
  coord_flip() +
  scale_y_reverse(expand = c(0.2, 0)) +
  geom_text(data = hcdata$labels, aes(
    x = x,
    y = y, label = label
  ), vjust = 0)
p

tran <- function(hcdata) {
  # create an initial dataframe to store hcdata
  k <- 0
  v <- c(1:nrow(hcdata$segments)) # nolint
  parent <- NA
  node <- v
  label <- NA
  length <- NA
  df <- cbind(parent, node, label, length) %>% as.data.frame()

  # fill the dataframe
  for (i in v) {
    for (j in v) {
      if (hcdata$segments$x[i] == hcdata$segments$xend[j] && hcdata$segments$y[i] == hcdata$segments$yend[j]) { # nolint
        df$parent[i] <- df$node[j]
      }
    }
    if (is.na(df$parent[i])) {
      df$parent[i] <- nrow(df) + 1
    }

    # fill the dataframe of label
    if (hcdata$segments$yend[i] == 0) {
      k <- k + 1
      df$label[i] <- hcdata$labels$label[k]
    }

    # fill the dataframe of edge.length
    if (hcdata$segments$x[i] == hcdata$segments$xend[i]) {
      df$length[i] <- abs(hcdata$segments$yend[i] - hcdata$segments$y[i])
    } else {
      df$length[i] <- abs(hcdata$segments$xend[i] - hcdata$segments$x[i])
    }
  }
  return(df)
}
tp <- tran(p$plot_env$hcdata)


library(ggtree)
library(treeio)

tree <- as.phylo(x = tp, label = label, branch.length = length)
p1 <- ggtree(tree) + geom_tiplab()
p1
