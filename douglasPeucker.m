function [simplified] = douglasPeucker(points, epsilon)
% Douglas-Peukcer算法由D.Douglas和T.Peueker于1973年提出，是线状要素抽稀的经典算法。
% 用它处理大量冗余的几何数据点，既可以达到数据量精简的目的，可以在很大程度上保留几何形状的骨架。
    % points: 输入的点集 (N x 2矩阵)
    % epsilon: 阈值，控制简化的精度

    % 如果点集小于10个点，则直接返回
    % 10个是不是太大了
    if size(points, 1) < 10
        simplified = points([1,end],:);
        return;
    end

    % 找到曲线的最大距离
    startPoint = points(1, :);
    endPoint = points(end, :);
    maxDist = 0;
    index = 0;
    
    % 计算每个点到直线的距离
    for i = 2:size(points, 1) - 1
        dist = pointToLineDist(points(i, :), startPoint, endPoint);
        if dist > maxDist
            maxDist = dist;
            index = i;
        end
    end
    
    % 如果最大距离大于阈值，则分成两部分递归处理
    if maxDist > epsilon
        % 递归调用Douglas-Peucker算法
        firstHalf = douglasPeucker(points(1:index, :), epsilon);
        secondHalf = douglasPeucker(points(index:end, :), epsilon);
        
        % 合并结果，去除重复的点
        simplified = [firstHalf(1:end-1, :); secondHalf];
    else
        % 否则只保留起始点和终止点
        simplified = [startPoint; endPoint];
    end
end


