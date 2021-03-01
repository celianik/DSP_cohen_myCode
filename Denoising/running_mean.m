srate = 1000;
time = 0:1/srate:3;
points = length(time);
p = 15; % poles for random interpolation

noiseamp = 5; % noise level, measured in standard deviation
 
ampl = interp1(rand(p,1)*30,linspace(1,p,points));
noise = noiseamp*randn(size(time));
signal = ampl + noise;

%initializing filtered signal vector
filtsig = zeros(size(signal));
% filtsig = signal;

%running mean filter
k = 20; %points that will be added from each side to find the mean
for i = k+1:points-k-1
  filtsig(i) = mean(signal(i-k:i+k));
endfor

%compute window size is ms
windowsize = 1000*(2*k+1)/srate;

figure(1), clf, hold on
plot(time, signal, time, filtsig, 'linew', 2);