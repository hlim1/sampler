y=[2 0 3 1 5 5 6 9 5 9];
x=(1:10)';
X=[ones(10,1) x];

[theta, beta, dev, dl, d2l, gamma]=logistic_regression(y,x,1)
