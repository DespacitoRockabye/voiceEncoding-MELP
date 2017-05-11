function [ VDR, VEDR, CORRECT ] = evaluation_print( fn,SF,frameTime)

%输入：fn, SF,frameTime
%输出：VDR, VEDR, CORRECT

run bluesky1;

VDR = 0;%语音检测率:被正确检测为语音的帧数与语音帧数的比率
VEDR = 0;%语音误检测率：被错误检测为语音的帧数与非语音帧数的比率
CORRECT = 0;%检测准确率：被正确检测出的语音帧数及非语音帧数之和与总帧数的比率

STD_1 = sum(stdSeq(:) ==1 );%语音帧数
STD_0 = sum(stdSeq(:) ==0 );%非语音帧数

evaluationSeq1 = zeros(1,fn);
evaluationSeq2 = zeros(1,fn);
evaluationSeq3 = zeros(1,fn);

for i = 1: fn
    evaluationSeq1(i) = stdSeq(i) && SF(i);
    evaluationSeq2(i) = xor(stdSeq(i) ,SF(i));
    evaluationSeq3(i) = stdSeq(i) || SF(i);
end

evaluationCre1 = sum(evaluationSeq1(:) ==1 );%被正确检测出的语音段
evaluationCre2 = sum(evaluationSeq2(:) ==1 );%被错误检测为语音的非语音段
evaluationCre3 = sum(evaluationSeq3(:) ==0 );%被正确检测出的非语音段

VDR = evaluationCre1/STD_1;
VEDR = evaluationCre2/STD_0;
CORRECT = (evaluationCre1+evaluationCre3)/fn;
fprintf('VDR - %.2f   VDER - %.2f   CORRECT - %.2f\n',VDR,VEDR,CORRECT);
end