addpath '/Users/matteo/Downloads/eeglab_last/'
addpath '/Users/matteo/Documents/BCT/2017_01_15_BCT/'
inDir='/Users/matteo/Google Drive/PSD_CONN_comparison/Source/';

lf=8; %this is for alpha band
hf=13; %this is for alpha band
maxf=40;  %this is for total power comp
nch=68; %number of channels
nep=5;
epl=12;
fs=160;

fil_sbj='*R02*';
cases=dir(fullfile(inDir,fil_sbj));
band_psd_prof=zeros(length(cases)*nep,nch);

k=0;
for i=1:length(cases)
    i
    file_to_open=strcat(inDir,cases(i).name);
    EEG=importdata(file_to_open);
    for j=1:nep
        en=j*epl;
        in=en-epl;
        my_data=EEG.Value(:,in*fs+1:en*fs);
        [Pxx,F] = pwelch(my_data',[],[],[],fs);
        [low,indlow]=min(abs(F-lf));
        [high,indhigh]=min(abs(F-hf));
        [max,indmax]=min(abs(F-maxf));
        k=k+1;
        band_psd_prof(k,:)=sum(Pxx(indlow:indhigh,:))./sum(Pxx(1:indmax,:));        
    end    
end
psd=reshape(band_psd_prof',length(cases)*nep*nch,1);


