########################################################################
##
##  Find all trials
##
##     Expects DIR as a directory containing trial output files.
##     Returns a vector of trial names suitable for passing to other
##     functions.
##

findTrials <- function (dir) {
  cat("scanning for trials: ")
  files <- list.files(path=dir, pattern="^[0-9]+\.result$", full.names=TRUE)
  trials <- sort(sub("\.result$", "", files))
  cat(length(trials), "trials\n")
  trials
}


########################################################################
##
##  Read descriptive information about instrumentation sites
##
##     Expects TRIALS as either a single trial name or a vector of
##     trial names, such as returned by findTrials().
##
##     Picks one trial and reads static descriptive information about
##     each instrumentation site: file name, line number, containing
##     function, etc.  This information should be consistent across
##     all runs, and therefore need only be read and stored once.
##
##     Returns a data frame with appropriate category names, suitable
##     for using directly or for passing to readTrace() or readTraces().
##

readSiteInfo <- function (trials) {
  cat("reading site info: ")
  sites <- readTraceColumns(trials[1], 1:6)
  cat(nrow(sites), "sites\n")
  sites
}


########################################################################
##
##  Read one trial result
##
##     Expects TRIAL as a single trial name.  Reads the corresponding
##     result file.  Returns the integer exit signal for that trial.
##

readResult <- function (trial) {
  as.integer(readLines(trialFileName(trial, "result"), n=1, ok=FALSE))
}


########################################################################
##
##  Read all trial results
##
##     Expects TRIALS as a vector of <n> trial names, such as returned
##     by findTrials().  Reads each corresponding result file.
##     Returns the corresponding vector of <n> integer exit signals.
##

readResults <- function (trials) {
  cat("reading", length(trials), "results: ")
  results <- sapply(trials, readResult, USE.NAMES=FALSE)
  cat("done\n")
  results
}


########################################################################
##
##  Read one trace
##
##     Expects TRIAL as a single trial name, and SITES as a data frame
##     of <s> sites as returned by readSiteInfo().
##
##     Reads all counter triples for all sites in the given trial.
##     Returns a data frame of <s> triples with individual counters
##     accessible using category names "less", "equal", and "greater".
##

readTrace <- function (trial, sites) {
  readTraceColumns(trial, 7:9, nrows=nrow(sites))
}


########################################################################
##
##  Read all trace counters
##
##     Expects TRIALS as a vector of <t> trial names as returned by
##     findTrials.  Expects SITES as a data frame of <s> sites as
##     returned by readSiteInfo().
##
##     Reads all counter triples for all sites in all trials.  Returns
##     a (<t> × <s> × 3) array of these counter values.
##

readTraces <- function (trials, sites) {
  dimensions <- c(length(trials), nrow(sites), 3)
  cat("reserving space for", prod(dimensions), "counters: ")
  traces <- array(NA, dimensions)
  cat("done\n")

  n.trials <- length(trials)
  cat("reading", n.trials, "traces:\n")
  for (slot in 1:n.trials) {
    cat(sprintf("\t%d/%d (%.0f%%)\n", slot, n.trials, slot * 100 / n.trials))
    traces[slot,,] <- as.matrix(readTrace(trials[slot], sites))
  }

  traces
}


########################################################################
##
##  End of exports; internal utility functions and tables follow
##


##
## Assemble a complete trial file name
##

trialFileName <- function (trial, suffix) {
  paste(trial, suffix, sep=".")
}


##
## Format of trace files
##

trace.format <- data.frame(t(matrix(c("file", "character",
                                      "line", "integer",
                                      "func", "character",
                                      "left", "character",
                                      "right", "character",
                                      "id", "integer",
                                      "less", "integer",
                                      "equal", "integer",
                                      "greater", "integer"),
                                    2)))
names(trace.format) <- c("name", "class")
                           

##
## Read selected columns of a single trace
##

readTraceColumns <- function (trial, columns, ...) {
  filename <- trialFileName(trial, "trace.gz")
  cutFields <- paste(columns, collapse=",")
  pipeline <- paste("zcat", filename, "| cut -f", cutFields)

  read.table(pipe(pipeline),
             row.names=NULL,
             col.names=as.character(trace.format$name[columns]),
             colClasses=as.character(trace.format$class[columns]),
             sep="\t", quote="", comment.char="",
             ...)
}
