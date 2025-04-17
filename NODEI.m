function [nni,bwni,BWsk,nipos]=NODEI(BWicp,nskel)
% figure,imshow(BWicp)
SE = strel("disk",1);
BWer = imerode(BWicp,SE);
% figure,imshow(BWer)

BWsk1 = bwskel(BWer,'MinBranchLength',nskel);
% figure,imshow(BWsk1)

% bwskel: Reduce all objects to lines in 2-D binary image
BWsk2 = bwskel(BWicp,'MinBranchLength',nskel);
% figure,imshow(BWsk2)

BWsk12 = BWsk1 | BWsk2;
% figure,imshow(BWsk12)

BWsk = bwskel(BWsk12,'MinBranchLength',nskel);
% figure,imshow(BWsk)

BWsk = bwmorph(BWsk,'shrink');
% 使用 n = Inf，通过从对象边界删除像素，将对象收缩为点。
% 使没有孔洞的对象收缩为点，有孔洞的对象收缩为每个孔洞和外边界之间的连通环。
% 此选项保留欧拉数（也称为欧拉示性数）。
% figure,imshow(BWsk);title('BWsk')

% 确定I型节点数量num_node_I和位置
bwni = bwmorph(BWsk,'endpoints');
% figure,imshow(bwni);

% BWNODEI=bwmorph(BWNODEI,'diag');
% figure
% imshow(BWNODEI)

bwni=bwmorph(bwni,'thicken',2);
% 在 n = Inf 时，通过向对象外部添加像素来加厚对象，直到先前未连通的对象实现 8 连通为止。此选项会保留欧拉数。
% figure,imshow(bwni)

% bwni=bwmorph(bwni,'bridge',2);
% 桥接未连通的像素，即如果 0 值像素有两个未连通的非零邻点，则将这些 0 值像素设置为 1。例如：
% 1  0  0           1  1  0
% 1  0  1  becomes  1  1  1
% 0  0  1           0  1  1
% figure,imshow(BWNODEI)

% bwni=Obeymajority(bwni);
% figure,imshow(BWNODEI)

[Lbwni,nni] = bwlabel(bwni,4);
s = regionprops(Lbwni,'centroid');
centroids = cat(1,s.Centroid);
nipos = round(centroids);
end

% hold on
% plot(centroids(:,1),centroids(:,2),'g+')
% hold off