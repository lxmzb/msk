function mskplt(ak,a,msk)
%以图片形式展示

%msk信号与msk信号频谱
figure;
subplot(211)
plot(ak,'linewidth',2);
axis([0 1000 -0.1 1.1]);
grid on;
title('MSK调制前的输入波形');
subplot(212)
plot(msk);
axis([0 1000 -1.1 1.1]);
grid on;
title('MSK调制后的输出波形');

%msk信号的频谱
figure;
plot(abs(fftshift(fft(msk))));%msk信号频谱
axis([0 1200 0 350]);
grid on;
title('MSK信号频谱')
 


%用 Welch 法估计序列的功率谱密度； 
figure
nfft=256; %做FFT时的长度
window=hamming(33); %选用的汉明窗函数
noverlap=30;%估计频率谱时每一段叠合的长度                           
range='onesided'; 
fs=1000;%抽样频率
[Pxx,f] = pwelch(msk,window,noverlap,nfft,fs,range); %使用pwelch函数计算
plot_Pxx=10*log10(Pxx); 
plot(f,plot_Pxx,'r');%转化成单位为dB的形式
grid on;
title('Welch 法估计功率谱密度') ;
xlabel('f/Hz');
ylabel('p(f)/dB');
 
 
 
%msk信号发送端的码元序列与解调输出的码元序列
figure;
subplot(211)
plot(ak,'linewidth',2);
axis([0 1000 -0.1 1.1]);
grid on;
title('MSK调制前的输入波形'); %发送端的码元序列
ylabel('ak');
subplot(212)
plot(a,'linewidth',1.5);
axis([0 1000 -0.1 1.1]);
grid on;
title('MSK解调后的输出波形') %解调输出的码元序列
 
