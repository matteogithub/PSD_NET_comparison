load('plv_alpha_plos.mat');
load('psd_plos.mat');
band_net_prof=zeros(size(conn,1),size(conn,2));
for i=1:size(conn,1)
    i
    m=squeeze(conn(i,:,:));
    %net=strengths_und(m);
    %net=betweenness_wei(m);
    %net=clustering_coef_wu(m);
    %net=eigenvector_centrality_und(m);
    %net=pagerank_centrality(m,0.85);
    net=efficiency_wei(m,2);
    band_net_prof(i,:)=net;
end
net=reshape(band_net_prof',size(conn,1)*size(conn,2),1);

[RHOn,PVALn]=corr(psd,net,'type','Spearman');