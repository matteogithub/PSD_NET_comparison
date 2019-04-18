addpath '/Users/matteo/Downloads/eeglab_last/'

%Dir with ADJUSTed edf
inDir='/Users/matteo/Desktop/2018_2019/Ricerca/scalp_adjust_ALL/';

%Select EC-RS only
fil_sbj='*R02*';

lf=8; %this is for beta band
hf=13; %this is for beta band
maxf=40;  %this is for total power comp
nch=64; %number of channels
nep=5;
epl=12;
fs=160;

cases=dir(fullfile(inDir,fil_sbj));
my_filtered_data=zeros(length(cases)*nep,nch,epl*fs);

k=0;
for i=1:length(cases)
    i
    file_to_open=strcat(inDir,cases(i).name);
    EEG=pop_biosig(file_to_open);
    EEG.data=reref(EEG.data);
    filt_EEG=eegfilt(EEG.data,EEG.srate,lf,hf,0,[],0,'fir1',0);
    for j=1:nep
        en=j*epl;
        in=en-epl;
        k=k+1;
        my_filtered_data(k,:,:)=filt_EEG(:,in*fs+1:en*fs);        
    end
end


