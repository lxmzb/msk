function[ak,c_bit1,s_bit1,c_bit2,s_bit2,pk_c1,qk_s1,pk_c2,qk_s2,msk]=mskmod(chip,fs)

%用于MSK正交调制
%先产生ak
%输入码元为1时，ak=+1;输入码元为0时，ak=-1
for n=1:length(chip)
    if chip(n)==1
        ak(n)=+1;
    elseif chip(n)==0;
        ak(n)=-1;
    end
end
 
%差分编码，原码ak，差分码bk
bk_1=+1;    %初始bk_1为 +1
for n=1:length(ak)
    bk(n)=ak(n)*bk_1;
    bk_1=bk(n);
end
 
%串并转换，bk分成pk和qk两个支路
%这里要注意两点：qk（1）单独取值；
%pk、qk在最后取值要注意点，比如bk有九个值bk(1)―bk(9)，此时要注意最后pk取值只要pk(9),不需要pk(10)
qk(1)=+1;   %解决上面的第一点
l_bk=length(bk);
for n=1:l_bk
    k=mod(n,2);% mod(X,Y) X/Y求余数
    if k==1 %奇数
        pk(n)=bk(n);
        if mod(n,2)==1 && n== l_bk   %解决上面的第二点
           break;
        else
           pk(n+1)=bk(n);
        end
    elseif k==0 %偶数
        qk(n)=bk(n);
        if mod(n,2)==0 && n==l_bk
           break;
        else
           qk(n+1)=bk(n);
        end
    end
end
 
%转换一下，将ak、bk、pk、qk对应到矩阵，便于作图
ak=c_p(ak,fs);
bk=c_p(bk,fs);
pk=c_p(pk,fs);
qk=c_p(qk,fs);

%下面加入正弦函数
%cos(pi*t/(2*Ts))、sin(pi*t/(2*Ts))，(k-1)*Ts<= t <=k*Ts
%cos(wc*t)、sin(wc*t), Ts=n*Tc/4
Ts=0.1;      %码元宽度(采样周期)，可更改   采样频率fs=10
Tc=4*Ts/10;  %载波周期 取n=10，可更改   载频fc=25
wc=2*pi/Tc;
c_bit1=[];
s_bit1=[];
c_bit2=[];
s_bit2=[];
for k=1:l_bk  %添加一个k=0的初始状态，设定初始状态k=0时，ak=+1，则pk=+1、qk=pk*ak;
    t=linspace((k-1)*Ts,k*Ts,fs);  %(k-1)Ts<=t<=kTs
    c1=cos(pi*t/(2*Ts)-pi/2);
    s1=sin(pi*t/(2*Ts)-pi/2);
    c2=cos(wc*t);
    s2=sin(wc*t);
    c_bit1=[c_bit1 c1];
    s_bit1=[s_bit1 s1];
    c_bit2=[c_bit2 c2];
    s_bit2=[s_bit2 s2];
end
%pk=[ones(1,fs) pk];  %增加pk0、qk0
%qk=[ones(1,fs) qk];

pk_c1=pk.*c_bit1; %pk*cos(pi*t/(2*Ts))
qk_s1=qk.*s_bit1;%qk*sin(pi*t/(2*Ts))
pk_c2=pk_c1.*c_bit2;%pk*cos(pi*t/(2*Ts))*cos(wc*t)
qk_s2=qk_s1.*s_bit2;%qk*sin(pi*t/(2*Ts))*sin(wc*t)
%ak=[ones(1,fs) ak];
%最后生成MSK信号
msk=pk_c2-qk_s2;  %Smsk(t)=pk*cos(pi*t/(2*Ts))cos(wc*t)-qk*sin(pi*t/(2*Ts))*sin(wc*t)
