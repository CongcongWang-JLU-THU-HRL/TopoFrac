function r=pearson_assortative(G)
M=numedges(G);
fz1=0;
fz2=0;
fm1=0;
% fm2=0;

G.Nodes.Degree=degree(G);
for i=1:M
    n1=G.Edges.EndNodes(i,1);
    n2=G.Edges.EndNodes(i,2);
    ji=G.Nodes.Degree(n1);
    ki=G.Nodes.Degree(n2);
    fz1=fz1+ji*ki/M;
    fz2=fz2+(ji+ki)/2/M;
    fm1=fm1+(ji^2+ki^2)/2/M;
end
fm2=fz2;

r=(fz1-fz2^2)/(fm1-fm2^2);

% 
% r=pearson_assortative(G)
% r_largc=pearson_assortative(G_largc)