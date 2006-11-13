[less equal greater] = dai_load_many(1, 5300);

fprintf(1, 'Filtering out constant columns: less\n');
less = dai_remove_constants(less);
fprintf(1, 'Filtering out constant columns: equal\n');
equal = dai_remove_constants(equal);
fprintf(1, 'Filtering out constant columns: greater\n');
greater = dai_remove_constants(greater);

save 'counters.mat';
