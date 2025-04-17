function [G, AM, BWNODE, BWcrop, BWsk] = Frac2G(filename)
% set(0,'defaultfigurecolor','w')
% filename = 'D:\Laura Wang\自己的文章\待完成-裂隙网格拓扑结构分析工具\图片\迹线图\HG-03.jpg';
filename = 'C:\Users\wcc19\Desktop\TopoFrac\example\GSI-03-V2.png';
info = imfinfo(filename);
imct = info.ColorType;
image = imread(filename); % 读取图像
% figure;
% subplot(1,3,1);imshow(image);title('Original')
% 将图像的rgb色彩空间转化为灰度图
% ColorType 包括但不限于：用于真彩色 (RGB) 图像的 'truecolor'、...
% 用于灰阶强度图像的 'grayscale' 或用于索引图像的 'indexed'。
if strcmp(imct,'truecolor')
    image_gray = rgb2gray(image);
    BW = imbinarize(image_gray,'global');
else
    if strcmp(imct,'grayscale')
        image_gray = image;
        BW = imbinarize(image_gray,'global');
    else
        if strcmp(imct,'indexed')
            image_gray = ind2gray(image);
            BW = imbinarize(image_gray,'global');
        else
            if strcmp(imct,'binary')
                BW = image;
            end
        end
    end
end
% image_gray = rgb2gray(image);
% 转化为二值图像
% BW = imbinarize(image_gray,'global');
% subplot(1,3,2);imshow(BW);title('Binary')
% 求二值图像的补
BWicp=imcomplement(BW);
BWicp=bwmorph(BWicp,'majority');
% subplot(1,3,3);imshow(BWicp);title('Binary imcomplement')

%%
% 确定I型节点数量nni和位置:[nni,BWNODEI,L_node_I,image_node_I]
nskel=1;
nnI=NODEI(BWicp,nskel);
delt=Inf;
while delt>0 || length(nnI)<3
    nskel=nskel+1;
    nni=NODEI(BWicp,nskel);
    nnI=[nnI,nni];
    delt=nnI(end-1)-nnI(end);
end
nskel=nskel-1;
[nni,BWNODEI,BWsk,nipos]=NODEI(BWicp,nskel);
disp(['4连通条件下，找到',num2str(nni),'个I型节点'])
% figure,imshow(BWNODEI);title('BWnodei')
% figure,imshow(BWsk);title('BWsk')
%%
% 确定X&Y型节点数量num_node_XY和位置
[nnxy, BWNODEXY,nxypos]=NODEXY_toplimit(BWsk);
disp(['找到',num2str(nnxy),'个XY型节点'])
figure,imshow(BWNODEXY);title('BWnodexy')
%%
% BWNODEXYI=(L_node_I+L_node_XY)>0;
BWNODEI = BWNODEI>0;
BWNODEXY = BWNODEXY>0;
BWNODEXYI = BWNODEI | BWNODEXY;
% figure,imshow(BWNODEXYI)
% [~,num_node_XYI] = bwlabel(BWNODEXYI,4);
% disp(num_node_XYI)
%%
BWcrop=(BWsk-BWNODEXYI)>0;

% BWcrop=bwmorph(BWcrop,'spur');
% figure,imshow(BWcrop)
% [~,n_crop] = bwlabel(BWcrop);
%%
% BWcrop=BWcropclean;
bw=BWcrop;
nnv=Inf;%假设一个很大的值
BWNODE=BWNODEXYI;
nnV=0;
BWNODEV=false(size(BWcrop));
while nnv>0
    % figure,imshow(bw)
    clear nnv bwnv bwcrop bwev
    [nnv,bwcrop,bwnv] = NODEV(bw);
    nnV=nnV+nnv;
    BWNODEV=BWNODEV+bwnv;
    BWNODE=BWNODE+bwnv;
    clear bw
    bw=bwcrop;
end
disp(['合计找到',num2str(nnV),'个V型节点'])

% bwcolorbound(BWcrop,8);
% bwcolorbound(BWNODE,4);

% [Lbwnv,nnv]=bwlabel(BWNODEV,4);
% s = regionprops(Lbwnv,'centroid');
% centroids = cat(1,s.Centroid);
% nvpos = round(centroids);
% hold on
% plot(centroids(:,1),centroids(:,2),'y^')
% hold off
% figure,imshow(bw);title('BWcrop')
% [~,n_]=bwlabel(BWNODE,4)
%%
clear BWcrop;
BWcrop = bw;
% figure,imshow(BWcrop);title('BWcrop')
% [~,num_edge] = bwlabel(BWcrop);
BWNODE=BWNODE>0;
% figure,imshow(BWNODE);title('BWnode')

% [L_node,num_node] = bwlabel(BWNODE);
% image_node_label = label2rgb(L_node);
% disp(num_node)
% figure,imshow(BWNODE | BWcrop);
% figure,imshow(BWcrop);

