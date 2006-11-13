function dai_dump_features(site_info, features)

relops = ['<', '=', '>'];

fid = fopen('ttest-dump', 'w');
for feature = features'
  sig = feature(1);
  lower = feature(2);
  upper = feature(3);
  site = feature(4);
  relop = relops(feature(5));

  file = char(site_info.file(site));
  line = double(site_info.line(site));
  func = char(site_info.func(site));
  left = char(site_info.left(site));
  right = char(site_info.right(site));
  id = double(site_info.id(site));

  fprintf(fid, '%g\t%g\t%g\t%d\t%s\t%d\t%s\t%d\t%s\t%s\t%s\n', sig, lower, upper, site, file, line, func, id, left, relop, right);
end
fclose(fid);
