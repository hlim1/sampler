data = load('bc_density.txt');

hold off;
plot([0 6], [1 1], '-k');

hold on;
always = bar(data(1));
samples = bar(2:5, data(2:5));
colormap([0.6 0.6 0.6; 0.8 0.8 0.8]);
set(always, 'CData', 1);
set(samples, 'CData', 2);

xlabel('Sampling density', 'fontsize', 14);
set(gca, 'XLim', [0.5 5.5]);
set(gca, 'XTick', 1:5);
set(gca, 'XTickLabel', {'always', '1/100', '1/1000', '1/10,000', '1/1,000,000'});

ylabel('Relative performance', 'fontsize', 14);
set(gca, 'YGrid', 'on');
set(gca, 'YLim', [0.9, 1.15]);
set(gca, 'YTick', 0.9:0.05:1.15);


print -f1 -deps 'bc_density.eps';
