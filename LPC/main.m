

%
% pr4_4_1 
clear all; clc; close all;

filedir=[];                             % ���������ļ���·��
filename='aa.wav';                      % ���������ļ�������
fle=[filedir filename]  ;                % ����·�����ļ������ַ���
[x,fs]=audioread(fle);                    % ������������
L=240;                                  % ֡��
p=12;                                   % LPC�Ľ���
%y=x(8001:8000+L);                       % ȡһ֡����
y = x(8001:8000+L+p); 
nfft=512;                               % FFT�任����
W2=nfft/2;
m=1:W2+1;                               % ��Ƶ�ʲ����±�ֵ
Y=fft(y,nfft);  

for pIndex = 1:3
    p = pIndex+9;
    ar=lpc(y,p); % ����Ԥ��任
    [EL,alphal,GL,k]=latticem(y,L,p);       % ����Ԥ�ⷨ
    ar1=alphal(:,p);

    Y1(pIndex,:)=lpcar2ff(ar,W2-1);                   % ����Ԥ��ϵ����Ƶ��
    Y2(pIndex,:)=lpcar2ff([1;  -ar1],W2-1); 
end
% ��ͼ
plot(m,20*log10(abs(Y(m))),'k','linewidth',1.5); 
line(m,20*log10(abs(Y1(1,:))),'color','b','linewidth',2)
line(m,20*log10(abs(Y1(2,:))),'color','r','linewidth',2)
line(m,20*log10(abs(Y1(3,:))),'color','g','linewidth',2)

%line(m,20*log10(abs(Y2(1))),'color','r','linewidth',2)
axis([0 W2+1 -30 25]); ylabel('��ֵ/db');
legend('FFTƵ��','LPC��','���ͷ�',3); xlabel(['����' 10 '(b)'])
title('FFTƵ�׺�LPC�׵ıȽ�');