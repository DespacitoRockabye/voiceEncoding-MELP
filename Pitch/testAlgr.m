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


%period=AMDF_1(y,fn,voiceseg,vosl,lmax,lmin)
pn=size(yy,2);
if pn~=fn, yy=yy'; end                      % 把yy转换为每列数据表示一帧语音信号
period=zeros(1,fn);                       % 初始化
wlen=size(yy,1);                           % 取得帧长
for i=1 : vosl                             % 只对有话段数据处理
    ixb=voiceseg(i).begin;
    ixe=voiceseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=yy(:,k+ixb-1);                   % 取来一帧数据
        
        for m = 1:wlen
             R(m) = sum(abs(u(m:wlen)-u(1:wlen-m+1))); % 计算平均幅度差函数(AMDF)
        end 
        subplot(411);
        plot(R);
        
        [Rmax,Rloc]=max(R(1:lmax));       % 求出最大值
        Rth=0.6*Rmax;                     % 设置一个阈值
        
        line([0 wlen],[Rth Rth],'color','b');
        
        Rm=find(R(lmin:lmax)<=Rth);       % 在Pmin～Pmax区间寻找出小于该阈值的区间
        if isempty(Rm)                    % 如果找不到,T0置为0
            T0=0;
        else
            m11=Rm(1);                    % 如果有小于阈值的区间
            m22=lmax;
            [~,T]=min(R(m11:m22));     % 寻找最小值的谷值点
            if isempty(T)
                T0=0;
            else
                T0=T+m11-1;               % 把最小谷值点的位置赋于T0
            end
            period(k+ixb-1)=T0;           % 给出了该帧的基音周期
           
            line([T0 T0],[0 Rmax],'color','r');
        end
        
        
        for m = 0:wlen-1
            R2(m+1)=0;
            for n=0:wlen-1
                R2(m+1) = R2(m+1)+abs(u(mod(m+n,wlen)+1)-u(n+1)); % 计算循环平均幅度差函数
            end
        end 
        subplot(412);
        plot(R2);
        [Rmax2,Rloc2]=max(R2(1:lmax));       % 求出最大
        Rth2=0.7*Rmax2;                     % 设置一个阈值
        line([0 wlen],[Rth2 Rth2],'color','b');
        
        R2_1 = [R2(1) R2];
        R2_2 = [R2 R2(end)];
        R2_d = R2_2-R2_1;
        R2_dm = zeros(1,wlen);
        
        subplot(413);
        plot(R2_d,'r');
        line([0 wlen],[0 0],'color','k')
        axis([0 wlen 1.2*min(R2_d) 1.2*max(R2_d)]);
        
        for index = 1:wlen
            if R2_d(index+1)>0
                R2_dm(index) = 1;
            elseif R2_d(index+1)<0
                R2_dm(index) = 0;
            else
                R2_dm(index) = 0;
            end
        end
        
        R2_dm1=[R2_dm(1) R2_dm];
        R2_dm2=[R2_dm R2_dm(end)];
        R2_flip = xor(R2_dm1,R2_dm2);
        %R2_flip = R2_flip(2:end);
        subplot(414);
        plot(R2_flip);
        axis([0 wlen 1.2*min(R2_flip) 1.2*max(R2_flip)]);
        
        flipIndex = find(R2_flip(1:wlen/2+1) == 1);
        for index = 2:2: size(flipIndex,2)
            if R2(flipIndex(index))<Rth2
                T02 = flipIndex(index);           % 给出了该帧的基音周期
                subplot(412)
                line([T02 T02],[0 Rmax2],'color','r');
                break;
            end
        end
        
        %{
        [Rmax2,Rloc2]=max(R2(1:lmax));       % 求出最大值
        Rth2=0.8*Rmax2;                     % 设置一个阈值
        Rth2high=0.9*Rmax2;                     % 设置一个阈值
        
        line([0 wlen],[Rth2 Rth2],'color','b');
        
        limit_1 = lmin+find(R2(lmin:lmax)>=Rth2high);
        Rm2=find(R2(lmin:lmax)<=Rth2);       % 在Pmin～Pmax区间寻找出小于该阈值的区间
        if isempty(Rm2)                    % 如果找不到,T0置为0
            T02=0;
        else
            m11=limit_1(1);                    % 如果有小于阈值的区间
            m22=floor(wlen/2);
            [~,T]=min(R2(m11:m22));     % 寻找最小值的谷值点
            if isempty(T)
                T02=0;
            else
                T02=T+m11-1;               % 把最小谷值点的位置赋于T0
            end
            period2(k+ixb-1)=T02;           % 给出了该帧的基音周期
            line([T02 T02],[0 Rmax2],'color','r');
        end
        %}
        
        
    end
end
