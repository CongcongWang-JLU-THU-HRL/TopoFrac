# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 13:24:34 2023

@author: wcc19
"""
def pydiameter(pyG):
    import networkx as nx
    c_or_dis = nx.is_connected(pyG)
    if c_or_dis == True:
        H = pyG;
    else:
        largest_cc = max(nx.connected_components(pyG), key=len)
        H = pyG.subgraph(largest_cc).copy()
            
    G_diameter = nx.diameter(H);
    print('pyG的直径 D为：{}'.format(G_diameter))
    return G_diameter

def pysigma(pyG):
    import networkx as nx
    import time
    c_or_dis = nx.is_connected(pyG)
    if c_or_dis == True:
        H = pyG;
    else:
        largest_cc = max(nx.connected_components(pyG), key=len)
        H = pyG.subgraph(largest_cc).copy()
    
    # H=G;
    st=time.time()
    G_sigma = nx.sigma(H, niter=nx.number_of_edges(H), nrand=10, seed=None);
    et = time.time()
    print('{}'.format(et-st))
    print('pyG的小世界属性σ为：{}'.format(G_sigma))
    return G_sigma


def pyomega(pyG):
    import networkx as nx
    import time
    c_or_dis = nx.is_connected(pyG)
    if c_or_dis == True:
        H = pyG;
    else:
        largest_cc = max(nx.connected_components(pyG), key=len)
        H = pyG.subgraph(largest_cc).copy()   
    # H=G;
    st=time.time()
    G_omega = nx.omega(H, niter=nx.number_of_edges(H), nrand=10, seed=None);
    et = time.time()
    print('{}'.format(et-st))
    print('pyG的小世界属性w为：{}'.format(G_omega))
    return G_omega

def pyQ(pyG):
    # import networkx
    from networkx.algorithms.community import greedy_modularity_communities
    c = greedy_modularity_communities(pyG)
    print(c)
    import networkx.algorithms.community as nx_comm
    Q = nx_comm.modularity(pyG, c);
    print('pyG的结构模块性Q为：{}'.format(Q))
    return Q



def pyC_suqare(pyG):
    import numpy
    import networkx as nx
    C_square=nx.square_clustering(pyG)
    C_square_mean = list(C_square.values())
    C_square_mean = numpy.mean(C_square_mean)
    print('pyG的方形群聚系数Cs为：{}'.format(C_square_mean))
    return C_square_mean
