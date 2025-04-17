
%%
% 检查有没有txt文件，有的话删除
prefixname='XW03';
lsfn = [prefixname, '-networkx.txt'];
if exist(lsfn, 'file') == 2
    % 如果文件存在，删除它
    delete(lsfn);
    fprintf('文件 %s 已被删除。\n', lsfn);
else
    fprintf('当前文件夹中不存在文件 %s \n', lsfn);
end
Adjacency_info_to_networkx(A,lsfn)

% 检查有没有py文件，有的话删除
lsfn = [prefixname, '-networkx.py'];
if exist(lsfn, 'file') == 2
    % 如果文件存在，删除它
    delete(lsfn);
    fprintf('文件 %s 已被删除。\n', lsfn);
else
    fprintf('当前文件夹中不存在文件 %s 。\n', lsfn);
end

% 改扩展名
file = dir([prefixname, '-networkx.txt']);
len = length(file);
for i = 1 : len
    oldname0 = string(file(i).name);
    oldname = strcat(',',oldname0);
    Date=string(regexp(oldname,'.*(?=\.txt)','match'));
    newname = strcat(Date,'.py');
    eval(['!rename',char(oldname),char(newname)]);%要用char  string不行
end

% 运行py文件
pyG = pyrunfile([prefixname, '-networkx.py'], "G");
py.importlib.import_module('Topofracpyfun');
display(pyG)
%%

lsfn = [prefixname, '-largc-networkx.'];
if exist(lsfn, 'file') == 2
    % 如果文件存在，删除它
    delete(lsfn);
    fprintf('文件 %s 已被删除。\n', lsfn);
else
    fprintf('文件 %s 不存在于当前文件夹中。\n', lsfn);
end
lsfn = [prefixname, '-largc-networkx.py'];
if exist(lsfn, 'file') == 2
    % 如果文件存在，删除它
    delete(lsfn);
    fprintf('文件 %s 已被删除。\n', lsfn);
else
    fprintf('文件 %s 不存在于当前文件夹中。\n', lsfn);
end
% 写txt文件
Adjacency_info_to_networkx(Alargc, [prefixname, '-largc-networkx.txt'])

% 改扩展名
file2 = dir([prefixname, '-largc-networkx.txt']);
for i = 1 : length(file2)
    oldname0 = string(file2(i).name);
    oldname = strcat(',',oldname0);
    Date=string(regexp(oldname,'.*(?=\.txt)','match'));
    newname = strcat(Date,'.py');
    eval(['!rename',char(oldname),char(newname)]);%要用char  string不行
end

% 运行py文件
pyGlargc = pyrunfile([prefixname, '-largc-networkx.py'], "G");
py.importlib.import_module('Topofracpyfun');


% SW_sigma = py.Topofrac_pyfun.pysigma(pyG);
% SW_omega = py.Topofrac_pyfun.pyomega(pyG);

Q_modularity = py.Topofracpyfun.pyQ(pyG);

Diameter = double(py.Topofracpyfun.pydiameter(pyGlargc));

C_square = py.Topofracpyfun.pyC_suqare(pyG);
C_square_largc = py.Topofracpyfun.pyC_suqare(pyGlargc);



%%
xlsfn='D:\Laura Wang\自己的文章\待完成-裂隙网格拓扑结构分析工具\recal.xlsx';
Nlargc=numnodes(Glargc);
Mlargc=numedges(Glargc);
nodeprop=[nip,nvp,nyp,nxp].';
av=[N;M;Nlargc;Mlargc;nodeprop;edge_type;assortative_edge_por;...
    disassortative_edge_por;...
    IIprop;ICprop;CCprop;...
    MN;MNN;Cluster_mean;Clusterlargc_mean;...
    Pearson_coe;Pearson_coe_Glargc;...
    Efficiency_mean;Efficiencylargc_mean;...
    Q_modularity;Diameter;C_square;C_square_largc;fhydrau;max(conncomp(G))];
writematrix(av,xlsfn,'Range','F2') % F对应HG02
save('HG-02.mat')