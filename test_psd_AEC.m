nc=64; % number of channels
T = 1; % Length of timeseries in seconds
fs = 256; % Sample rate of timeseries
ns=round(T*fs);
nt=10; %trials
f0 = [20;6]; % two frequencies
df = 1/T;
data=zeros(nc,ns);
PRtot=linspace(1,2,100); % ratio of power of second frequency wrt first one
AEC_meas=zeros(nc,nc,length(PRtot));AEC_no_meas=AEC_meas;
AEC_av=zeros(1,length(PRtot));AEC_no_av=AEC_av;
for ip=1:length(PRtot)
    rmsLevel = [1;1/sqrt(PRtot(ip))]; % RMS level
    GxxMag = ((rmsLevel.^2)/df); % Single-Sided Power spectrum magnitude
    SxxMag = GxxMag/2; % Double-sided Power spectrum magnitude
    PSD_DoubleSided = zeros(T*fs, 1);
    PSD_DoubleSided(f0*T+1) = SxxMag;
    PSD_DoubleSided(end-f0*T+1) = SxxMag;
    for itrials=1:nt
        for ic=1:nc
            [timeseries, time] = TimeseriesFromPSD(PSD_DoubleSided, fs, T, 0);
            data(ic,:)=timeseries+.1*randn(size(timeseries));
        end
        AEC_meas(:,:,itrials)=AEC(data');
        AEC_no_meas(:,:,itrials)=AEC_noorth(data');
    end
    AEC_av(ip)=nanmean(nanmean(nanmean(AEC_meas)));
    AEC_no_av(ip)=nanmean(nanmean(nanmean(AEC_no_meas)));
end
%%
subplot(1,2,1);scatter(PRtot,AEC_av);xlabel('PSD(theta/beta ratio)');ylabel('|AEC|');set(gca,'FontSize',14)
title(['Pearson correlation = ' num2str(corr2(PRtot,AEC_av))])
subplot(1,2,2);scatter(PRtot,AEC_no_av);xlabel('PSD(theta/beta ratio)');ylabel('|AEC no orth|');set(gca,'FontSize',14)
title(['Pearson correlation = ' num2str(corr2(PRtot,AEC_no_av))])