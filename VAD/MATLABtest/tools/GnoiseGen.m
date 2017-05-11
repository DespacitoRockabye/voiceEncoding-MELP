function [ y,noise ] = GnoiseGen( x,snr )
%高斯白噪声产生

noise = randn(size(x));
Nx = length(x);
signal_power = 1/Nx*sum(x.*x);
noise_power= 1/Nx*sum(noise.*noise);
noise_variance = signal_power / (10^(snr/10));
noise = sqrt(noise_variance / noise_power)*noise;
y = x+noise;
end

