function [ VDR, VEDR, CORRECT ] = evaluation_print( fn,SF,frameTime)

%���룺fn, SF,frameTime
%�����VDR, VEDR, CORRECT

run bluesky1;

VDR = 0;%���������:����ȷ���Ϊ������֡��������֡���ı���
VEDR = 0;%���������ʣ���������Ϊ������֡���������֡���ı���
CORRECT = 0;%���׼ȷ�ʣ�����ȷ����������֡����������֡��֮������֡���ı���

STD_1 = sum(stdSeq(:) ==1 );%����֡��
STD_0 = sum(stdSeq(:) ==0 );%������֡��

evaluationSeq1 = zeros(1,fn);
evaluationSeq2 = zeros(1,fn);
evaluationSeq3 = zeros(1,fn);

for i = 1: fn
    evaluationSeq1(i) = stdSeq(i) && SF(i);
    evaluationSeq2(i) = xor(stdSeq(i) ,SF(i));
    evaluationSeq3(i) = stdSeq(i) || SF(i);
end

evaluationCre1 = sum(evaluationSeq1(:) ==1 );%����ȷ������������
evaluationCre2 = sum(evaluationSeq2(:) ==1 );%��������Ϊ�����ķ�������
evaluationCre3 = sum(evaluationSeq3(:) ==0 );%����ȷ�����ķ�������

VDR = evaluationCre1/STD_1;
VEDR = evaluationCre2/STD_0;
CORRECT = (evaluationCre1+evaluationCre3)/fn;
fprintf('VDR - %.2f   VDER - %.2f   CORRECT - %.2f\n',VDR,VEDR,CORRECT);
end