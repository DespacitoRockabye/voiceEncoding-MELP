function [ result ] = createStd( x, v_start, v_end ,frameTime)
%CREATESTD 
%   �����˹���ע��ÿ�������������յ����������۱�׼����
[~, I1] = min(abs(frameTime(:)-v_start));
[~, I2] = min(abs(frameTime(:)-v_end));
x(I1:I2) = 1;
result = x;
end

