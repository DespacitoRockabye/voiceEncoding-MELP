%start=[ 1  8  15  22  29  37  47  60  79  110  165];
%send=[ 7  14  21  28  36  46  59  78  109  164  267];
%duration=[ 7  7  7  7  8  10  13  19  31  55  103];

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
[voiceseg,vsl,SF,NF]=vad_param1D(MDm,T1,T2);% 用小波分解系数平均幅值积法的双门限端点检测
