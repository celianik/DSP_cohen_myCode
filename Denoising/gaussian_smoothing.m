srate = 1000;
time = 1:1/srate:3;
n = length(time);
p = 15; % poles for random interpolation

noiseamp = 5;

ampl = interp1(rand(p,1)*30,linspace(1,p,n));
noise = noiseamp*randn(size(time));
signal = ampl + noise;

% full width halp-maximum
fwhm = 25;

%normalized time vector in ms
k = 50;  %has lower and upper bounds
gtime = 1000*(-k:k)/srate;

gauswin = exp(-(4*log(2)*gtime.^2)/fwhm^2);

% IDX = dsearchn (X, XI) :  Return the index IDX of the closest point in X to the elements XI.
prePeakHalf = k + dsearchn(gauswin(k+1:end)',.5); % return num from gaussian that is closest to 0.5
pstPeakHalf = dsearchn(gauswin(1:k)',.5);

empFWHM = gtime(prePeakHalf) - gtime(pstPeakHalf)

figure(1), clf, hold on
plot(gtime, gauswin, 'ko-', 'markerfacecolor', 'w' ,'linew', 2)
plot(gtime([prePeakHalf pstPeakHalf]), gauswin([prePeakHalf pstPeakHalf]),'m','linew',3)

% normazile Gaussian to unit energy
gauswin = gauswin / sum(gauswin);

% implement Gaussian smoothing filter
filtSig = signal;

for i = k+1:n-k-1 
  filtSig(i) = sum(signal(i-k:k+i).*gauswin);
endfor

figure(2), clf, hold on
plot(time,signal,'r')
plot(time,filtSig,'k','linew',3)

