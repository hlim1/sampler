quickRead <- function (...)
  {
    read.table(...,
               header=TRUE, row.names=NULL,
               sep="\t", quote="", comment.char="")
  }


########################################################################


cat("reading site info: ")
site.info <- quickRead("dataset/site-info.dat")
n.sites <- nrow(site.info)
cat(n.sites, "sites\n")

cat("reading results: ")
results <- quickRead("dataset/results.dat", colClasses="integer")
n.trials <- nrow(results)
cat(n.trials, "trials\n")


########################################################################


read.site <- function (siteNum)
  {
    if (siteNum < 1) stop("site number must be positive")
    if (siteNum > n.sites) stop("site number may not exceed ", n.sites)

    cat("selecting counts at site: ")
    counts <- quickRead(pipe(paste("./R-select", siteNum, n.sites, "<dataset/summary.dat")),
                        colClasses="integer",
                        nrows=n.sites + 1)
    cat("done\n")

    if (nrow(counts) != n.trials) stop("wrong number of rows in counts table")

    counts
  }


probe <- function (description, count)
  {
    test <- t.test(count ~ results$result)
    cat(description, ":", test$p.value, "\n")
  }


accuse.counts <- function (counts)
  {
    probe("<<", counts$less)
    probe("==", counts$equal)
    probe(">>", counts$greater)
    probe("<=", counts$less + counts$equal)
    probe(">=", counts$equal + counts$greater)
    probe("<>", counts$less + counts$greater)
    probe("@@", counts$less + counts$equal + counts$greater)
  }


accuse.site <- function (siteNum)
  {
    accuse.counts(read.site(siteNum))
  }
