addpath '/Users/matteo/Downloads/eeglab_last/'

inDir='/Users/matteo/Downloads/data_plosone_EEG/data_EEG/';

lf=8; %this is for beta band
hf=13; %this is for beta band
maxf=40;  %this is for total power comp
nch=62; %number of channels
nep=5;
epl=12;
fs=256;

fil_cases='S*';
fil_file='*.eeg';
cases=dir(fullfile(inDir,fil_cases));
my_filtered_data=zeros(length(cases)*nep,nch,epl*fs);
my_raw_data=zeros(length(cases)*nep,nch,epl*fs);


k=0;
for i=1:length(cases)
    i    
    epochs=dir(fullfile(strcat(inDir,cases(i).name),fil_file));
    EEG_raw=pop_biosig(fullfile(strcat(inDir,cases(i).name),epochs.name), 'importevent','off','importannot','off');
    EEG_raw=pop_select(EEG_raw,'nochannel',{'EOG         ' 'ECG         '});
    tmp_data=EEG_raw.data(:,end-60*EEG_raw.srate+1:end);
    %EEG_raw=pop_resample(EEG_raw,256);
    tmp_data=resample(tmp_data',fs,EEG_raw.srate);
    tmp_data=tmp_data';
    tmp_data=reref(tmp_data);
    filt_EEG=eegfilt(tmp_data,fs,lf,hf,0,[],0,'fir1',0);
    for j=1:nep
        en=j*epl;
        in=en-epl;
        k=k+1;
        my_filtered_data(k,:,:)=filt_EEG(:,in*fs+1:en*fs);
        my_raw_data(k,:,:)=tmp_data(:,in*fs+1:en*fs);
    end    
end


