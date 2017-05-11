

%
% pr4_4_1 
clear all; clc; close all;

filedir=[];                             % 设置数据文件的路径
filename='aa.wav';                      % 设置数据文件的名称
fle=[filedir filename]  ;                % 构成路径和文件名的字符串
[x,fs]=audioread(fle);                    % 读入语音数据
L=240;                                  % 帧长
p=12;                                   % LPC的阶数
%y=x(8001:8000+L);                       % 取一帧数据
y = x(8001:8000+L+p); 
nfft=512;                               % FFT变换长度
W2=nfft/2;
m=1:W2+1;                               % 正频率部分下标值
Y=fft(y,nfft);  

for pIndex = 1:3
    p = pIndex+9;
    ar=lpc(y,p); % 线性预测变换
    [EL,alphal,GL,k]=latticem(y,L,p);       % 格型预测法
    ar1=alphal(:,p);

    Y1(pIndex,:)=lpcar2ff(ar,W2-1);                   % 计算预测系数的频谱
    Y2(pIndex,:)=lpcar2ff([1;  -ar1],W2-1); 
end
% 作图
plot(m,20*log10(abs(Y(m))),'k','linewidth',1.5); 
line(m,20*log10(abs(Y1(1,:))),'color','b','linewidth',2)
line(m,20*log10(abs(Y1(2,:))),'color','r','linewidth',2)
line(m,20*log10(abs(Y1(3,:))),'color','g','linewidth',2)

%line(m,20*log10(abs(Y2(1))),'color','r','linewidth',2)
axis([0 W2+1 -30 25]); ylabel('幅值/db');
legend('FFT频谱','LPC谱','格型法',3); xlabel(['样点' 10 '(b)'])
title('FFT频谱和LPC谱的比较');