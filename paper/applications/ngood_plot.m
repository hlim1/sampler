load ds1000ngood_plot.mat
errorbar(S, mean_ngood, std_ngood);
hold on; plot(S, mean_ngood, 'rx');
xlabel('Number of successful trials used', 'fontsize', 14);
ylabel('Number of "good" features left', 'fontsize', 14);
set(gca, 'ytick', 0:20:150);
axis([-50 3000 0 150]);
grid on;
print -f1 -deps ds1000ngood_plot.eps
