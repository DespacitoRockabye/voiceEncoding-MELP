%
% pr4_4_1 
clear all; clc; close all;

filedir=[];                             % ���������ļ���·��
filename='aa.wav';                      % ���������ļ�������
fle=[filedir filename]  ;                % ����·�����ļ������ַ���
[x,fs]=audioread(fle);                    % ������������
L=240;                                  % ֡��
p=10;                                   % LPC�Ľ���
%y=x(8001:8000+L);                       % ȡһ֡����
y = x(8001:8000+L+p); 


ar=lpc(y,p); % ����Ԥ��任


LSF = melp_lpc2lsf(ar(2:11))';
a = ar;

a=a(:);                       % ��aת��Ϊ������
% ���a����ʵ�������������Ϣ��LSF�������ڸ�����ʽ�����
if ~isreal(a) ,
      error('Line spectral frequencies are not defined for complex polynomials.');
end
% ���a(1)��Ϊ1,������a��ÿ��Ԫ�س���a(1)�ٸ�������
if a(1) ~= 1.0,
    a=a./a(1); 
end
% ���a�ĸ����ڵ�λԲ��,��ʾ������Ϣ������
if (max(abs(roots(a))) >= 1.0),
    error ('The polynomial must have all roots inside of the unit circle. ');
end
%��Գƺͷ��Գƶ���ʽ��ϵ��
p=length(a) - 1;              % ��Գƺͷ��Գƶ���ʽ�Ľ״�
a1=[a;0];                     % ���о���a������һ��Ԫ��0���� 
a2=a1(end:-1:1);              % a2�ĵ�һ��Ϊa1�����һ�У����һ��Ϊal�ĵ�һ��
P1=a1+a2;                     % ��ʽ(4-5-4)��Գƶ���ʽ��ϵ��
Q1=a1-a2;                     % ��ʽ(4-5-5)�󷴶Գƶ���ʽ��ϵ��
%����״�pΪż���Σ���ʽ(4-5-10)��ʽ(4-5-11)��P1ȥ��ʵ����z=-1����Q1ȥ��ʵ����z=1
%����״�Ϊ�����Σ���Q1ȥ��ʵ����z=1��z=-1
if rem(p,2),                  % ���P����2�����������PΪ�����Ρ�����Ϊ1������Ϊ0
   Q=deconv(Q1,[1 0 -1]);     % �����״Σ���Q1ȥ��ʵ����z=1��z=-1
   P=P1;
else                          % PΪż���״�ִ������Ĳ���
   Q=deconv(Q1,[1 -1]);       % ��Q1ȥ��ʵ����z=1
   P=deconv(P1, [1 1] );      % ��P1ȥ��ʵ����z=-1
end


fftNum = 2048;
fftAddPoint = fftNum-p;
Ptemp = zeros(fftAddPoint,1);
Ptemp(1:p+1) = P;
Qtemp = zeros(fftAddPoint,1);
Qtemp(1:p+1) = Q;
pFFT = fft(Ptemp,fftNum);

pFFT_abs = abs(pFFT);
pDIFF = diff(pFFT_abs);
[ppks,plocs] = findpeaks(-pFFT_abs);
plocs1 = plocs(1:size(plocs,1)/2);
plocatesLSF = (plocs1./(fftNum));

qFFT = fft(Qtemp,fftNum);
qFFT_abs = abs(qFFT);
qDIFF = diff(qFFT_abs);
[qpks,qlocs] = findpeaks(-qFFT_abs);
qlocs1 = qlocs(1:size(qlocs,1)/2);
qlocatesLSF = (qlocs1./(fftNum));
locatesLSF =sort([plocs1 ; qlocs1]);

for index = 1:10
    finalSeq1(index) = angle(pFFT(plocs(index)));
    finalSeq2(index) = angle(qFFT(qlocs(index)));
end

MyRadius = fftNum/(2*3.14);
%LSF = locatesLSF./MyRadius;





rP=roots(P);                  % ��ȥ��ʵ����Ķ���ʽP�ĸ�
rQ=roots(Q);                 % ��ȥ��ʵ����Ķ���ʽQ�ĸ�
aP=angle(rP(1: 2:end) ) ;     % ������ʽP�ĸ�ת��Ϊ�Ƕ�(Ϊ��һ����Ƶ��)����ap
aQ=angle(rQ(1: 2:end));       % ������ʽQ�ĸ�ת��Ϊ�Ƕ�(Ϊ��һ����Ƶ��)����aQ 
lsf= sort([aP; aQ]);          % ��P��Q�ĸ�(��һ����Ƶ��)����С�����˳�������Ϊlsf

error1 = lsf-LSF;

