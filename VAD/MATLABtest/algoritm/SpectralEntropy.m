
for i=1:fn
    Sp = abs(fft(y(:,i)));              % FFT变换取幅值
    Sp = Sp(1:wlen/2+1);	            % 只取正频率部分
    Ep=Sp.*Sp;                          % 求出能量
    prob = Ep/(sum(Ep));		        % 计算每条谱线的概率密度
    H(i) = -sum(prob.*log(prob+eps));  % 计算谱熵
end

Enm=multimidfilter(H,10);               % 平滑处理
Me=min(Enm);                            % 计算阈值 
eth=mean(Enm(1:NIS));                   
Det=eth-Me;
T1=0.98*Det+Me;
T2=0.93*Det+Me;
[voiceseg,vsl,SF,NF]=vad_param1D_revr(Enm,T1,T2);% 用双门限法反向检测端点
