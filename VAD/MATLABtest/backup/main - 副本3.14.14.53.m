addpath(genpath(pwd));
clear;
run SET_I;
run INIT;

[x,fs] = audioread('../test2.wav');
NIS = 16;         %前导无话语段 帧长度
wlen = 180;%frame length
inc = 90;%frame offset

%Double Threshold method
[voiceSeg,vsl,SF,NF] = DoubleThreshold(x, wlen, inc, NIS);
fn = size(SF,2);

%Double Threshold method with noise
x_20db = GnoiseGen(x, 20);
[voiceSeg2,vsl2,SF2,NF2] = DoubleThreshold(x_20db, wlen, inc, NIS);
x_0db = GnoiseGen(x, 0);
[voiceSeg3,vsl3,SF3,NF3] = DoubleThreshold(x_0db, wlen, inc, NIS);

% display part
plotIndex = 0:fn-1;
plotIndex2 = 0:size(x,1)-1; 
plotIndex3 = 0:119/10856:119;
SF_reshape = interp1(plotIndex, SF,plotIndex3);
SF2_reshape = interp1(plotIndex, SF2,plotIndex3);
SF3_reshape = interp1(plotIndex, SF3,plotIndex3);
figure();
subplot(3,1,1);
plot(plotIndex2,SF_reshape/2,plotIndex2,x);
subplot(3,1,2);
plot(plotIndex2,SF2_reshape/2,plotIndex2,x_20db);
subplot(3,1,3);
plot(plotIndex2,SF3_reshape/2,plotIndex2,x_20db);



