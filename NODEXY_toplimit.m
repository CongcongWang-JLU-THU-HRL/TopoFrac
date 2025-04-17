function [nnxy,BWNODEXY,nxypos]=NODEXY_toplimit(BWsk)
BWsk = bwmorph(BWsk,'shrink');
% figure,imshow(BWsk)

BWNODEXY = bwmorph(BWsk,'branchpoints');
% figure,imshow(BWNODEXY)

BWNODEXY=bwmorph(BWNODEXY,'diag');
% figure,imshow(BWNODEXY)

BWNODEXY=bwmorph(BWNODEXY,'bridge');
% figure,imshow(BWNODEXY)

nhood=[1 0 1; 0 1 0; 1 0 1];
BWNODEXY=imdilate(BWNODEXY,nhood);
% figure,imshow(BWNODEXY)

BWNODEXY = Obeymajority(BWNODEXY);
% figure,imshow(BWNODEXY)

BWNODEXY=bwmorph(BWNODEXY,'bridge');
% figure,imshow(BWNODEXY)

BWNODEXY=bwmorph(BWNODEXY,'spur');
% figure,imshow(BWNODEXY)

BWNODEXY=bwmorph(BWNODEXY,'thicken');
% figure,imshow(BWNODEXY)
%%
BWNODEXY=bwmorph(BWNODEXY,'bridge');
% figure,imshow(BWNODEXY)
BWNODEXY=bwmorph(BWNODEXY,'thicken');
% figure,imshow(BWNODEXY)
BWNODEXY=bwmorph(BWNODEXY,'majority');
% figure,imshow(BWNODEXY)
BWNODEXY=bwmorph(BWNODEXY,'bridge');
% figure,imshow(BWNODEXY)
BWNODEXY=bwmorph(BWNODEXY,'thicken');
% figure,imshow(BWNODEXY)

BWNODEXY=bwmorph(BWNODEXY,'fill');
figure,imshow(BWNODEXY)

[Lbwnxy,nnxy] = bwlabel(BWNODEXY,4);
disp(['4连通条件下，该二值图中X型和Y型节点的数量上限为',num2str(nnxy),'个'])

% image_node_XY = label2rgb(L_node_XY);
% figure,imshow(image_node_XY)

s = regionprops(Lbwnxy,'centroid');
centroids = cat(1,s.Centroid);
nxypos = round(centroids);

hold on
plot(centroids(:,1),centroids(:,2),'r*')
% hold off