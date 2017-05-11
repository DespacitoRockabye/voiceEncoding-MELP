function period=Cep(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
wlen=size(y,1);                           % 取得帧长
period=zeros(1,fn);                       % 初始化

for i=1 : vsl                             % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y(:,k+ixb-1);                   % 取来一帧数据
        u1 = u.*hamming(wlen);
        xx=fft(u1);                         % FFT
        a=2*log(abs(xx)+eps);               % 取模值和对数
        b=ifft(a); 
        [~,Lc]=max(b(lmin:lmax));     % 在lmin和lmax区间中寻找最大值
        period(k+ixb-1)=Lc+lmin-1;
    end
end