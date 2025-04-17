function epsilon = curvatureBasedEpsilon(curvature, baseEpsilon)
    % 根据曲率动态调整epsilon
    maxCurvature = max(curvature);
    if maxCurvature == 0
        epsilon = baseEpsilon; % 如果曲率为零，使用默认值
    else
        epsilon = baseEpsilon * (1 + curvature / maxCurvature);
    end
end