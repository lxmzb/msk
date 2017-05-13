function p = c_p(c,d)
%该函数用于将码元序列转化为对应的矩阵，方便作图,
%输入参数:  c--码元序列，d--一个码元对应的点数，用于标识矩阵大小;   
% 输出参数: p--码元对应矩阵
 
 
p=[];
for n=1:length(c)
    if c(n)==-1
        bit=-1*ones(1,d); %ones(m，n)  即m乘n的幺矩阵(全1矩阵)
    elseif c(n)==1
        bit=ones(1,d);
    end
    p=[p bit];
end
