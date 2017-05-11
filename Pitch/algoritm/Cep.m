function period=Cep(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % ��yת��Ϊÿ�����ݱ�ʾһ֡�����ź�
wlen=size(y,1);                           % ȡ��֡��
period=zeros(1,fn);                       % ��ʼ��

for i=1 : vsl                             % ֻ���л������ݴ���
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % ��ȡһ���л��ε�֡��
    for k=1 : ixd                         % �Ըö��л������ݴ���
        u=y(:,k+ixb-1);                   % ȡ��һ֡����
        u1 = u.*hamming(wlen);
        xx=fft(u1);                         % FFT
        a=2*log(abs(xx)+eps);               % ȡģֵ�Ͷ���
        b=ifft(a); 
        [~,Lc]=max(b(lmin:lmax));     % ��lmin��lmax������Ѱ�����ֵ
        period(k+ixb-1)=Lc+lmin-1;
    end
end