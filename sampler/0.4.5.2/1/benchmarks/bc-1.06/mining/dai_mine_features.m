function sorted = dai_mine_features(results, less, equal, greater)

% fprintf(1, 'Clipping data...\n');
% clip = 1:200;
% results = logical(results(clip, :));
% less = less(:, clip);
% equal = equal(:, clip);
% greater = greater(:, clip);

fprintf(1, 'Assembling counts...\n');
counters = [less equal greater];

[sigs, ints] = dai_ttest_many(results, counters);

fprintf(1, 'Assembling features...\n');
[ntrials, nsites] = size(greater);
summary = [sigs;
           ints;
           repmat(1:nsites, 1, 3);
           repmat(1, 1, nsites) repmat(2, 1, nsites) repmat(3, 1, nsites) ]';

fprintf(1, 'Filtering features...\n');
summary = summary(summary(:, 1) < 1, :);

fprintf(1, 'Sorting features...\n');
sorted = sortrows(summary, 1);
