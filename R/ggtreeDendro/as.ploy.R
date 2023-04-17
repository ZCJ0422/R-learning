# [YuLab-SMU/treeio](https://github.com/YuLab-SMU/treeio/blob/master/R/method-as-phylo.R)
# [supporting dendro class to phylo class](https://github.com/YuLab-SMU/treeio/pull/95)

##' @method as.phylo dendro
##' @export
as.phylo.dendro <- function(x, ...) {
  seg.da <- x$segments
  lab.da <- x$labels
  inode.da <- seg.da[, c(1, 2)] |>
    dplyr::bind_rows(
      seg.da[, c(3, 4)] |>
        dplyr::rename(x = "xend", y = "yend")
    )
  # 根节点只会在线段的起始段，而不会出现在线段的末端。
  # 因此没有出现在线段末端的才是根节点
  root.index <- apply(inode.da, 1,
    function(x) !any(x[[1]] == seg.da$xend & x[[2]] == seg.da$yend),
    simplify = F
  ) |>
    unlist(use.names = F)
  root.da <- unique(inode.da[root.index, ])

  # 处于直角的点在phylo中是不需要的
  # 而这样的点在seg.da中会出现两次（起点和终点）
  inode.da <- inode.da[apply(
    inode.da, 1,
    function(x) sum(x[[1]] == inode.da[, 1] & x[[2]] == inode.da[, 2])
  ) != 2, ]

  dt <- unique(rbind(lab.da[, c(1, 2)], root.da, inode.da))
  rownames(dt) <- seq_len(nrow(dt))

  parent.id <- do.call(
    "rbind",
    apply(dt, 1, function(x) check.inode(x = x, y = dt, z = seg.da, root.id = root.da), simplify = FALSE) # nolint
  )

  edge <- cbind(as.numeric(parent.id), as.numeric(rownames(dt)))
  edge <- edge[!edge[, 1] == edge[, 2], ]

  tr <- structure(
    .Data = list(
      edge = edge,
      edge.length = abs(dt[edge[, 2], 2] - dt[edge[, 1], 2]),
      tip.label = lab.da$label,
      Nnode = nrow(dt) - nrow(lab.da)
    ),
    class = "phylo"
  )

  return(tr)
}

check.inode <- function(x, y, z, root.id) { # nolint: object_name_linter.
  check.root <- x[[1]] == root.id[[1]] && x[[2]] == root.id[[2]] # nolint
  if (check.root) {
    nodeID <- rownames(y[x[[1]] == y[, 1] & x[[2]] == y[, 2], ])
    return(nodeID)
  }
  tmp <- z[x[[1]] == z[, 3] & x[[2]] == z[, 4], ]
  x <- tmp[, c(1, 2)]
  nodeID <- rownames(y[x[[1]] == y[, 1] & x[[2]] == y[, 2], ])
  check.root <- x[[1]] == root.id[[1]] && x[[2]] == root.id[[2]]
  if (length(nodeID) > 0 || check.root) {
    return(nodeID)
  } else {
    check.inode(x = x, y = y, z = z, root.id = root.id)
  }
}
