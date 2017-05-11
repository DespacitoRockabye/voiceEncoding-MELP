clear all;

run Set_II;                                 % ��������
run Part_II;                                % �����ļ�,��֡�Ͷ˵���

lmin=fix(fs/500);                           % ����������ȡ����Сֵ
lmax=fix(fs/60);                            % ����������ȡ�����ֵ

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

x_limit = max(time); y_limit = 100;
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