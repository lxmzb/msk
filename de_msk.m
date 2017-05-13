function a=de_msk(T_signal,fs)
%该函数用于解调MSK信号，采用相干解调的方法
%输入参数:  T_signal--发送端信号
%调用示例:  de_msk(msk_signal)
 
Ts=10;
len=length(T_signal)/fs;   %码元个数，包含了初始状态
 
%先对信号添加 加性高斯白噪声
snr=0.00000000001;  %信噪比
T_signal=awgn(T_signal,snr);  %加性高斯白噪声
figure(4)
plot(T_signal);
axis([0 1000 -4 4]);
title('添加的加性高斯白噪声');
grid on;
 
%解调，先乘上载波信号
Tc=4*Ts/10;  %载波周期 取n=20，可更改
wc=2*pi/Tc;  %载波角频率
t=linspace(0,len*Ts,length(T_signal));
signal_p=2*cos(pi*t/(2*Ts)).*cos(wc*t).*T_signal;   %上支路
signal_q=-2*sin(pi*t/(2*Ts)).*sin(wc*t).*T_signal;   %上支路
 
%低通滤波

 lpf_c=fir1(50,wc/(50*2*pi));  %产生FIR滤波器系数
%滤波，1表示FIR，这里lpf_c为分子，1为分母，对signal_p滤波
lp_signal_p=filter(lpf_c,1,signal_p);   %上支路，滤波后为pk*cos2(pi*t/(2*Ts))  
lp_signal_q=filter(lpf_c,1,signal_q);   %下支路，滤波后为qk*sin2(pi*t/(2*Ts))
 
%比较判决
 
%上支路判决，每个码元判决23个点，取均值
for m=1:len
    p=0;
    for n=1:23
        if lp_signal_p((m-1)*100+n*4)>0
            pk_n(n)=+1;
        elseif lp_signal_p((m-1)*100+n*4)<0
            pk_n(n)=-1;
        end
        p=p+pk_n(n);
    end
    pk(m)=p/23;
    if pk(m)>0
        pk(m)=+1;
    elseif pk(m)<0
        pk(m)=-1;
    end
end
 
%下支路判决，每个码元判决23个点，取均值
for m=1:len
    q=0;
    for n=1:23
        if lp_signal_q((m-1)*100+n*4)>0
            qk_n(n)=+1;
        elseif lp_signal_q((m-1)*100+n*4)<0
            qk_n(n)=-1;
        end
        q=q+qk_n(n);
    end
    qk(m)=q/23;
    if qk(m)>0
        qk(m)=+1;
    elseif qk(m)<0
        qk(m)=-1;
    end
end
 
pk1=pk(2:len);  %剔除了初始状态
qk1=qk(2:len);
 
pk2=c_p(pk1,100);  %作转换作图
qk2=c_p(qk1,100);
         
%交替取样，获得bk
for k=1:len-1
    if mod(k,2)==1
        bk(k)=pk1(k);
    elseif mod(k,2)==0
        bk(k)=qk1(k);
    end
end 
 
bk1=c_p(bk,100);
     
%码反变换，获得ak
 
bk_1=+1;    %初始bk_1为 +1
for n=1:len-1
    ak(n)=bk(n)*bk_1;
    bk_1=bk(n); 
end
 
ak1=c_p(ak,100);
 a=(ak1+1)/2;%变换为初始序列
