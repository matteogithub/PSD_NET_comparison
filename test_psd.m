nc=64; % number of channels
T = 1; % Length of timeseries in seconds
fs = 256; % Sample rate of timeseries
ns=round(T*fs);
nt=10; %trials
f0 = [8;20]; % two frequencies
df = 1/T;
PRtot=linspace(1,2,100); % ratio of power of second frequency wrt first one
plv_av=zeros(1,length(PRtot));pli_av=plv_av;wpli_av=plv_av;
for ip=1:length(PRtot)
    rmsLevel = [1;1/sqrt(PRtot(ip))]; % RMS level
    GxxMag = ((rmsLevel.^2)/df); % Single-Sided Power spectrum magnitude
    SxxMag = GxxMag/2; % Double-sided Power spectrum magnitude
    PSD_DoubleSided = zeros(T*fs, 1);
    PSD_DoubleSided(f0*T+1) = SxxMag;
    PSD_DoubleSided(end-f0*T+1) = SxxMag;
    % implementation of Bruña et al. https://www.ncbi.nlm.nih.gov/pubmed/29952757
    data=zeros(nc,ns,nt);data_h=data;
    for ic=1:nc
        for itrials=1:nt
            [timeseries, time] = TimeseriesFromPSD(PSD_DoubleSided, fs, T, 0);
            data(ic,:,itrials)=timeseries+.1*randn(size(timeseries));
            data_h(ic,:,itrials)=hilbert(timeseries+.1*randn(size(timeseries)));
        end
    end
    % here compute phase locking value as in Bruña et al. 
    ndat = data_h ./ abs(data_h);
    plv = zeros(nc, nc, nt);
    for t = 1: nt
        plv(:,:, t) = abs(ndat(:,:, t)*ndat(:,:, t)') / ns;
    end
    plv_av(ip)=mean(mean(mean(plv)));
    % here compute (weighted) phase lag index
    [pli, wpli]=wpli_sin(data_h);
    pli_av(ip)=nanmean(nanmean(nanmean(pli)));
    wpli_av(ip)=nanmean(nanmean(nanmean(wpli)));
end
figure;scatter(PRtot,plv_av);xlabel('PSD(alpha ratio)');ylabel('|PLV|');set(gca,'FontSize',14)
figure;scatter(PRtot,pli_av);xlabel('PSD(alpha ratio)');ylabel('|PLI|');set(gca,'FontSize',14)
figure;scatter(PRtot,wpli_av);xlabel('PSD(alpha ratio)');ylabel('|wPLI|');set(gca,'FontSize',14)
