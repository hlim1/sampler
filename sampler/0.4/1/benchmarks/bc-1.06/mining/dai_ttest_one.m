function [significance, interval] = dai_ttest_one(results, counts)
% DAI_TTEST_ONE Test one feature for differences
% DAI_TTEST_ONE(RESULTS, COUNTS) tests whether COUNTS differs
% significantly in trials that succeed versus trials that fail.
% Success or failure is determined by RESULTS, which must be a vector
% of the same length as COUNTS.  Returns the significance level and
% 99% confidence interval of the two sample t-test.

failure_counts = counts(results);
success_counts = counts(~results);

[accept, significance, int] = ttest2(failure_counts, success_counts);
interval = full(int);
