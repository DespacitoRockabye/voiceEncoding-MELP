aparam=2; bparam=1;                     % 设置参数
etemp=sum(y.^2);                        % 计算能量
etemp1=log10(1+etemp/aparam);           % 计算能量的对数值
zcr=zc2(y,fn);                          % 求过零点值
Ecr=etemp1./(zcr+bparam);               % 计算能零比

Ecrm=multimidfilter(Ecr,2);             % 平滑处理
dth=mean(Ecrm(1:(NIS)));                % 阈值计算
T1=1.2*dth;
T2=2*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Ecrm,T1,T2);% 能零比法的双门限端点检测