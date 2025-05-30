function [AM, edgenid, BWNODE, BWcrop] = construct_adjacency(BWNODE,BWcrop)
%%
onev=Inf;
while onev>0
    BWcrop = BWcrop>0;
    BWNODE = BWNODE>0;
    
    [L_node,nn] = bwlabel(BWNODE,4);
    % [L_node,nn] = bwlabel(BWNODE,8);
    [~,ne] = bwlabel(BWcrop,8);
    % 查找连通分量
    bw=BWcrop>0;
    cc = bwconncomp(bw);
    % 计算连通分量的属性
    props = regionprops(cc, 'all');
    % propsnode = regionprops(BWNODE, 'all');

    onev=0;
    for i=1:ne
        % 获取连通分量的像素列表
        pixelList = props(i).PixelList;
        x=pixelList(:,1);
        y=pixelList(:,2);

        bwls=false(size(bw));
        ind=sub2ind(size(bwls),y,x);
        bwls(ind)=true;
        % figure,imshow(bwls)
        bwls=bwmorph(bwls,'fatten');
        % figure,imshow(bwls)

        % ind = find(bwls);
        nid = L_node(bwls);
        nid (nid==0) = [];
        nid = unique(nid,'rows','stable');
        
        if length(nid)>2
            disp(['第',num2str(i),'条边关联了不止两个顶点，请检查！'])
            % 情况1：fatten时碰到了迹线两侧的节点
        else
            if isscalar(nid)
                disp(['第',num2str(i),'条边只关联了1个顶点'])
                % 处理就是不要这条边了
                BWNODE = BWNODE+bwls;
                BWcrop = BWcrop-bwls;
                onev = onev+1;
            end
        end
    end
end
%%
[L_node,nn] = bwlabel(BWNODE,4);
[~,ne] = bwlabel(BWcrop);
AM=zeros(nn);

% 查找连通分量
bw=BWcrop>0;
cc = bwconncomp(bw);
% 计算连通分量的属性
props = regionprops(cc, 'all');

edgenid=cell(ne,1);
for i=1:ne
    % 获取连通分量的像素列表
    pixelList = props(i).PixelList;
    x=pixelList(:,1);
    y=pixelList(:,2);

    bwls=false(size(bw));
    ind=sub2ind(size(bwls),y,x);
    bwls(ind)=true;
    % figure,imshow(bwls)
    bwls=bwmorph(bwls,'fatten');
    % figure,imshow(bwls)

    % ind = find(bwls);
    nid = L_node(bwls);
    nid(nid==0) = [];
    nid = unique(nid,'rows','stable');
    
    
    if length(nid)>2
        disp(['第',num2str(i),'条边关联了不止两个顶点，请检查！'])
        % 情况1：fatten时碰到了迹线两侧的节点
        nid (2:end-1)=[];

        edgenid{i}=nid';
        AM(nid(1),nid(2))=1;
        AM(nid(2),nid(1))=1;
    else
        edgenid{i}=nid';
        AM(nid(1),nid(2))=1;
        AM(nid(2),nid(1))=1;
    end
end
edgenid=cell2mat(edgenid);