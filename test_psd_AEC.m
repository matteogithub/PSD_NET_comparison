nc=64; % number of channels
T = 1; % Length of timeseries in seconds
fs = 256; % Sample rate of timeseries
ns=round(T*fs);
nt=10; %trials
f0 = [20;6]; % two frequencies
df = 1/T;
PRtot=linspace(1,2,100); % ratio of power of second frequency wrt first one
plv_av=zeros(1,length(PRtot));pli_av=plv_av;
for ip=1:length(PRtot)
    rmsLevel = [1;1/sqrt(PRtot(ip))]; % RMS level
    GxxMag = ((rmsLevel.^2)/df); % Single-Sided Power spectrum magnitude
    SxxMag = GxxMag/2; % Double-sided Power spectrum magnitude
    PSD_DoubleSided = zeros(T*fs, 1);
    PSD_DoubleSided(f0*T+1) = SxxMag;
    PSD_DoubleSided(end-f0*T+1) = SxxMag;
    % implementation of Bruña et al. https://www.ncbi.nlm.nih.gov/pubmed/29952757
    data=zeros(nc,ns,nt);
    for ic=1:nc
        for itrials=1:nt
            [timeseries, time] = TimeseriesFromPSD(PSD_DoubleSided, fs, T, 0);
            data(ic,:,itrials)=timeseries+.1*randn(size(timeseries));
        end
    end
    AEC_meas=AEC(data);
    AEC_av(ip)=nanmean(nanmean(nanmean(AEC_meas)));
    AEC_no_meas=AEC_noorth(data);
    AEC_no_av(ip)=nanmean(nanmean(nanmean(AEC_no_meas)));

end
figure;scatter(PRtot,plv_av);xlabel('PSD(theta/beta ratio)');ylabel('|AEC|');set(gca,'FontSize',14)
figure;scatter(PRtot,pli_av);xlabel('PSD(theta/beta ratio)');ylabel('|AEC no orth|');set(gca,'FontSize',14)