function [E,ENode,L]=graph_efficiency(G)
N=numnodes(G);
ENode=zeros(nchoosek(N,2),1);
t=0;
for i=1:N-1
    for j=i+1:N
        t=t+1;
        [~,d]=shortestpath(G,i,j);
        lp=d;
        ENode(t)=1/lp;
    end
end
E=mean(ENode);
L=mean(1./ENode);
%{
E=0;
L=0;
for i=1:N
    for j=1:N
        if i==j
            continue
        else
            [~,d]=shortestpath(G,i,j);
            E=E+1/d;
            L=L+d;
        end
    end
end
E=E/N/(N-1);
L=L/N/(N-1);
%}