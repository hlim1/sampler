function results = dai_load_results(trials)
% DAI_LOAD_RESULTS Load results for several trials
% DAI_LOAD_RESULTS(TRIALS) returns a logical column vector giving the
% result for each of the requested TRIALS

results = logical(sparse(0));

for trial = trials
  if mod(trial, 100) == 0
    fprintf(1, 'Loading result %d\n', trial);
  end
  results(trial, 1) = load(['../trials/' int2str(trial) '.result']);
end
