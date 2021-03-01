% generate time series of random spikes

% number of spikes
n = 300;

% inter-spike intervals (exponential distribution for bursts)
% randn : Return a matrix with normally distributed random elements having
%         zero mean and variance one.
isi = round(exp(randn(n,1))*10);

% in each isi there is gonna be a spike
% generate spike time series
spikets = 0;
for i = 1:n
  spikets(sum(isi(1:i))) = 1; 
end

figure(1), clf, hold on
h = plot(spikets)

% implement Gaussian window
fwhm = 25;
k = 20;
gtime = -k:k
gauswin = exp(-(4*log(2)*gtime.^2)/fwhm^2);
gauswin = gauswin / sum(gauswin);

% initialize filtered signal vector
filtsigG = zeros(size(spikets));

% implement the weighted running mean filter
for i=k+1:length(spikets)-k-1
    filtsigG(i) = sum( spikets(i-k:i+k).*gauswin );
end

plot(filtsigG,'r','linew',2)
