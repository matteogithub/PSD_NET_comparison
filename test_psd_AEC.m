nc=64; % number of channels
T = 1; % Length of timeseries in seconds
fs = 256; % Sample rate of timeseries
ns=round(T*fs);
nt=10; %trials
f0 = [2 6 10]; % delta, theta, alpha frequencies
df = 1/T;
data=zeros(nc,ns);
PRtot=linspace(.25,1,100); % ratio of power of last frequency wrt first two
AEC_meas=zeros(nc,nc,length(PRtot));AEC_no_meas=AEC_meas;
AEC_av=zeros(1,length(PRtot));AEC_no_av=AEC_av;
iband=[8 12];
avband=mean(iband);
cycpersec=1/avband;
win5cyc=5*cycpersec;
filtorder=round(fs*win5cyc);
filtPts = fir1(filtorder, 2/fs*iband);
for ip=1:length(PRtot)
    rmsLevel = [1;1;1/sqrt(PRtot(ip))]; % RMS level
    GxxMag = ((rmsLevel.^2)/df); % Single-Sided Power spectrum magnitude
    SxxMag = GxxMag/2; % Double-sided Power spectrum magnitude
    PSD_DoubleSided = zeros(T*fs, 1);
    PSD_DoubleSided(f0*T+1) = SxxMag;
    PSD_DoubleSided(end-f0*T+1) = SxxMag;
    for itrials=1:nt
        for ic=1:nc
            [timeseries, time] = TimeseriesFromPSD(PSD_DoubleSided, fs, T, 0);
            data(ic,:)=timeseries+.001*randn(size(timeseries));
        end
        filteredData = filter(filtPts, 1, data',[],1);
        AEC_meas(:,:,itrials)=AEC(filteredData);
        AEC_no_meas(:,:,itrials)=AEC_noorth(filteredData);
    end
    AEC_av(ip)=nanmean(nanmean(nanmean(AEC_meas)));
    AEC_no_av(ip)=nanmean(nanmean(nanmean(AEC_no_meas)));
end
%%
figure;scatter(1./PRtot,AEC_av);xlabel('PSD((theta+delta)/alpha ratio)');ylabel('|AEC alpha|');set(gca,'FontSize',14)
c=corr((1./PRtot)',AEC_av','Type','Spearman');
title(['Spearman correlation = ' num2str(c)]);
figure;scatter(1./PRtot,AEC_no_av);xlabel('PSD((theta+delta)/alpha ratio)');ylabel('|AEC alpha no orth|');set(gca,'FontSize',14)
c=corr((1./PRtot)',AEC_no_av','Type','Spearman');
title(['Spearman correlation = ' num2str(c)])