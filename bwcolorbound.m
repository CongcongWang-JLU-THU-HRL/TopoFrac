function [B, L] = bwcolorbound(bw,nn)

figure,imshow(bw),
hold on
[B, L] = bwboundaries(bw, nn,'noholes');
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B)
    boundary = B{k};
    cidx = mod(k,length(colors))+1;
    plot(boundary(:,2), boundary(:,1),...
        colors(cidx),'LineWidth',1);

    %randomize text position for better visibility
    rndRow = ceil( length(boundary) / (mod(rand*k,7)+1) );
    col = boundary(rndRow,2);
    row = boundary(rndRow,1);
    h = text(col+1, row-1, num2str(L(row,col)));
    set(h,'Color',colors(cidx),'FontSize',8,'FontWeight','bold');
end

% neighbors(G,81)
% findedge(G,81,61)