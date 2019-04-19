load('aecc_alpha.mat');
load('psd.mat');
band_net_prof=zeros(size(conn,1),size(conn,2));
for i=1:size(conn,1)
    i
    m=squeeze(conn(i,:,:));
    %net=strengths_und(m);
    %net=clustering_coef_wu(m);
    net=betweenness_wei(m);
    
    %net=eigenvector_centrality_und(m);
    %net=pagerank_centrality(m,0.85);
    %net=efficiency_wei(m,2);
    band_net_prof(i,:)=net;
end
net=reshape(band_net_prof',size(conn,1)*size(conn,2),1);

[RHOn,PVALn]=corr(psd,net,'type','Spearman');

scatter(psd,net,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0.85 0.85 0.85]);

coefficients = polyfit(psd, net, 1);
xFit = linspace(min(psd), max(psd), 1000);
yFit = polyval(coefficients , xFit);
hold on;
plot(xFit, yFit, 'k-', 'LineWidth', 3);
grid on;

ax = gca;
ax.FontSize = 20; 

saveas(gcf,'test.jpg')

close