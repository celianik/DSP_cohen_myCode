load templateProjection.mat

% Mat contents: EEGdat, eyedat, npnts, timevec
% EEGdat, eyedat : time points x repetitions
% the movement of the eyes can cause artifacts in the eeg channels
% placed on the head, it's important to seperate the data coming 
% from the eyeball from the EEG data 

% initialize residual data, same size as EEGdat
resdat = zeros(size(EEGdat));

% repeat for all repetitions
% implement regression model
for ti = 1:size(resdat,2)
  
  X = [ ones(npnts,1) eyedat(:,ti)];
  b = (X'*X)\(X'*EEGdat(:,ti));
  yHat = X*b;
  resdat(:,ti) = (EEGdat(:,ti) - yHat)';

end

% plot for all reps 
figure(1), clf
plot(timevec,mean(eyedat,2), timevec,mean(EEGdat,2), timevec,mean(resdat,2),'linew',2)
legend({'EOG';'EEG';'Residual'})
xlabel('Time (ms)')


% show all reps in a map
clim = [-1 1]*20;


figure(2), clf
subplot(1,3,1)
imagesc(timevec,[],eyedat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EOG')


subplot(1,3,2)
imagesc(timevec,[],EEGdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('Uncorrected EEG')


subplot(1,3,3)
imagesc(timevec,[],resdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('Cleaned EEG data')