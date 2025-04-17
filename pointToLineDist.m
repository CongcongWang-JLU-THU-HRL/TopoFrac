function dist = pointToLineDist(pt, lineStart, lineEnd)
    % 计算点pt到直线lineStart-lineEnd的距离
    lineVec = lineEnd - lineStart;
    pointVec = pt - lineStart;
    crossProd = abs(det([lineVec; pointVec]));
    lineLength = norm(lineVec);
    dist = crossProd / lineLength;
end