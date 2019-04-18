load('alpha_filtered_data_plos.mat');


for i=1:size(my_filtered_data,1)
    i    
    m=squeeze(my_filtered_data(i,:,:));
    %conn(i,:,:)=PLV(m');
    conn(i,:,:)=AEC_noorth(m');
    %conn(i,:,:)=Phase_lag_index(m');
    %conn(i,:,:)=icoh2(m');
    %conn(i,:,:)=AEC(m');  
end