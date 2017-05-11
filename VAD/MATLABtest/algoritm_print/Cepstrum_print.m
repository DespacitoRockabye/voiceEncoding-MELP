run SET_I                   % 基本设置
run INIT                  % 读入数据，分帧等准备
for i=1 : fn
    u=y(:,i);               % 取来一帧数据
    U(:,i)=rceps(u);        % 求取倒谱
end
C0=mean(U(:,1:5),2);        % 计算出前5帧倒谱系数的平均值作为背景噪声倒谱系数的估算值

for i=6 : fn                % 从第6帧开始计算每帧倒谱系数与背景噪声倒谱系数的距离
    Cn=U(:,i);                           
    Dst0=(Cn(1)-C0(1)).^2;
    Dstm=0;
    for k=2 :12
        Dstm=Dstm+(Cn(k)-C0(k)).^2;
    end
    Dcep(i)=4.3429*sqrt(Dst0+Dstm);     % 倒谱距离
end
Dcep(1:5)=Dcep(6);
Dstm=multimidfilter(Dcep,10);           % 平滑处理
dth=max(Dstm(1:(NIS)));                 % 阈值计算
T1=1.1*dth;
T2=1.2*dth;
%fprintf('===============\n');
%fprintf(['倒谱法- SNR = ' num2str(SNR) '\n']);
[voiceseg,vsl,SF,NF]=vad_param1D(Dstm,T1,T2);% 倒谱距离双门限的端点检测

figure('NumberTitle', 'off', 'Name', 'Ceptrum');
subplot 311; 
plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; 
plot(time,signal,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313;
plot(frameTime,Dstm,'k');
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
