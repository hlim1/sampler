load ds1000ngood_plot.mat
errorbar(S, mean_ngood, std_ngood);
hold on; plot(S, mean_ngood, 'rx');
xlabel('Number of successful trials used', 'fontsize', 12);
ylabel('Number of "good" features left', 'fontsize', 12);
grid on;
axis([-50 4000 -20 180]);
print -f1 -deps ds1000ngood_plot.eps

