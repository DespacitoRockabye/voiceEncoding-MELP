addpath(genpath(pwd));
close all;
clear all;

SNRset = -5:5:15;
methodNumSet = 9;
tempSet = 10;

SNRnum = size(SNRset, 2);
cputimeResult= zeros(1,methodNumSet);
for snrIndex = 1:SNRnum%15��SNR
    SNR = SNRset(snrIndex);
    tempResult = zeros(3,20);
    
    for temp = 1:tempSet
        run SET_I;
        run INIT;
        methodNum = 1;
        countTimer = (temp-1)+((snrIndex-1)*tempSet);
        
        cputime1 = cputime;
        run DoubleThreshold;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        %methodResult(���۲�����ѭ������������)
        methodNum = methodNum+1;
        clearvars amp amp1 amp2 ampm ampth NF SF voiceseg vsl zcr zcr2 zcrm zcrth;
        
        cputime1 = cputime;
        run Autocorrelation;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars k NF ru Ru Rum SF T1 T2 thredth u voiceseg vsl;
        
        cputime1 = cputime;
        run Variance;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars dth Dvar k n2 N2 NF SF T1 T2 voiceseg vsl Y Y_abs;
        
        cputime1 = cputime;
        run Cepstrum;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars C0 Cn Dcep Dst0 Dstm dth i k NF nx1 nx2 SF T1 T2 u U voiceseg vsl;
        
        cputime1 = cputime;
        run MFCC;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn1,SF,frameTime);
        methodNum = methodNum+1;
        clearvars C0 ccc Ccep Cn Dcep Dstm Dstu dth fn1 frameTime1 i k NF nx1 nx2 SF T1 T2 voiceseg vsl;
        
        cputime1 = cputime;
        run SpectralEntropy;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars Det Enm Ep eth H i Me NF prob SF SP T1 T2 voiceseg vsl;
        
        cputime1 = cputime;
        run EoverZCR;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars aparam bparam dth Ecr Ecrm etemp etemp1 NF SF T1 T2 voiceseg vsl zcr;
        
        cputime1 = cputime;
        run EoverEntropy;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars aparam Det Ef Enm Esum eth H i Me prob NF SF T1 T2 voiceseg vsl zcr;
        
        cputime1 = cputime;
        run WaveletTrans;
        cputimeResult(methodNum) = (cputimeResult(methodNum)*(countTimer)+cputime-cputime1)/(countTimer+1);
        [methodResult(1,temp,methodNum),methodResult(2,temp,methodNum),methodResult(3,temp,methodNum)]=evaluation( fn,SF,frameTime);
        methodNum = methodNum+1;
        clearvars c duration E i index k l lNum M1 M2 MD MDm MDmth send start u NF SF T1 T2 voiceseg vsl zcr;
  
    end
    
    for tempMethodIndex = 1:methodNumSet
        for tempParaIndex = 1:3
            methodMean(snrIndex,tempParaIndex,tempMethodIndex) = mean(methodResult(tempParaIndex,:,tempMethodIndex));
            %methodMean(SNR�����۲���������)
        end
    end
        
end

index = 1:SNRnum;
figure('NumberTitle', 'off', 'Name', 'VDR');
plot(index, methodMean(:,1,1),'r-o',index, methodMean(:,1,2), 'b-o',index, methodMean(:,1,3),'g-o',index, methodMean(:,1,4),'k-o',index, methodMean(:,1,5),'c-o',index, methodMean(:,1,6),'m-o',index, methodMean(:,1,7),'r-x',index, methodMean(:,1,8),'b-x',index, methodMean(:,1,9),'g-x');
legend('DoubleThreshold','Autocorrelation','Variance','Cepstrum','MFCC','SpectralEntropy','EoverZCR','EoverEntropy','WaveletTrans',-1);
figure('NumberTitle', 'off', 'Name', 'VDER');
plot(index, methodMean(:,2,1),'r-o',index, methodMean(:,2,2), 'b-o',index, methodMean(:,2,3),'g-o',index, methodMean(:,2,4),'k-o',index, methodMean(:,2,5),'c-o',index, methodMean(:,2,6),'m-o',index, methodMean(:,2,7),'r-x',index, methodMean(:,2,8),'b-x',index, methodMean(:,2,9),'g-x');
legend('DoubleThreshold','Autocorrelation','Variance','Cepstrum','MFCC','SpectralEntropy','EoverZCR','EoverEntropy','WaveletTrans',-1);
figure('NumberTitle', 'off', 'Name', 'CORRECT');
plot(index, methodMean(:,3,1),'r-o',index, methodMean(:,3,2), 'b-o',index, methodMean(:,3,3),'g-o',index, methodMean(:,3,4),'k-o',index, methodMean(:,3,5),'c-o',index, methodMean(:,3,6),'m-o',index, methodMean(:,3,7),'r-x',index, methodMean(:,3,8),'b-x',index, methodMean(:,3,9),'g-x');
legend('DoubleThreshold','Autocorrelation','Variance','Cepstrum','MFCC','SpectralEntropy','EoverZCR','EoverEntropy','WaveletTrans',-1);
figure('NumberTitle', 'off', 'Name', 'Time');
bar(cputimeResult);
