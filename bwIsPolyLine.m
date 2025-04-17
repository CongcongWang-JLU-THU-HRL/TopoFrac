function [ispl,nvpos]=bwIsPolyLine(bwls) % ,maxdpl,curv_p_maxdpl
% disp('绿色-在当前的epsilon下就没找到V型的点')
% disp('黄色-在当前的epsilon下找到V型的点但是最终没有V型节点')
% disp('红色-在当前的epsilon下 并且在曲率检测后 还存在V型节点')
if length(find(bwls))< 10
    ispl = false;
    nvpos = [];
    % maxdpl=0;
    % curv_p_maxdpl=0;
else
    % bwcolorbound(bwls,8);
    [B, ~] = bwboundaries(bwls,8,'noholes');
    boundary = B{1};
    endpind=find(bwmorph(bwls,"endpoints"));
    [endpr,endpc]=ind2sub(size(bwls),endpind);

    p=num2cell([endpr,endpc],2);
    [~,pi]=cellfun(@intersect,repmat({boundary},length(endpc),1),p,repmat({'rows'},length(endpc),1),'UniformOutput',false);
    pi=cell2mat(pi);

    cls=nchoosek(pi,2);
    [~,ci]=min(abs(abs(diff(cls,1,2))-size(boundary,1)/2));
    p12i=cls(ci,:);
    p1i=min(p12i);
    p2i=max(p12i);

    n=p2i-p1i+1;
    % 提取边界点的x和y坐标
    x = boundary(p1i:p2i, 2);
    y = boundary(p1i:p2i, 1);
    
    s=[x(1),y(1)];
    t=[x(end),y(end)];
    len=norm(s-t,2);
    %%
    % 用DP算法进行线状要素抽稀判断折点
    points = [x,y]; % points: 输入的点集 (N x 2矩阵)
    % epsilon = len*0.1;
    % epsilon = max([4,len*0.1]); 
    % epsilon = min([50,max([4,len*0.15])]); 
    epsilon = max([4,n*0.15]);% old version 
    % epsilon: 阈值，控制简化的程度——不太好控制

    % epsilon = n*0.05; 
    [simplified] = douglasPeucker(points, epsilon);
    % figure
    % imshow(bwls);hold on
    [~,ixy] = ismember(points,simplified,'rows');
    %ixy 包含了匹配行的索引，即 points 中的每一行在 simplified 中的位置索引
    index = find(ixy);
    % index([1,end]) = [];

    if size(simplified,1) <= 2
        % hold on
        % plot(simplified(:, 1), simplified(:, 2), 'g', 'LineWidth', 2);
        ispl = false;
        nvpos = [];
    else
        %%
        % 计算距离和曲率（曲率值越大，曲线在该点弯曲得越厉害）
        % distpl = zeros(n, 1);
        curvature1 = ones(n, 1);
        curvature2 = ones(n, 1);
        for k=1:length(index)-2
            x1 = x(index(k));
            y1 = y(index(k));
            x3 = x(index(k+2));
            y3 = y(index(k+2));
            v1 = [x3-x1,y3-y1,0];
            % dd = norm(v1);
            v1 = v1/norm(v1);
            v1_3 = -v1;
            clear v2 v2_3 v2cell v2_3cell
            x2 = x( index(k)+1 : index(k+2)-1 );
            y2 = y( index(k)+1 : index(k+2)-1 );
            v2 = [x2-x1,y2-y1,repelem(0,length(x2),1)];
            v2_3 = [x2-x3,y2-y3,repelem(0,length(x2),1)];
            v2cell = num2cell(v2,2);
            v2_3cell = num2cell(v2_3,2);
            v2cell = cellfun(@(c) c/norm(c),v2cell,'UniformOutput',false);
            v2_3cell = cellfun(@(c) c/norm(c),v2_3cell,'UniformOutput',false);
            cv1 = cell2mat( cellfun(@(c) dot(v1,c),v2cell,'UniformOutput',false) );
            cv2 = cell2mat( cellfun(@(c) dot(v1_3,c),v2_3cell,'UniformOutput',false) );
            curvature1( index(k)+1:index(k+2)-1 ) = min(cv1, curvature1(index(k)+1:index(k+2)-1) );
            curvature2( index(k)+1:index(k+2)-1 ) = min(cv2, curvature2(index(k)+1:index(k+2)-1) );
        end
        cvmax = max(curvature1,curvature2); % cvmax(index)
        cvmin = min(curvature1,curvature2); % cvmin(index)
        % cvav = curvature1/2+curvature2/2;  % cvav(index)
        w1 = 0.2; w2 = 1-w1; % cvav(index)
        cvav = cvmax*w1+cvmin*w2;
        kinkpt_cv=cvav(index);
        crdeg=13;
        index=index(kinkpt_cv< cosd(crdeg));
        simplified=[points(1,:);points(index,:);points(end,:)];
        %%
        if size(simplified,1) <= 2
            % hold on
            % plot(simplified(:, 1), simplified(:, 2), 'y', 'LineWidth', 2);
            ispl = false;
            nvpos = [];
        else
            % hold on
            % plot(simplified(:, 1), simplified(:, 2), 'r', 'LineWidth', 2);
            % scatter(simplified(2:end-1, 1), simplified(2:end-1, 2), 'blue', 'filled');
            ispl = true;
            nvpos = simplified(2:end-1,:);
        end
    end
end