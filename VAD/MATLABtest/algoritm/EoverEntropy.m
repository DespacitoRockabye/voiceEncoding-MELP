aparam=2;                                    % ���ò���
for i=1:fn
    Sp = abs(fft(y(:,i)));                   % FFT�任ȡ��ֵ
    Sp = Sp(1:wlen/2+1);	                 % ֻȡ��Ƶ�ʲ���
    Esum(i) = log10(1+sum(Sp.*Sp)/aparam);   % �����������ֵ
    prob = Sp/(sum(Sp));		             % �������
    H(i) = -sum(prob.*log(prob+eps));        % ������ֵ
    Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));     % �������ر�
end   

Enm=multimidfilter(Ef,10);                   % ƽ���˲� 
Me=max(Enm);                                 % Enm���ֵ
eth=mean(Enm(1:NIS));                        % ��ʼ��ֵeth
Det=Me-eth;                                  % ���ֵ��������ֵ
T1=0.05*Det+eth;
T2=0.1*Det+eth;
[voiceseg,vsl,SF,NF]=vad_param1D(Enm,T1,T2); % �����رȷ���˫���޶˵���
