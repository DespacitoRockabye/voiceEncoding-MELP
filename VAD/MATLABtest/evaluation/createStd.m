function [ result ] = createStd( x, v_start, v_end ,frameTime)
%CREATESTD 
%   根据人工标注的每个语音的起点和终点来构造评价标准序列
[~, I1] = min(abs(frameTime(:)-v_start));
[~, I2] = min(abs(frameTime(:)-v_end));
x(I1:I2) = 1;
result = x;
end

