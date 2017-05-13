function  MSK_modulation
%该函数用于MSK信号的调制解调

chip=suiji(10);%产生随机序列
fs=100;        %采样频率 每个码元的采样点数，可更改
 
%调制----------------------------------------------------------------------
[ak,msk]=mskmod(chip,fs);

ak=(ak+1)/2;%双极性码元变成单极性码元,方便作图比较
%__________________________________________________________________________
%MSK解调，调用解调函数
a=de_msk(msk,fs);
 
%――――――――――――――――――――――――――――――――――――――――
mskplt(ak,a,msk)                              %画时域图，频谱图
 
%――――――――――――――――――――――――――――――――――――――---
%[num,ser]=symerr(ak,a);                       %计算误码率Pe
%M=2;                                           %二进制
%ber=ser*(M/2)/(M-1)                            %计算误信率Pb(比特差错率)  误信率和误码率之间的关系：Pb=Pe(M/2)/(M-1)
   
