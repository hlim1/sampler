function [less, equal, greater] = dai_load_one(trial)
% DAI_LOAD_ONE Load counter triples for a single trial
% DAI_LOAD_ONE(TRIAL) returns all counter triples for
% TRIAL split out as row vectors LESS, EQUAL, and GREATER.

filename = tempname;

command = ['zcat ../trials/' int2str(trial) '.trace.gz | cut -f7-9 >' filename];
status = unix(command);
if status ~= 0
  error(['cannot collect counters: ' ouput]);
  delete(filename);
end

counters = sparse(load(filename))';
delete(filename);

less = counters(1, :);
equal = counters(2, :);
greater = counters(3, :);
