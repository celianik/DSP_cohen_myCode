n = 2000;
signal = cumsum(randn(n,1));

% proportion of time points to be replaced with noise --> 5%
propnoise = .05;

% randperm : returns a row vector containing a random permutation 
% of the integers from 1 to n WITHOUT REPEATING ELEMENTS.
% f.e. r = randperm(6) --> r (1x6) = [ 6 3 5 1 2 4 ]

% create a matrix with the a random order of the indeces of signal 
% select a proportion of them to be converted to spikes

noisepnts = randperm(n);
noisepnts = noisepnts(1:round(n*propnoise));

signal(noisepnts) = 50 + rand(size(noisepnts))*100;

figure(1), clf
hist(signal,100)
zoom on

% calculate the median of particularly large values
% to decide which values are particularly large compare them to a
% threshold, which will be found by looking at the histogram

thres = 45;

thres_pnts = find(signal > thres);

% initialize filtered singal and implement median filtered
filtSig = signal;

% k is used to compute a window in which values will be taken
% in order to prevent any errors (error containment)
% if there is a spike at the very beginning or end of the signal
% then by adding/subtracting k will get us out of bounds
% that's why max and min are used respectively when calculating
% the lower and upper bounds.

k = 20;
for i =1:length(thres_pnts)
  
  low_bnd = max(1,thres_pnts(i)-k);
  upper_bnd = min(thres_pnts(i)+k,n);
  
  filtSig(thres_pnts(i)) = median(signal(low_bnd:upper_bnd));
endfor

figure(2), clf
plot(1:n, signal, 1:n, filtSig, 'linew',2)