%%
% bwcolorbound(BWcrop,8)
% bwcolorbound(BWNODE,4)
%%
% BWcrop=bwmorph(BWcrop,"spur");
[AM, edgenid, BWNODE, BWcrop] = construct_adjacency(BWNODE,BWcrop);

[~,nn] = bwlabel(BWNODE,4);
% [~,ne] = bwlabel(BWcrop);
disp(length(unique(edgenid(:,1:2)))==nn)

G = adjacency2graph(AM,edgenid,BWNODE,BWcrop);%
%%
G0=G;
BWNODE0=BWNODE;
BWcrop0=BWcrop;
% bwcolorbound(BWcrop,8);
% bwcolorbound(BWNODE,4);
%%
deg=degree(G);
indI=find(deg==1);
indV=find(deg==2);
indY=find(deg==3);
indX=find(deg>=4);

% size(app.BWNODE)
% size(app.BWsk)
% bwsuppos=(app.BWNODE|app.BWsk);
[LNODE,nn] = bwlabel(BWNODE,4);
s = regionprops(LNODE,'centroid');
centroids = cat(1,s.Centroid);
lw=1.5;
figure;
imshow(BWicp);hold on
plot(centroids(indI,1),centroids(indI,2),'b*','LineWidth',lw)%'MarkerFaceColor',[1,1,1])
plot(centroids(indV,1),centroids(indV,2),'r^','LineWidth',lw)%,'MarkerFaceColor',[1,1,1])
plot(centroids(indY,1),centroids(indY,2),'co','LineWidth',lw)%,'MarkerFaceColor',[1,1,1])
plot(centroids(indX,1),centroids(indX,2),'g+','LineWidth',lw)%,'MarkerFaceColor',[1,1,1])
pd=~cellfun(@isempty,{indI,indV,indY,indX});
nm={'I','V','Y','X'};
legend(nm{pd},'Location','northeastoutside')
%%
[G,AM,BWNODE,BWcrop]=fixgraph(G,BWNODE,BWcrop,BWsk);
%%
deg=degree(G);
indI=find(deg==1);
indV=find(deg==2);
indY=find(deg==3);
indX=find(deg>=4);

% size(app.BWNODE)
% size(app.BWsk)
% bwsuppos=(app.BWNODE|app.BWsk);
[LNODE,nn] = bwlabel(BWNODE,4);
s = regionprops(LNODE,'centroid');
centroids = cat(1,s.Centroid);
lw=1.5;
figure;
imshow(BWicp);hold on
plot(centroids(indI,1),centroids(indI,2),'b*','LineWidth',lw)%'MarkerFaceColor',[1,1,1])
plot(centroids(indV,1),centroids(indV,2),'r^','LineWidth',lw)%,'MarkerFaceColor',[1,1,1])
plot(centroids(indY,1),centroids(indY,2),'co','LineWidth',lw)%,'MarkerFaceColor',[1,1,1])
plot(centroids(indX,1),centroids(indX,2),'g+','LineWidth',lw)%,'MarkerFaceColor',[1,1,1])
pd=~cellfun(@isempty,{indI,indV,indY,indX});
nm={'I','V','Y','X'};
legend(nm{pd},'Location','northeastoutside')
%%
% 计算裂隙分支的长度和角度 
node_pos=G.Nodes.Position;
Length=zeros(numedges(G),1);
Slope=zeros(numedges(G),1);
for i=1:numedges(G)
    n1=G.Edges.EndNodes(i,1);
    n2=G.Edges.EndNodes(i,2);
    x1=node_pos(n1,1);
    x2=node_pos(n2,1);
    y1=node_pos(n1,2);
    y2=node_pos(n2,2);
    v=[x1-x2,y1-y2];
    Length(i)=norm(v);
    Slope(i)=-(y1-y2)/(x1-x2);
end
Slope=atand(Slope);
Slope(Slope<0)=Slope(Slope<0)+180;
G.Edges.Length = Length;
G.Edges.Slope = Slope;


LWidths = 2*G.Edges.Length/max(G.Edges.Length);
spcl = 1+round(255*(Slope-0)./(max(Slope)-0));
disp(spcl)

figure;hold on
clmap=colormap("jet");
for i=1:numedges(G)
    n1=G.Edges.EndNodes(i,1);
    n2=G.Edges.EndNodes(i,2);
    x1=node_pos(n1,1);
    x2=node_pos(n2,1);
    y1=node_pos(n1,2);
    y2=node_pos(n2,2);
    x=[x1,x2];
    y=[y1,y2];
    line(x,y,'LineStyle','-','Color',clmap(spcl(i),:),'LineWidth',LWidths(i,1))
end
cb=colorbar(gca,"eastoutside",...
    'Ticks',linspace(0,1,10),...
    'TickLabels',{'0','20','40','60','80','100','120','140','160','180'},...
    'FontName','Helvetica');
