
amp = STA_E(y);
zcr = STA_ZCR(y, fn);

ampm = multimidfilter(amp,5);           % ��ֵ�˲�ƽ������
zcrm = multimidfilter(zcr,5);    

ampth=mean(ampm(1:NIS));                % �����ʼ�޻������������͹����ʵ�ƽ��ֵ 
zcrth=mean(zcrm(1:NIS));

amp2=1.2*ampth; amp1=1.8*ampth;         % ���������͹����ʵ���ֵ
zcr2=0.9*zcrth;

%fprintf('===============\n');
%fprintf(['˫���޷����- SNR = ' num2str(SNR) '\n']);
%[voiceseg,vsl,SF,NF]=vad_param2D(amp,zcr,amp2,amp1,zcr2);% �˵���
[voiceseg,vsl,SF,NF]=vad_param2D_revr(amp,zcr,amp2,amp1,zcr2);% �˵���

%{
figure('NumberTitle', 'off', 'Name', 'DoubleThreshold');
subplot 411; 
plot(time,x,'k');
title('����������');
ylabel('��ֵ'); axis([0 max(time) -1 1]); 

subplot 412; 
plot(time,signal,'k');
title(['������������(�����' num2str(SNR) 'dB)']);
ylabel('��ֵ'); axis([0 max(time) -1 1]);

subplot 413; 
plot(frameTime,ampm,'color','k','LineStyle','-');
title('��ʱƽ������'); axis([0 max(time) 0.9*amp2 1.2*amp1]);
ylabel('��ֵ'); 
line([0,frameTime(fn)], [amp1 amp1], 'color','r','LineStyle','-');
line([0,frameTime(fn)], [amp2 amp2], 'color','r','LineStyle','--');

subplot 414; 
plot(frameTime,zcrm,'color','k','LineStyle',':');
title('��ʱƽ��������'); axis([0 max(time) 0.9*zcr2 1.2*zcr2]);
ylabel('��ֵ'); 
line([0,frameTime(fn)], [zcr2 zcr2], 'color','r','LineStyle','--');

range_figure = 1.2*max(max(ampm),max(zcrm));
for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 411; 
    line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','b','LineStyle','--');
    subplot 412; 
    line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','b','LineStyle','--');
    subplot 413; 
    line([frameTime(nx1) frameTime(nx1)],[-range_figure range_figure],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-range_figure range_figure],'color','b','LineStyle','--');
    subplot 414; 
    line([frameTime(nx1) frameTime(nx1)],[-range_figure range_figure],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-range_figure range_figure],'color','b','LineStyle','--');

end

xlabel('ʱ��/s');
%}