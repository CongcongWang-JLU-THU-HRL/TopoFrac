function [Ci]=node_clustering_coefficient(ni,G_FV,A_FV)
    N=neighbors(G_FV,ni);
    ln=length(N);
    if ln<=1
        Ci=0;
    else
        fenmu=ln*(ln-1);
        fenzi=0;
        for j=1:ln-1
            for k=j+1:ln
                if A_FV(N(j),N(k))==1
                    fenzi=fenzi+1;
                else
                    continue
                end
            end
        end
        fenzi=fenzi*2;
        Ci=fenzi/fenmu;
    end
end