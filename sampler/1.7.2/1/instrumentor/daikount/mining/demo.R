source("load.R")

trials <- findTrials("/var/local/liblit/forensics/bc-trials-small")
sites <- readSiteInfo(trials)
results <-readResults(trials)
traces <- readTraces(trials, sites)

cat("counter triple for trial 1, site 4450:", traces[1,4450,], "\n")
cat("exit signal for trial 2:", results[2], "\n")
cat("function for site 7170:", sites$func[7170], "\n")
