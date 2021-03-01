% create a polynomial

order = 23; 
x = linspace(-15,15,100);

y = zeros(size(x));

for i = 1:order+1
  y = y + randn*x.^(i-1);
endfor

figure(1), clf, hold on
plot(x,y,'linew',4)
title(['order-' num2str(order) ' polynomial'])

% generate signal with slow polynomial artifact

n = 10000;
t = (1:n)' ;
k = 10; % number of poles for random amlitudes
slowdrift = interp1(100*randn(k,1),linspace(1,k,n),'pchip')';
signal = slowdrift + 20*randn(n,1);

figure(2), clf, hold on
h = plot(t,signal);
set(h,'color',[1 1 1]*.6)
xlabel('Time (a.u.)'), ylabel('Amplitude')

% polynomial fitting
% polyfit(x,y,n) : returns the coefficients for a polynomial p(x) 
% of degree n that is a best fit (in a least-squares sense) for 
% the data in y. The coefficients in p are in descending powers, 
% and the length of p is n+1
p = polyfit(t,signal,3);

% predicted data is evaluation of polynomial
% polyval(p,x) : evaluates the polynomial p at each point in x. 
% The argument p is a vector of length n+1 whose elements are 
% the coefficients (in descending powers) of an nth-degree polynomial
yHat = polyval(p,t);

residual = signal - yHat;

plot(t,yHat,'r','linew',4)
plot(t,residual,'k','linew',2)

legend({'Original'; 'Polyfit'; 'Filtered Signal'})

% Bayes information criteria
% b = n*ln(?) + k*ln(n)
% ? = n^(-1)*sum(y_predicted - y_actual) from 1 to n

orders = (5:40)' ;

% sum of squared errors 
sse1 = zeros(length(orders),1);

for ri = 1:length(orders)
  yHat = polyval(polyfit(t,signal,orders(ri)),t);
  sse1(ri) = sum( (yHat - signal).^2)/n;
endfor

bic = n*log(sse1) + orders*log(n);
[bestOrd, idx] = min(bic);

figure(3), clf, hold on
plot(orders,bic,'ks-','markerfacecolor','w','markersize',8)
plot(orders(idx),bestOrd,'ro','markersize',10,'markerfacecolor','r')
xlabel('Polynomial order'), ylabel('Bayes information criterion')
zoom on

% repeat polynomial detrend for best fitting order
polycoeffs = polyfit(t,signal,orders(idx));
yHat = polyval(polycoeffs,t);
filtSig = signal - yHat;

figure(4), clf, hold on
h = plot(t,signal);
set(h,'color',[1 1 1]*.6)
plot(t,yHat,'r','linew',2)
plot(t,filtSig,'k')
set(gca,'xlim',t([1 end]))

xlabel('Time (a.u.)'), ylabel('Amplitude')
legend({'Original';'Polynomial fit';'Filtered'})
