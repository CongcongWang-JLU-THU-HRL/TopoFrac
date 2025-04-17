function [nnv,bwcrop,bwnv,bwev] = NODEV(bw)
% bwcolorbound(bw);
% 查找连通分量
cc = bwconncomp(bw);

% 计算连通分量的属性
props = regionprops(cc, 'all');

% 初始化存储折线判断结果的数组
isPolyline = false(length(props), 1);
nvpos = cell(length(props), 1);
% maxdpl = zeros(length(props), 1);
% curv_p_maxdpl = zeros(length(props), 1);
bwev=false(size(bw));
% figure;imshow(bw)
for i = 1:length(props)
    % 获取连通分量的像素列表
    pixelList = props(i).PixelList;
    x=pixelList(:,1);
    y=pixelList(:,2);

    bwls=false(size(bw));
    ind=sub2ind(size(bwls),y,x);
    bwls(ind)=true;
    % figure, 
    % hold on;
    % bwev=bwev+bwls;
    % imshow(bwev)
    [isPolyline(i),nvpos{i}]=bwIsPolyLine(bwls);
    % isPolyline(i)
    if isPolyline(i)
        % 如果是折线，则绘制该分量
        ind=sub2ind(size(bwev),y,x);
        bwev(ind)=true;
        % imshow(bwev)
    end
end

nvpos = cell2mat(nvpos);
nnv = size(nvpos,1);
if nnv>0
    disp(['找到',num2str(size(nvpos,1)),'个V型节点'])
    x=nvpos(:,1);
    y=nvpos(:,2);
    ind=sub2ind(size(bwev),y,x);
    bwnv=false(size(bw));
    bwnv(ind)=true;
    bwnv=bwmorph(bwnv,'thicken');
    % figure;imshow(bwnv);

    bwcrop=(bw-bwnv)>0;
    % figure;imshow(bwcrop);
else
    bwnv=false(size(bw));
    bwcrop=(bw-bwnv)>0;
end


