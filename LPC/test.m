%
% pr4_4_1 
clear all; clc; close all;

filedir=[];                             % 设置数据文件的路径
filename='aa.wav';                      % 设置数据文件的名称
fle=[filedir filename]  ;                % 构成路径和文件名的字符串
[x,fs]=audioread(fle);                    % 读入语音数据
L=240;                                  % 帧长
p=10;                                   % LPC的阶数
%y=x(8001:8000+L);                       % 取一帧数据
y = x(8001:8000+L+p); 


ar=lpc(y,p); % 线性预测变换


LSF = melp_lpc2lsf(ar(2:11))';
a = ar;

a=a(:);                       % 将a转换为列向量
% 如果a不是实数，输出错误信息：LSF不适用于复多项式的求解
if ~isreal(a) ,
      error('Line spectral frequencies are not defined for complex polynomials.');
end
% 如果a(1)不为1,将矩阵a的每个元素除以a(1)再赋给矩阵
if a(1) ~= 1.0,
    a=a./a(1); 
end
% 如果a的根不在单位圆内,显示错误信息并返回
if (max(abs(roots(a))) >= 1.0),
    error ('The polynomial must have all roots inside of the unit circle. ');
end
%求对称和反对称多项式的系数
p=length(a) - 1;              % 求对称和反对称多项式的阶次
a1=[a;0];                     % 给行矩阵a再增加一个元素0的行 
a2=a1(end:-1:1);              % a2的第一行为a1的最后一行，最后一行为al的第一行
P1=a1+a2;                     % 按式(4-5-4)求对称多项式的系数
Q1=a1-a2;                     % 按式(4-5-5)求反对称多项式的系数
%如果阶次p为偶数次，按式(4-5-10)和式(4-5-11)从P1去掉实数根z=-1，从Q1去掉实数根z=1
%如果阶次为奇数次，从Q1去掉实数根z=1及z=-1
if rem(p,2),                  % 求解P除以2的余数，如果P为奇数次。余数为1，否则为0
   Q=deconv(Q1,[1 0 -1]);     % 奇数阶次，从Q1去掉实数根z=1及z=-1
   P=P1;
else                          % P为偶数阶次执行下面的操作
   Q=deconv(Q1,[1 -1]);       % 从Q1去掉实数根z=1
   P=deconv(P1, [1 1] );      % 从P1去掉实数根z=-1
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





rP=roots(P);                  % 求去掉实根后的多项式P的根
rQ=roots(Q);                 % 求去掉实根后的多项式Q的根
aP=angle(rP(1: 2:end) ) ;     % 将多项式P的根转换为角度(为归一化角频率)赋给ap
aQ=angle(rQ(1: 2:end));       % 将多项式Q的根转换为角度(为归一化角频率)赋给aQ 
lsf= sort([aP; aQ]);          % 将P、Q的根(归一化角频率)按从小到大的顺序排序后即为lsf

error1 = lsf-LSF;

