function [less, equal, greater] = dai_load_many(first, last)
% DAI_LOAD_MANY Load counter triples for several trials
% DAI_LOAD_MANY(FIRST, LAST) loads all counter triples for trials
% FIRST through LAST.  Counters are split out into less, equal, and
% greater, with one column per site and one row per trial.

[less equal greater] = dai_load_range(1, first, last);



function [less, equal, greater] = dai_load_range(depth, first, last)
% DAI_LOAD_RANGE Load counter triples for several trials
% DAI_LOAD_RANGE(DEPTH, FIRST, LAST) loads all counter triples for
% trials FIRST through LAST.  Progress feedback assumes that we are at
% nesting level DEPTH of the tree-structured load process.  Counters
% are split out into less, equal, and greater, with one column per
% site and one row per trial.

spaces = zeros(1,depth) + ' ';

if first >= last
  fprintf(1, '%sload:  %d\n', spaces, last);
  [less equal greater] = dai_load_one(last);
else
  split = floor((first + last) / 2);
  fprintf(1, '%sload:  %d .. %d; %d .. %d\n', spaces, first, split, split + 1, last);
  [less_1 equal_1 greater_1] = dai_load_range(depth + 1, first, split);
  [less_2 equal_2 greater_2] = dai_load_range(depth + 1, split + 1, last);
  fprintf(1, '%smerge: %d .. %d; %d .. %d\n', spaces, first, split, split + 1, last);

  less = [less_1; less_2];
  equal = [equal_1; equal_2];
  greater = [greater_1; greater_2];
end