cb.Label.String='Slope';
cb.Label.FontName='Helvetica';
set(gca,'YDir',"reverse");
title('Graph');
daspect( [1 1 1])
axis tight
axis equal
box on
% axis([0,640 0 860])
%%
N=numnodes(G);
nip=length(indI)/N;
nvp=length(indV)/N;
nyp=length(indY)/N;
nxp=length(indX)/N;
fhydrau=max([0,(2.94*(4*nxp+2*nyp))/(4*nxp+2*nyp+nip)-2.13]);
%
type_II=zeros(numedges( G),1); % 1 1
type_IV=zeros(numedges( G),1); % 1 2
type_IY=zeros(numedges( G),1); % 1 3
type_IX=zeros(numedges( G),1); % 1 4(>4)

type_VV=zeros(numedges( G),1); % 2 2
type_VY=zeros(numedges( G),1); % 2 3
type_VX=zeros(numedges( G),1); % 2 4

type_YY=zeros(numedges( G),1); % 3 3
type_YX=zeros(numedges( G),1); % 3 4(>4)

type_XX=zeros(numedges( G),1); % 4(>4) 4(>4)

deg = degree( G);
for i=1:numedges( G)
    n1= G.Edges.EndNodes(i,1);
    n2= G.Edges.EndNodes(i,2);
    d1=deg(n1);
    d2=deg(n2);
    d=[d1,d2];
    if ~isempty(find(d==1, 1))
        if sum(d)==2
            type_II(i)=1;
        end
        if sum(d)==3
            type_IV(i)=1;
        end
        if sum(d)==4
            type_IY(i)=1;
        end
        if sum(d)>=5
            type_IX(i)=1;
        end
    end
    if ~isempty(find(d==2, 1))
        if sum(d)==3
            type_IV(i)=1;
        end
        if sum(d)==4
            type_VV(i)=1;
        end
        if sum(d)==5
            type_VY(i)=1;
        end
        if sum(d)>=6
            type_VX(i)=1;
        end
    end
    if ~isempty(find(d==3, 1))
        if sum(d)==4
            type_IY(i)=1;
        end
        if sum(d)==5
            type_VY(i)=1;
        end
        if sum(d)==6
            type_YY(i)=1;
        end
        if sum(d)>=7
            type_YX(i)=1;
        end
    end
    if ~isempty(find(d==4, 1))
        if sum(d)==5
            type_IX(i)=1;
        end
        if sum(d)==6
            type_VX(i)=1;
        end
        if sum(d)==7
            type_YX(i)=1;
        end
        if sum(d)>=8
            type_XX(i)=1;
        end
    end
end


% type_II+type_IV+type_IY+type_IX+type_VV+type_VY+type_VX+type_YY+type_YX+type_XX
edge_type=zeros(10,1);
edge_type(1,1)=sum(type_II);
edge_type(2,1)=sum(type_IV);
edge_type(3,1)=sum(type_IY);
edge_type(4,1)=sum(type_IX);
edge_type(5,1)=sum(type_VV);
edge_type(6,1)=sum(type_VY);
edge_type(7,1)=sum(type_VX);
edge_type(8,1)=sum(type_YY);
edge_type(9,1)=sum(type_YX);
edge_type(10,1)=sum(type_XX);

edge_type=edge_type./numedges(G);

IIprop=edge_type(1,1);
ICprop=sum(edge_type(2:4,1));
CCprop=sum(edge_type(5:10,1));
assortative_edge_por = sum(edge_type([1,5,8,10], 1));
disassortative_edge_por = sum(edge_type([2,3,4,6,7,9], 1));
%%
% 求边密度
M = numedges(G);
N = numnodes(G);
MN = M/(N);
MNN = 2*M/(N*(N-1));
%%
%确定最大连通分量图及其邻接矩阵
cc=conncomp(G);
n_concom=max(cc);
tab_cc=tabulate(cc);
tab_cc=sortrows(tab_cc,2,'descend');
largcnodes=find(cc==tab_cc(1));
Glargc=subgraph(G,largcnodes);
Alargc=adjacency(Glargc);
%%
% 求G的聚类系数
A=AM;
Cluster=zeros(numnodes(G),1);
for ni=1:numnodes(G)
    Cluster(ni)=node_clustering_coefficient(ni,G,A);
end
Cluster_mean=mean(Cluster);
G.Nodes.Cluster=Cluster;

% 求最大连通分量的平均群聚系数
Clusterlargc=zeros(numnodes(Glargc),1);
for ni=1:numnodes(Glargc)
    Clusterlargc(ni)=node_clustering_coefficient(ni,Glargc,Alargc);
end
Clusterlargc_mean=mean(Clusterlargc);

% 求G和Glargc的效率
[Efficiency_mean,~]=graph_efficiency(G);
[Efficiencylargc_mean,~]=graph_efficiency(Glargc);

% 求G和Glargc的Pearson系数
Pearson_coe = pearson_assortative(G);
Pearson_coe_Glargc = pearson_assortative(Glargc);

% 以上是在MATLAB内部求解的