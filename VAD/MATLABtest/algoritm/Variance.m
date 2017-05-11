
Y=fft(y);                               % FFT变换
N2=wlen/2+1;                            % 取正频率部分
n2=1:N2;
Y_abs=abs(Y(n2,:));                     % 取幅值

for k=1:fn                              % 计算每帧的频带方差
    Dvar(k)=var(Y_abs(:,k))+eps;
end
dth=mean(Dvar(1:NIS));                  % 求取阈值
T1=1.2*dth;
T2=1.7*dth;

%fprintf('===============\n');
%fprintf(['方差法结果- SNR = ' num2str(SNR) '\n']);
[voiceseg,vsl,SF,NF]=vad_param1D(Dvar,T1,T2);% 频域方差双门限的端点检测

%{
figure('NumberTitle', 'off', 'Name', 'Variance');
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Dvar,'k');
title('短视频带方差值函数'); axis([0 max(time) 0.9*T1 1.2*T2]);
xlabel('时间/s'); ylabel('幅值'); 
line([0,frameTime(fn)], [T1 T1], 'color','r','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','r','LineStyle','-');

for k=1 : vsl                           % 标出语音端点
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
%}

