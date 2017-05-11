
for k=2 : fn                            % 计算自相关函数
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end

Rum=multimidfilter(Ru,10);              % 平滑处理
Rum=Rum/max(Rum);                       % 归一化
thredth=max(Rum(1:NIS));                % 计算阈值
T1=1.1*thredth;
T2=1.3*thredth;

%fprintf('===============\n');
%fprintf(['自相关法结果- SNR = ' num2str(SNR) '\n']);
[voiceseg,vsl,SF,NF]=vad_param1D(Rum,T1,T2);% 自相关函数的端点检测

%{
figure('NumberTitle', 'off', 'Name', 'AutoCorrelation');
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Rum,'k');
title('短时自相关函数'); axis([0 max(time) 0.9*T1 1.2*T2]);
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

