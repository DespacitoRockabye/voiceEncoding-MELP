clear all;

run Set_II;                                 % 参数设置
run Part_II;                                % 读入文件,分帧和端点检测

lmin=fix(fs/500);                           % 基音周期提取中最小值
lmax=fix(fs/60);                            % 基音周期提取中最大值

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

x_limit = max(time); y_limit = 100;
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