t = 0:0.001:4;
clf;
plot(t, 1./(1+exp(3*(2-t))));
print -f1 -deps logisticfcnplot.eps
