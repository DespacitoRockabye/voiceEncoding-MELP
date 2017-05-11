function zcr = STA_ZCR( y, fn )
%STA_ZCR short time average zero-crossing rate

if size(y,2)~=fn, y = y';end

wlen = size(y,1);
zcr = zeros(1,fn);
delta = 0.01;

for i = 1:fn
    %smooth
    yn = y(:,i);
    for k = 1: wlen
        if yn(k)>= delta
            ym(k) = yn(k) - delta;
        elseif yn(k) < -delta
            ym(k) = yn(k) + delta;
        else
            ym(k) = 0;
        end
    end
    
    zcr(i) = sum(ym(1: end-1).*ym(2:end)<0);
end


