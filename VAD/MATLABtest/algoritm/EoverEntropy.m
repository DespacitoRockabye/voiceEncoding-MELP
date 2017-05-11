aparam=2;                                    % 设置参数
for i=1:fn
    Sp = abs(fft(y(:,i)));                   % FFT变换取幅值
    Sp = Sp(1:wlen/2+1);	                 % 只取正频率部分
    Esum(i) = log10(1+sum(Sp.*Sp)/aparam);   % 计算对数能量值
    prob = Sp/(sum(Sp));		             % 计算概率
    H(i) = -sum(prob.*log(prob+eps));        % 求谱熵值
    Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));     % 计算能熵比
end   

Enm=multimidfilter(Ef,10);                   % 平滑滤波 
Me=max(Enm);                                 % Enm最大值
eth=mean(Enm(1:NIS));                        % 初始均值eth
Det=Me-eth;                                  % 求出值后设置阈值
T1=0.05*Det+eth;
T2=0.1*Det+eth;
[voiceseg,vsl,SF,NF]=vad_param1D(Enm,T1,T2); % 用能熵比法的双门限端点检测
