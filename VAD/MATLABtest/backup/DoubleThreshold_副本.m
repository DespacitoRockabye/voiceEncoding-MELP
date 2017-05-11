function [ voiceSeg,vsl,SF,NF ] = DoubleThreshold( x,wlen,inc,NIS )
%Ë«ÃÅÏÞ·¨


x = x(:);%change x in to column vector

%some parameters
status = 0;                             %status of frame
xn = 1;                                     %voice number in this segment
%silenceXn = 0;                   %silence length of this voice
%countXn = 0;                     %total length of this voice
%x1 = 0;                                  %begin point of the xn voice
%x2 = 0;                                  %end point of the xn voice
silenceTh =8;                         %the min silence length after a voice segment
countTh = 5;                          %the min length which can be regard as a voice

% enframe
y = enframe(x, wlen, inc)';
[~, fn ] = size(y);

% short time average energy
amp = STA_E(y);

% short time average zero-crossing rate
zcr = STA_ZCR(y, fn);

% set the threshold
ampNW = mean(amp(1:NIS));
zcrNW = mean(zcr(1:NIS));
amp2 = 2*ampNW;
amp1 = 4*ampNW;%higher threshold
zcr2 = 2*zcrNW;


%begin loop

for n = 1:fn
    switch status
        case {0,1} % 0- no words, 1- suspect
            if amp(n) > amp1 %convinced voice
                status = 2;
                x1(xn) = max(n-countXn(xn) - 1, 1);
                silenceXn(xn) = 0;
                countXn(xn)  = countXn(xn) + 1;
                               
            elseif amp(n) > amp2 || zcr(n) > zcr2 %maybe voice
                status = 1;
                countXn(xn)  = countXn(xn) + 1;
                
            else %convinced no voice
                status = 0;
                countXn(xn)  = 0;
                x1(xn) = 0;
                x2(xn) = 0;
                
            end
            
        case 2, % 2- voice
            if amp(n) > amp2 && zcr(n) > zcr2 %keep voice
                countXn(xn) = countXn(xn) + 1;

            else % voice are going to end
                silenceXn(xn) = silenceXn(xn) + 1;
                
                if silenceXn(xn) < silenceTh % silence is too short and the voice segment maybe not end
                    countXn(xn) = countXn(xn) + 1;
                elseif countXn(xn) < countTh % voice is too short and it may be noise
                    status = 0;
                    silenceXn(xn) = 0;
                    countXn(xn) = 0;
                else% the voice appeared and is end
                    status = 3;
                    x2(xn) = x1(xn) + countXn(xn);
                end
            end
            
        case 3, %this voice segment is end
            xn = xn+1;
            status = 0;
            silenceXn(xn) = 0;
            countXn(xn) = 0;
            x1(xn) = 0;
            x2(xn) = 0;
            
    end
end

voiceAmount = length(x1);
%correct the x1 and x2
if x1(voiceAmount) == 0, voiceAmount = voiceAmount-1;end
if x2(voiceAmount) == 0
    fprintf('ERROR: no endpoint');
    x2(voiceAmount) = fn;
end

SF = zeros(1, fn);
NF = ones(1, fn);

for i = 1: voiceAmount
    SF(x1(i):x2(i)) = 1;
    NF(x1(i):x2(i)) = 0;
end

speechIndex = find(SF==1);
voiceSeg = findSegment(speechIndex);
vsl = length(voiceSeg);


end

