function [significances, intervals] = dai_ttest_many(results, counters)
% DAI_TTEST_MANY Test all features for differences

[rows, columns] = size(counters);
significances = ones(1, columns);
intervals = zeros(2, columns);

for column = 1:columns
  if mod(column, 100) == 0
    fprintf(1, 'Testing column %d (%d%%)\n', column, round(100 * column / columns));
  end

  counts = counters(:, column);
  if nnz(counts) ~= 0
    [significance, interval] = dai_ttest_one(results, counts);
    significances(column) = significance;
    intervals(1, column) = interval(1);
    intervals(2, column) = interval(2);
  end
end
