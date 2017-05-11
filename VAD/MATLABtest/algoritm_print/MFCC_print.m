ccc=mfcc_m(signal,fs,16,wlen,inc);      % ����MFCC
fn1=size(ccc,1);                        % ȡ֡��1
frameTime1=frameTime(3:fn-2);           % MFCC��Ӧ��ʱ��̶�
Ccep=ccc(:,1:16);                       % ȡ��MFCCϵ��
C0=mean(Ccep(1:5,:),1);                 % ��������ƽ��MFCC����ϵ���Ĺ���ֵ
for i=6 : fn1
    Cn=Ccep(i,:);                       % ȡһ֡MFCC����ϵ��
    Dstu=0;
    for k=1 : 16                        % �ӵ�6֡��ʼ����ÿ֡MFCC����ϵ����
        Dstu=Dstu+(Cn(k)-C0(k))^2;      % ����MFCC����ϵ���ľ���
    end
    Dcep(i)=sqrt(Dstu);
end
Dcep(1:5)=Dcep(6);

Dstm=multimidfilter(Dcep,2);            % ƽ������
dth=max(Dstm(1:NIS-2));                 % ��ֵ����
T1=1*dth;
T2=1.3*dth;

fprintf('===============\n');
fprintf(['MFCC�����- SNR = ' num2str(SNR) '\n']);
[voiceseg,vsl,SF,NF]=vad_param1D(Dstm,T1,T2);% MFCC���׾���˫���޵Ķ˵���

figure('NumberTitle', 'off', 'Name', 'MFCC');
subplot 311; plot(time,x,'k');
title('����������');
ylabel('��ֵ'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['������������(�����' num2str(SNR) 'dB)']);
ylabel('��ֵ'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime1,Dstm,'k');
title('��ʱMFCC���׾���ֵ'); axis([0 max(time) 0 1.2*max(Dstm)]);
xlabel('ʱ��/s'); ylabel('��ֵ'); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
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
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Dstm)],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Dstm)],'color','b','LineStyle','--');
end
