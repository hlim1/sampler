load ds1000ngood_plot.mat
errorbar(S, mean_ngood, std_ngood);
hold on; plot(S, mean_ngood, 'rx');
xlabel('Number of successful trials used', 'fontsize', 12);
ylabel('Number of "good" features left', 'fontsize', 12);
set(gca, 'ytick', 0:20:150);
axis([-50 3000 0 150]);
grid on;
print -f1 -deps ccrypt-data/ds1000ngood_plot.eps
