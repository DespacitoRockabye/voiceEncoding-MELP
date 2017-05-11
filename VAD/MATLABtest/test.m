close all;
clear all;

SNR = 0;
tempResult = zeros(3,20);

run SET_I;
run INIT;

%start=[ 1  8  15  22  29  37  47  60  79  110  165];
%send=[ 7  14  21  28  36  46  59  78  109  164  267];
%duration=[ 7  7  7  7  8  10  13  19  31  55  103];

%{
lNum = size(l,1)-1;
start = zeros(lNum);
send = zeros(lNum);
duration = zeros(lNum);

duration(:) = l(1:lNum);
start(1) = 1;
send(1) = duration(1);
for index = 2:lNum
    start(index) = start(index-1)+duration(index-1);
    send(index) = send(index-1)+duration(index);
end
%}

for i=1 : fn
    u=y(:,i);                           % 取一帧
    [c,l]=wavedec(u,10,'db4');          % 用母小波db4进行10层分解
    
    lNum = size(l,1)-1;
    start = zeros(1,lNum);
    send = zeros(1,lNum);
    duration = zeros(1,lNum);

    duration(:) = l(1:lNum);
    start(1) = 1;
    send(1) = duration(1);
    for index = 2:lNum
        start(index) = start(index-1)+duration(index-1);
        send(index) = send(index-1)+duration(index);
    end
    
    
    
    for k=1 : 10
        E(11-k)=mean(abs(c(start(k+1):send(k+1))));% 计算每层的平均幅值
    end
    M1=max(E(1:5)); M2=max(E(6:10));    % 按式(6-8-2)求M1和M2
    MD(i)=M1*M2;                        % 按式(6-8-3)计算MD
end



MDm=multimidfilter(MD,10);              % 平滑处理
MDmth=mean(MDm(1:NIS));                 % 计算阈值
T1=2*MDmth;
T2=3*MDmth;
fprintf('===============\n');
fprintf(['小波变换法结果- SNR = ' num2str(SNR) '\n']);
[voiceseg,vsl,SF,NF]=vad_param1D(MDm,T1,T2);% 用小波分解系数平均幅值积法的双门限端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['加噪语音波形 信噪比=' num2str(SNR) 'dB']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,MDm,'k');
title('小波分解短时系数平均幅值积'); grid; ylim([0 1.2*max(MDm)]); 
xlabel('时间/s'); ylabel('幅值');
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 312; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 313; 
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(MDm)],'color','b','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(MDm)],'color','b','LineStyle','--');
end
evaluation_print( fn,SF,frameTime);


        



