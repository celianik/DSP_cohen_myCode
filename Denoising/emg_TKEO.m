load emg4TKEO.mat

%initialize filtered signal 
emgf = emg;

% implement TKEO with loops
for i = 2:length(emgf)-1
  emgf(i) = emg(i)^2 - emg(i-1)*emg(i+1);
end

% implement TKEO with vectorization
emgf2 = emg;
emgf2(2:end-1) = emg(2:end-1).^2 - emg(1:end-2).*emg(3:end);

% the original emg signal and the filtered emg signal are no longer
% in the exact same scale (emg -> mV , emgf/emgf2 -> (mV)^2, so as 
% to compare them I calculate the z score

% the output emg has values before t=0 so I search in emgtime matrix
% the closest value to 0 and set it as time0
% I calculate the z-score only for values of the signal below time0
% when there is no significant activity, in order to find peaks in 
% the rest of the signal where the values are larger than zscore

time0 = dsearchn(emgtime',0);

emgZ = (emg - mean(emg(1:time0))) / std(emg(1:time0));

emg2Z = (emgf2 - mean(emgf2(1:time0))) / std(emgf2(1:time0));

%% plot

figure(1), clf

% normalizing : divide by max(emg),max(emgf) to bring down 
% the scale to 1
subplot(2,1,1), hold on
plot(emgtime, emg./max(emg),'b','linew',2)
plot(emgtime, emgf./max(emgf),'m','linew',2)

xlabel('Time (ms)'), ylabel('Amplitude or energy')
legend({'EMG'; 'EMG Energy (TKEO)'})

subplot(2,1,2), hold on
plot(emgtime, emgZ,'b','linew',2)
plot(emgtime, emg2Z,'m','linew',2)

xlabel('Time (ms)'), ylabel('Zscore relative to pre-stimulus')
legend({'EMG'; 'EMG Energy (TKEO)'})