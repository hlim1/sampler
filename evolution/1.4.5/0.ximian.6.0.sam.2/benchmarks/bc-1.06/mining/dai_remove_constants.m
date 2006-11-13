function result = dai_remove_constants(counters)
% DAI_REMOVE_CONSTANTS Remove constant columns
% DAI_REMOVE_CONSTANTS(COUNTERS) zeros out any columns in
% COUNTERS which have a single constant value in every row.

[rows, columns] = size(counters);
result = sparse(rows, columns);
for column = 1:columns
  slice = counters(:, column);
  switch nnz(slice)
   case 0
    % zero on every row: already sparse
   case rows
    % nonzero on every row: might be constant
    values = nonzeros(slice);
    template = zeros(rows,1) + values(1);
    if (~isequal(template, values))
      result(:, column) = slice;
    end
   otherwise
    % some zero, some non-zero: not constant
    result(:, column) = slice;
  end
end
