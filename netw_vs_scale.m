% the Brain Connectivity Toolbox is needed

%% generate random network
netw=.1*rand(64);
scale=linspace(1,10,100);
%% strength for increasing values of the random network
for iscale=1:length(scale);s(iscale)=mean(strengths_und(scale(iscale)*netw));end
figure;scatter(scale,s);xlabel('network scale');ylabel('|S|');set(gca,'FontSize',14)
%% clustering coefficient for increasing values of the random network
for iscale=1:length(scale);CC(iscale)=mean(strengths_und(scale(iscale)*netw));end
figure;scatter(scale,CC);xlabel('network scale');ylabel('|CC|');set(gca,'FontSize',14)
%% betweenness centrality for increasing values of the random network
for iscale=1:length(scale);BC(iscale)=mean(betweenness_wei(scale(iscale)*netw));end
figure;scatter(scale,BC);xlabel('network scale');ylabel('|BC|');set(gca,'FontSize',14)