
for k=2 : fn                            % ��������غ���
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end

Rum=multimidfilter(Ru,10);              % ƽ������
Rum=Rum/max(Rum);                       % ��һ��
thredth=max(Rum(1:NIS));                % ������ֵ
T1=1.1*thredth;
T2=1.3*thredth;

fprintf('===============\n');
fprintf(['����ط����- SNR = ' num2str(SNR) '\n']);
[voiceseg,vsl,SF,NF]=vad_param1D(Rum,T1,T2);% ����غ����Ķ˵���


figure('NumberTitle', 'off', 'Name', 'AutoCorrelation');
subplot 311; plot(time,x,'k');
title('����������');
ylabel('��ֵ'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['������������(�����' num2str(SNR) 'dB)']);
ylabel('��ֵ'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Rum,'k');
title('��ʱ����غ���'); axis([0 max(time) 0.9*T1 1.2*T2]);
xlabel('ʱ��/s'); ylabel('��ֵ'); 
line([0,frameTime(fn)], [T1 T1], 'color','r','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','r','LineStyle','-');

for k=1 : vsl                           % ��������˵�
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 312; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 313; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
end

