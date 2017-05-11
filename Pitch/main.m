close all; clear all;

run Set_II;                                 % 参数设置
run Part_II;                                % 读入文件,分帧和端点检测

lmin=fix(fs/500);                           % 基音周期提取中最小值
lmax=fix(fs/60);                            % 基音周期提取中最大值

%%%%%%%%   倒谱法   %%%%%%%%
periodCep=zeros(1,fn);
periodCep = Cep(y,fn,voiceseg,vosl,lmax,lmin);
T0Cep=zeros(1,fn);
T0Cep=pitfilterm1(periodCep,voiceseg,vosl);

%%%%%%%%   自相关法   %%%%%%%%
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % 带通数字滤波
yy  = enframe(xx,wlen,inc)';                    % 滤波后信号分帧

periodACF1=zeros(1,fn);                             % 基音周期初始化
periodACF1=ACF_corr(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_ACF1=pitfilterm1(periodACF1,voiceseg,vosl);           % 平滑处理

periodACF2=zeros(1,fn);                             % 基音周期初始化
periodACF2=ACF_clip(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_ACF2=pitfilterm1(periodACF2,voiceseg,vosl);           % 平滑处理

periodACF3=zeros(1,fn);                             % 基音周期初始化
periodACF3=ACF_threelevel(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_ACF3=pitfilterm1(periodACF3,voiceseg,vosl);           % 平滑处理


%%%%%%%%   平均幅度差法   %%%%%%%%
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % 带通数字滤波
yy  = enframe(xx,wlen,inc)';                    % 滤波后信号分帧

periodAMDF1=zeros(1,fn);                             % 基音周期初始化
periodAMDF1=AMDF_1(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_AMDF1=pitfilterm1(periodAMDF1,voiceseg,vosl);           % 平滑处理

periodAMDF2=zeros(1,fn);                             % 基音周期初始化
periodAMDF2=AMDF_mod(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_AMDF2=pitfilterm1(periodAMDF2,voiceseg,vosl);           % 平滑处理

periodAMDF3=zeros(1,fn);                             % 基音周期初始化
periodAMDF3=CAMDF_1(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_AMDF3=pitfilterm1(periodAMDF3,voiceseg,vosl);           % 平滑处理

periodAMDF4=zeros(1,fn);                             % 基音周期初始化
periodAMDF4=CAMDF_mod(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0_AMDF4=pitfilterm1(periodAMDF4,voiceseg,vosl);           % 平滑处理
%%%%%%%%   作图   %%%%%%%%

x_limit = max(time); y_limit = 100;

figure('NumberTitle', 'off', 'Name', 'Cepstrum');
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 x_limit -1 1]);   ylabel('幅值');
subplot 212; plot(frameTime,T0Cep,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('倒谱法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end

figure('NumberTitle', 'off', 'Name', 'ACF');
subplot 411, plot(time,x,'k');  title('语音信号')
axis([0 x_limit -1 1]);   ylabel('幅值');

subplot 412; plot(frameTime,T0_ACF1,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('ACF直接法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');

subplot 413; plot(frameTime,T0_ACF2,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('ACF中心削波法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');

subplot 414; plot(frameTime,T0_ACF3,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('ACF三电平削波法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');

for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    subplot 411
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end

figure('NumberTitle', 'off', 'Name', 'AMDF');
subplot 511, plot(time,x,'k');  title('语音信号')
axis([0 x_limit -1 1]);   ylabel('幅值');

subplot 512; plot(frameTime,T0_AMDF1,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('AMDF直接法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');

subplot 513; plot(frameTime,T0_AMDF2,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('改进AMDF法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');

subplot 514; plot(frameTime,T0_AMDF3,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('CAMDF法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');

subplot 515; plot(frameTime,T0_AMDF4,'k'); 
xlim([0 x_limit]); ylim([0 y_limit]); 
title('改进CAMDF法基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    subplot 511
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end