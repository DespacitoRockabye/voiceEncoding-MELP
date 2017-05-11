function [ y ] = STA_E( f )
%STA_E   -short time average energy

y = sum(f.^2);

end

