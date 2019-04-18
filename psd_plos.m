load('raw_data_plos.mat');
band_psd_prof=zeros(size(my_raw_data,1),size(my_raw_data,2));

lf=8; %this is for alpha band
hf=13; %this is for alpha band
minf=1;
maxf=40;  %this is for total power comp
fs=256;

for i=1:size(my_raw_data,1)
    i    
    m=squeeze(my_raw_data(i,:,:));
    [Pxx,F] = pwelch(m',[],[],[],fs);
    [low,indlow]=min(abs(F-lf));
    [high,indhigh]=min(abs(F-hf));
    [max,indmax]=min(abs(F-maxf));
    [min,indmin]=min(abs(F-minf));
    band_psd_prof(i,:)=sum(Pxx(indlow:indhigh,:))./sum(Pxx(indmin:indmax,:));
end
psd=reshape(band_psd_prof',size(my_raw_data,1)*size(my_raw_data,2),1);


