function Adjacency_info_to_networkx(A,filename)
    %close all
    fid=fopen(filename,'w');
    fprintf(fid,'import networkx as nx\n');
%     fprintf(fid,'import matplotlib.pyplot as plt\n');
%     fprintf(fid,'import numpy as np\n');
%     fprintf(fid,'import matplotlib.mlab as mlab\n');
    fprintf(fid,'G=nx.Graph()\n');
    for i=1:size(A,1)
        fprintf(fid,'G.add_node(%.0f)\n',i);
    end
    
    for i=1:size(A,1)-1
        for j=i+1:size(A,1)
            if A(i,j)~=0
                fprintf(fid,'G.add_edge(%.0f,%.0f, weight=1)\n',i,j);
            end
        end
    end
    fclose(fid);
end