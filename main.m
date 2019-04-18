addpath '/Users/matteo/Downloads/eeglab_last/'
addpath '/Users/matteo/Documents/BCT/2017_01_15_BCT/'
inDir='/Users/matteo/Desktop/2018_2019/Ricerca/scalp_adjust_ALL/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lf=8; %this is for alpha band
hf=13; %this is for alpha band
maxf=40;  %this is for total power comp
nch=64; %number of channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fil_sbj='*R02*';
cases=dir(fullfile(inDir,fil_sbj));
%correl=zeros(length(cases),1);
band_psd_prof=zeros(length(cases),nch);
band_conn_prof=zeros(length(cases),nch);
band_net_prof=zeros(length(cases),nch);
c=zeros(length(cases),1);

for i=1:length(cases)
    i
    file_to_open=strcat(inDir,cases(i).name);
    EEG=pop_biosig(file_to_open);
    [Pxx,F] = pwelch(EEG.data',[],[],[],EEG.srate);
    [low,indlow]=min(abs(F-lf));
    [high,indhigh]=min(abs(F-hf));
    [max,indmax]=min(abs(F-maxf));
    band_psd_prof(i,:)=sum(Pxx(indlow:indhigh,:))./sum(Pxx(1:indmax,:));
    filt_EEG=eegfilt(EEG.data,EEG.srate,lf,hf,0,[],0,'fir1',0);
    %conn=Phase_lag_index(filt_EEG');
    conn=PLV(filt_EEG');      
    %conn=AEC_noorth(filt_EEG');
    %conn=AEC(filt_EEG');
    %conn=corr(filt_EEG');
    %conn=icoh2(filt_EEG');
    band_conn_prof(i,:)=sum(conn,1)/(size(conn,1)-1);
    %cen=strengths_und(conn);
    %cen=betweenness_wei(conn);
    cen=clustering_coef_wu(conn);
    %cen=eigenvector_centrality_und(conn);
    %cen=pagerank_centrality(conn,0.85);
    %Eloc=efficiency_wei(conn,2);
    band_net_prof(i,:)=cen;
    %c(i)=corr(squeeze(band_psd_prof(i,:))',Eloc,'type','Spearman');
    %band_conn_prof=band_conn_prof.*band_psd_prof;
    %correl(i)=corr(band_psd_prof',band_conn_prof','type','Spearman');
end

psd=reshape(band_psd_prof',length(cases)*nch,1);
fc=reshape(band_conn_prof',length(cases)*nch,1);
net=reshape(band_net_prof',length(cases)*nch,1);
[RHOc,PVALc]=corr(psd,fc,'type','Spearman');
[RHOn,PVALn]=corr(psd,net,'type','Spearman');


