function [G,AM,BWNODE,BWcrop,edgenid]=fixgraph(G,BWNODE,BWcrop,BWsk)
BWNODE = BWNODE>0;
BWcrop = BWcrop>0;
LNODE = bwlabel(BWNODE,4);
nodeprops = regionprops(LNODE,'all');
edgeprops = regionprops(BWcrop,'all');

n1d=G.Nodes.Degree(G.Edges.EndNodes(:,1));
n2d=G.Nodes.Degree(G.Edges.EndNodes(:,2));


eind = find(n1d==3 & n2d==3);
eyypl = G.Edges.PixelLength(eind);
kyeyy = eind(eyypl<10); % kyeyy means 可疑的YY型边；可疑的YY型边means两个Y节点可能是一个X节点

% while ~isempty(kyeyy)
disp(['存在可疑YY边',num2str(length(kyeyy)),'条'])
kyeyybw = G.Edges.bwedgeid(kyeyy);% kyeyybw means 可疑的YY型边在BWcrop中的编号；
kyeyyn = G.Edges.EndNodes(kyeyy,:);% kyeyyn means 可疑的YY型边在BWNODE中的编号；
% kyeyyinfo=[kyeyyn,kyeyybw,kyeyy];

YY2X=false(length(kyeyy),1);

for i=2:length(kyeyy)
    middlee=kyeyybw(i);
    n1=kyeyyn(i,1); k1=degree(G,n1);
    n2=kyeyyn(i,2); k2=degree(G,n2);
    n1neighbor=setdiff(neighbors(G,n1),n2);
    n2neighbor=setdiff(neighbors(G,n2),n1);
    n1e=[repelem(n1,k1-1,1),n1neighbor];
    n2e=[repelem(n2,k2-1,1),n2neighbor];
    ne=[n1e;n2e];
    s=ne(:,1);
    t=ne(:,2);
    eid=findedge(G,s,t);
    eidbw=G.Edges.bwedgeid(eid);
    ec=cell((k1-1)*(k2-1), 1);
    for m=1:(k1-1)
        for n=(k1-1)+(1:(k2-1))
            ec{n-(k1-1)+(m-1)*(k2-1)}=[eidbw(m) middlee eidbw(n)];
        end
    end

    bwx=false(size(BWNODE));
    % figure;
    % 提取两个Y节点[n1,n2]
    plistnode = vertcat(nodeprops([n1,n2]).PixelList);
    x=plistnode(:,1);
    y=plistnode(:,2);
    bwn=false(size(BWNODE));
    ind=sub2ind(size(bwn),y,x);
    bwn(ind)=true;
    % figure,imshow(bwn)
    bwqs=bwn & BWsk;% bwqs means bw缺失
    % figure,imshow(bwqs)
    clear x y ind
    ispl=false((k1-1)*(k2-1),1);
    for j=1:length(ec)
        % 提取三个边
        plistegde = vertcat(edgeprops(ec{j}).PixelList);
        x=plistegde(:,1);
        y=plistegde(:,2);
        bwe=false(size(BWNODE));
        ind=sub2ind(size(bwe),y,x);
        bwe(ind)=true;

        clear x y ind

        bwls = bwqs | bwe;
        bwls=bwskel(bwls,'MinBranchLength',5);
        % figure,imshow(bwls)
        % props=regionprops(bwls,'PixelList');
        % pixelList = props.PixelList;
        % x=pixelList(:,1);80-------0
        % y=pixelList(:,2);
        % area=size(x,1);

        ispl(j)=bwIsPolyLine(bwls);% ispl means is polyline
        if ~ispl(j)
            bwx=bwx+bwls;
            % figure;imshow(bwx);
        end
    end
    issl=~ispl;% issl means is straight line
    issl=reshape(issl,k1-1,[]);
    isslcol=any(issl,1);
    if sum(isslcol)>=2
        YY2X(i)=true;
    end
end
% if any(YY2X)
%     kyeyybw=kyeyybw(YY2X,:);
%     kyeyyinfo=kyeyyinfo(YY2X,:);
%     AM(kyeyyinfo(:,1),:)=AM(kyeyyinfo(:,1),:)+AM(kyeyyinfo(:,2),:);
%     AM(:,kyeyyinfo(:,1))=AM(:,kyeyyinfo(:,1))+AM(:,kyeyyinfo(:,2));
%     AM(kyeyyinfo(:,2),:)=[];
%     AM(:,kyeyyinfo(:,2))=[];
% end
if any(YY2X)
    disp(['实际纠正了',num2str(sum(YY2X)),'个YY2X类型错误'])
    kyeyybw=kyeyybw(YY2X,:);

    elimnpxlist=vertcat(edgeprops(kyeyybw).PixelIdxList);
    % bwls=false(size(BWNODE));
    % bwls(elimnpxlist)=true;
    % figure,imshow(bwls)
    BWcrop(elimnpxlist)=false;
    % figure;imshow(BWcrop);        bwcolorbound(BWcrop)
    BWNODE(elimnpxlist)=true;
    % figure;imshow(BWNODE);        bwcolorbound(BWNODE)
end

[AM, edgenid, BWNODE, BWcrop] = construct_adjacency(BWNODE,BWcrop);
G = adjacency2graph(AM,edgenid,BWNODE,BWcrop);

% n1d=G.Nodes.Degree(G.Edges.EndNodes(:,1));
% n2d=G.Nodes.Degree(G.Edges.EndNodes(:,2));
% eind = find(n1d==3 & n2d==3);
% eyypl = G.Edges.PixelLength(eind);
% kyeyy = eind(eyypl<10); % kyeyy means 可疑的YY型边；可疑的YY型边means两个Y节点可能是一个X节点
% end

AM=adjacency(G);