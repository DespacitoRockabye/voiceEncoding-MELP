
for i=1:fn
    Sp = abs(fft(y(:,i)));              % FFT�任ȡ��ֵ
    Sp = Sp(1:wlen/2+1);	            % ֻȡ��Ƶ�ʲ���
    Ep=Sp.*Sp;                          % �������
    prob = Ep/(sum(Ep));		        % ����ÿ�����ߵĸ����ܶ�
    H(i) = -sum(prob.*log(prob+eps));  % ��������
end

Enm=multimidfilter(H,10);               % ƽ������
Me=min(Enm);                            % ������ֵ 
eth=mean(Enm(1:NIS));                   
Det=eth-Me;
T1=0.98*Det+Me;
T2=0.93*Det+Me;
[voiceseg,vsl,SF,NF]=vad_param1D_revr(Enm,T1,T2);% ��˫���޷�������˵�
