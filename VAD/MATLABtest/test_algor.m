addpath(genpath(pwd));
close all;
clear all;

SNRset = -5;
methodNumSet = 1;

SNRnum = size(SNRset, 2);
for snrIndex = 1:SNRnum%15个SNR
    SNR = SNRset(snrIndex);
    tempResult = zeros(3,20);
    
    for temp = 1:20
        
        methodNum = 1;
        run SET_I;
        run INIT;
        
    Cepstrum;
  




        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars C0 Cn Dcep Dst0 Dstm dth i k NF nx1 nx2 SF T1 T2 u U voiceseg vsl;
        
  
    end
    
    for tempMethodIndex = 1:methodNumSet
        for tempParaIndex = 1:3
            methodMean(snrIndex,tempParaIndex,tempMethodIndex) = mean(methodResult(tempParaIndex,:,tempMethodIndex));
            %methodMean(SNR，评价参数，方法)
        end
    end
        
end

index = 1:SNRnum;
figure('NumberTitle', 'off', 'Name', 'VDR');
plot(index, methodMean(:,1,1),'r-o',index, methodMean(:,1,2), 'b-o',index, methodMean(:,1,3),'g-o',index, methodMean(:,1,4),'k-o',index, methodMean(:,1,5),'c-o',index, methodMean(:,1,6),'m-o',index, methodMean(:,1,7),'r-x');
legend('DoubleThreshold','Autocorrelation','Variance','Cepstrum','MFCC','SpectralEntropy','EoverZCR',-1);
figure('NumberTitle', 'off', 'Name', 'VDER');
plot(index, methodMean(:,2,1),'r-o',index, methodMean(:,2,2), 'b-o',index, methodMean(:,2,3),'g-o',index, methodMean(:,2,4),'k-o',index, methodMean(:,2,5),'c-o',index, methodMean(:,2,6),'m-o',index, methodMean(:,2,7),'r-x');
legend('DoubleThreshold','Autocorrelation','Variance','Cepstrum','MFCC','SpectralEntropy','EoverZCR',-1);
figure('NumberTitle', 'off', 'Name', 'CORRECT');
plot(index, methodMean(:,3,1),'r-o',index, methodMean(:,3,2), 'b-o',index, methodMean(:,3,3),'g-o',index, methodMean(:,3,4),'k-o',index, methodMean(:,3,5),'c-o',index, methodMean(:,3,6),'m-o',index, methodMean(:,3,7),'r-x');
legend('DoubleThreshold','Autocorrelation','Variance','Cepstrum','MFCC','SpectralEntropy','EoverZCR',-1);