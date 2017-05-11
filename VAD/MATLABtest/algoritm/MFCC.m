ccc=mfcc_m(signal,fs,16,wlen,inc);      % 计算MFCC
fn1=size(ccc,1);                        % 取帧数1
frameTime1=frameTime(3:fn-2);           % MFCC对应的时间刻度
Ccep=ccc(:,1:16);                       % 取得MFCC系数
C0=mean(Ccep(1:5,:),1);                 % 计算噪声平均MFCC倒谱系数的估计值
for i=6 : fn1
    Cn=Ccep(i,:);                       % 取一帧MFCC倒谱系数
    Dstu=0;
    for k=1 : 16                        % 从第6帧开始计算每帧MFCC倒谱系数与
        Dstu=Dstu+(Cn(k)-C0(k))^2;      % 噪声MFCC倒谱系数的距离
    end
    Dcep(i)=sqrt(Dstu);
end
Dcep(1:5)=Dcep(6);

Dstm=multimidfilter(Dcep,2);            % 平滑处理
dth=max(Dstm(1:NIS-2));                 % 阈值计算
T1=1.2*dth;
T2=1.5*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Dstm,T1,T2);% MFCC倒谱距离双门限的端点检测

