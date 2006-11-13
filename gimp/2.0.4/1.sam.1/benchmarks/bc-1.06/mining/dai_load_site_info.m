function [file, line, func, left, right, id] = dai_load_site_info
% DAI_LOAD_SITES Load site information
% DAI_LOAD_SITES returns trial-independent information on
% instrumentation sites

filename = tempname;

command = ['zcat ../trials/1.trace.gz | cut -f1-6 >' filename];
status = unix(command);
if status ~= 0
  error(['cannot collect site info: ' ouput]);
  delete(filename);
end

[file line func left right id] = textread(filename, '%s %d %s %s %s %d', ...
                                          'delimiter', '\t', ...
                                          'whitespace', '');

file = file';
line = uint32(line');
func = func';
left = left';
right = right';
id = uint32(id');
