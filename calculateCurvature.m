function curvature = calculateCurvature(points)
    % 计算每个点的曲率
    N = size(points, 1);
    curvature = zeros(N, 1);
    for i = 2:N-1
        x1 = points(i-1, 1);
        y1 = points(i-1, 2);
        x2 = points(i, 1);
        y2 = points(i, 2);
        x3 = points(i+1, 1);
        y3 = points(i+1, 2);
        
        % 曲率公式
        numerator = abs((x2 - x1)*(y3 - y1) - (y2 - y1)*(x3 - x1));
        denominator = sqrt(((x2 - x1)^2 + (y2 - y1)^2) * ...
                           ((x3 - x2)^2 + (y3 - y2)^2) * ...
                           ((x3 - x1)^2 + (y3 - y1)^2));
        if denominator ~= 0
            curvature(i) = numerator / denominator;
        else
            curvature(i) = 0; % 避免除零问题
        end
    end
end


