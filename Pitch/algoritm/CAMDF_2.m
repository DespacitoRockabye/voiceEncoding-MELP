function period=CAMDF_2(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % ��yת��Ϊÿ�����ݱ�ʾһ֡�����ź�
period=zeros(1,fn);                       % ��ʼ��
wlen=size(y,1);                           % ȡ��֡��
for i=1 : vsl                             % ֻ���л������ݴ���
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % ��ȡһ���л��ε�֡��
    for k=1 : ixd                         % �Ըö��л������ݴ���
        u=y(:,k+ixb-1);                   % ȡ��һ֡����
        for m = 0:wlen-1
            R(m+1)=0;
            for n=0:wlen-1
                R(m+1) = R(m+1)+abs(u(mod(m+n,wlen)+1)-u(n+1)); % ����ѭ��ƽ�����Ȳ��
            end
        end 
        
        [Rmax,Rloc]=max(R(1:lmin));       % ������ֵ
        Rth=0.6*Rmax;                     % ����һ����ֵ
        
        R2_1 = [R(1) R];
        R2_2 = [R R(end)];
        R2_d = R2_2-R2_1;
        R2_dm = zeros(1,wlen);
        
        for index = 1:wlen
            if R2_d(index+1)>0
                R2_dm(index) = 1;
            else
                R2_dm(index) = 0;
            end
        end
        R2_dm1=[R2_dm(1) R2_dm];
        R2_dm2=[R2_dm R2_dm(end)];
        R2_flip = xor(R2_dm1,R2_dm2);
        T0=0;
        
        flipIndex = find(R2_flip(1:wlen/2+1) == 1);
        for index = 2:2: size(flipIndex,2)
            if R(flipIndex(index))<Rth
                T0 = flipIndex(index);
                period(k+ixb-1)=T0;
                break;
            end
        end
        
    end
end
end


