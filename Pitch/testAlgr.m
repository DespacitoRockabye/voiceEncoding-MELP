clear all;

run Set_II;                                 % ��������
run Part_II;                                % �����ļ�,��֡�Ͷ˵���

lmin=fix(fs/500);                           % ����������ȡ����Сֵ
lmax=fix(fs/60);                            % ����������ȡ�����ֵ

b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % ��ͨ�����˲�
yy  = enframe(xx,wlen,inc)';                    % �˲����źŷ�֡


periodAMDF1=zeros(1,fn);                             % �������ڳ�ʼ��
periodAMDF1=AMDF_1(yy,fn,voiceseg,vosl,lmax,lmin); % ������غ�����ȡ��������
T0_AMDF1=pitfilterm1(periodAMDF1,voiceseg,vosl);           % ƽ������


%period=AMDF_1(y,fn,voiceseg,vosl,lmax,lmin)
pn=size(yy,2);
if pn~=fn, yy=yy'; end                      % ��yyת��Ϊÿ�����ݱ�ʾһ֡�����ź�
period=zeros(1,fn);                       % ��ʼ��
wlen=size(yy,1);                           % ȡ��֡��
for i=1 : vosl                             % ֻ���л������ݴ���
    ixb=voiceseg(i).begin;
    ixe=voiceseg(i).end;
    ixd=ixe-ixb+1;                        % ��ȡһ���л��ε�֡��
    for k=1 : ixd                         % �Ըö��л������ݴ���
        u=yy(:,k+ixb-1);                   % ȡ��һ֡����
        
        for m = 1:wlen
             R(m) = sum(abs(u(m:wlen)-u(1:wlen-m+1))); % ����ƽ�����Ȳ��(AMDF)
        end 
        subplot(411);
        plot(R);
        
        [Rmax,Rloc]=max(R(1:lmax));       % ������ֵ
        Rth=0.6*Rmax;                     % ����һ����ֵ
        
        line([0 wlen],[Rth Rth],'color','b');
        
        Rm=find(R(lmin:lmax)<=Rth);       % ��Pmin��Pmax����Ѱ�ҳ�С�ڸ���ֵ������
        if isempty(Rm)                    % ����Ҳ���,T0��Ϊ0
            T0=0;
        else
            m11=Rm(1);                    % �����С����ֵ������
            m22=lmax;
            [~,T]=min(R(m11:m22));     % Ѱ����Сֵ�Ĺ�ֵ��
            if isempty(T)
                T0=0;
            else
                T0=T+m11-1;               % ����С��ֵ���λ�ø���T0
            end
            period(k+ixb-1)=T0;           % �����˸�֡�Ļ�������
           
            line([T0 T0],[0 Rmax],'color','r');
        end
        
        
        for m = 0:wlen-1
            R2(m+1)=0;
            for n=0:wlen-1
                R2(m+1) = R2(m+1)+abs(u(mod(m+n,wlen)+1)-u(n+1)); % ����ѭ��ƽ�����Ȳ��
            end
        end 
        subplot(412);
        plot(R2);
        [Rmax2,Rloc2]=max(R2(1:lmax));       % ������
        Rth2=0.7*Rmax2;                     % ����һ����ֵ
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
                T02 = flipIndex(index);           % �����˸�֡�Ļ�������
                subplot(412)
                line([T02 T02],[0 Rmax2],'color','r');
                break;
            end
        end
        
        %{
        [Rmax2,Rloc2]=max(R2(1:lmax));       % ������ֵ
        Rth2=0.8*Rmax2;                     % ����һ����ֵ
        Rth2high=0.9*Rmax2;                     % ����һ����ֵ
        
        line([0 wlen],[Rth2 Rth2],'color','b');
        
        limit_1 = lmin+find(R2(lmin:lmax)>=Rth2high);
        Rm2=find(R2(lmin:lmax)<=Rth2);       % ��Pmin��Pmax����Ѱ�ҳ�С�ڸ���ֵ������
        if isempty(Rm2)                    % ����Ҳ���,T0��Ϊ0
            T02=0;
        else
            m11=limit_1(1);                    % �����С����ֵ������
            m22=floor(wlen/2);
            [~,T]=min(R2(m11:m22));     % Ѱ����Сֵ�Ĺ�ֵ��
            if isempty(T)
                T02=0;
            else
                T02=T+m11-1;               % ����С��ֵ���λ�ø���T0
            end
            period2(k+ixb-1)=T02;           % �����˸�֡�Ļ�������
            line([T02 T02],[0 Rmax2],'color','r');
        end
        %}
        
        
    end
end
