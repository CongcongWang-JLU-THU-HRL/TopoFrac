function G = adjacency2graph(AM,edgenid,BWNODE,BWcrop)
BWNODE = BWNODE>0;
BWcrop = BWcrop>0;
LNODE = bwlabel(BWNODE,4);
nodeprops = regionprops(LNODE,'all');
node_pos = vertcat(nodeprops.Centroid);
edgeprops = regionprops(BWcrop,'all');
edge_pixlen = vertcat(edgeprops.Area);

s = edgenid(:,1);
t = edgenid(:,2);
bwedgeid=(1:size(edgenid,1)).';
EdgeTable = table([s t], edge_pixlen, bwedgeid,...
    'VariableNames',{'EndNodes' 'PixelLength' 'bwedgeid'});


NodeTable = table(node_pos,'VariableNames',{'Position'});

G = graph(EdgeTable,NodeTable);

G.Nodes.Degree=degree(G);


% figure,plot(G)
% figure,plot(G,'Layout','force')
% figure,plot(G,'Layout','circle')

cc=conncomp(G);
G.Nodes.Conncomp=cc';
fprintf('the number of connected components:\n')
disp(max(cc));

% ci=find(cc==123)
% subG=subgraph(G,ci)
% figure,plot(subG)


%%
%{
figure
hold on
for i=1:numedges(G)
    n1=G.Edges.EndNodes(i,1);
    n2=G.Edges.EndNodes(i,2);
    x1=node_pos(n1,1);
    x2=node_pos(n2,1);
    y1=node_pos(n1,2);
    y2=node_pos(n2,2);
    x=[x1,x2];
    y=[y1,y2];
    line(x,y,'LineStyle','-')% ,'Color','k'
end
axis off
axis equal
[image_row,image_col] = size(BWNODE);
axis([0,image_col,0,image_row])
set(gca,'YDir','reverse');
% saveas(gcf,[prefixname,'-line.svg'])
% print(gcf,[prefixname,'-line.tif'],'-r300','-dtiffn')

axis on
box on
% saveas(gcf,[prefixname,'-line.png'])
% saveas(gcf,[prefixname,'-line.fig'])


tab_cc=tabulate(cc);
tab_cc=sortrows(tab_cc,2,'ascend');
leni=length(find(tab_cc(:,2)==1));

for i=1:leni
    ci=tab_cc(i,1);
    cj=find(cc==ci);
    scatter(node_pos(cj,2),node_pos(cj,1),8,'b','filled')
end
%}