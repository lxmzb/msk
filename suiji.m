function y=suiji(n)
%产生随机序列
randn('state',0);    %randn()  从0到1之间均值为0，方差为1的标准正态分布的的随机矩阵
rand('state',0);     %rand()  从0到1之间均匀分布的的随机矩阵 
y=[];
for i=1:n
    x(i)=rand;       %rand()  从0到1之间均匀分布的的随机矩阵 
    if x(i)>=0.5
        a=1;
    else
        a=0;
    end
    y=[y a];
end
