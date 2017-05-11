close all; clear all;

run Set_II;                                 % ��������
run Part_II;                                % �����ļ�,��֡�Ͷ˵���

lmin=fix(fs/500);                           % ����������ȡ����Сֵ
lmax=fix(fs/60);                            % ����������ȡ�����ֵ

%%%%%%%%   ���׷�   %%%%%%%%
periodCep=zeros(1,fn);
periodCep = Cep(y,fn,voiceseg,vosl,lmax,lmin);
T0Cep=zeros(1,fn);
T0Cep=pitfilterm1(periodCep,voiceseg,vosl);

%%%%%%%%   ����ط�   %%%%%%%%
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % ��ͨ�����˲�
yy  = enframe(xx,wlen,inc)';                    % �˲����źŷ�֡

periodACF1=zeros(1,fn);                             % �������ڳ�ʼ��
periodACF1=ACF_corr(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_ACF1=pitfilterm1(periodACF1,voiceseg,vosl);           % ƽ������

periodACF2=zeros(1,fn);                             % �������ڳ�ʼ��
periodACF2=ACF_clip(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_ACF2=pitfilterm1(periodACF2,voiceseg,vosl);           % ƽ������

periodACF3=zeros(1,fn);                             % �������ڳ�ʼ��
periodACF3=ACF_threelevel(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_ACF3=pitfilterm1(periodACF3,voiceseg,vosl);           % ƽ������


%%%%%%%%   ƽ�����Ȳ   %%%%%%%%
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % ��ͨ�����˲�
yy  = enframe(xx,wlen,inc)';                    % �˲����źŷ�֡

periodAMDF1=zeros(1,fn);                             % �������ڳ�ʼ��
periodAMDF1=AMDF_1(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_AMDF1=pitfilterm1(periodAMDF1,voiceseg,vosl);           % ƽ������

periodAMDF2=zeros(1,fn);                             % �������ڳ�ʼ��
periodAMDF2=AMDF_mod(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_AMDF2=pitfilterm1(periodAMDF2,voiceseg,vosl);           % ƽ������

periodAMDF3=zeros(1,fn);                             % �������ڳ�ʼ��
periodAMDF3=CAMDF_1(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_AMDF3=pitfilterm1(periodAMDF3,voiceseg,vosl);           % ƽ������

periodAMDF4=zeros(1,fn);                             % �������ڳ�ʼ��
periodAMDF4=CAMDF_mod(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_AMDF4=pitfilterm1(periodAMDF4,voiceseg,vosl);           % ƽ������
%%%%%%%%   ��ͼ   %%%%%%%%

x_limit = max(time); y_limit = 100;

figure('NumberTitle', 'off', 'Name', 'Cepstrum');
subplot 211, plot(time,x,'k');  title('�����ź�')
axis([0 x_limit -1 1]);   ylabel('��ֵ');
subplot 212; plot(frameTime,T0Cep,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('���׷���������'); 
grid; xlabel('ʱ��/s'); ylabel('������');
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end

figure('NumberTitle', 'off', 'Name', 'ACF');
subplot 411, plot(time,x,'k');  title('�����ź�')
axis([0 x_limit -1 1]);   ylabel('��ֵ');

subplot 412; plot(frameTime,T0_ACF1,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('ACFֱ�ӷ���������'); 
grid; xlabel('ʱ��/s'); ylabel('������');

subplot 413; plot(frameTime,T0_ACF2,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('ACF������������������'); 
grid; xlabel('ʱ��/s'); ylabel('������');

subplot 414; plot(frameTime,T0_ACF3,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('ACF����ƽ��������������'); 
grid; xlabel('ʱ��/s'); ylabel('������');

for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    subplot 411
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end

figure('NumberTitle', 'off', 'Name', 'AMDF');
subplot 511, plot(time,x,'k');  title('�����ź�')
axis([0 x_limit -1 1]);   ylabel('��ֵ');

subplot 512; plot(frameTime,T0_AMDF1,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('AMDFֱ�ӷ���������'); 
grid; xlabel('ʱ��/s'); ylabel('������');

subplot 513; plot(frameTime,T0_AMDF2,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('�Ľ�AMDF����������'); 
grid; xlabel('ʱ��/s'); ylabel('������');

subplot 514; plot(frameTime,T0_AMDF3,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('CAMDF����������'); 
grid; xlabel('ʱ��/s'); ylabel('������');

subplot 515; plot(frameTime,T0_AMDF4,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('�Ľ�CAMDF����������'); 
grid; xlabel('ʱ��/s'); ylabel('������');
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    subplot 511
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end