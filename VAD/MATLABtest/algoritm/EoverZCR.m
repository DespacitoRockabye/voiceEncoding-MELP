aparam=2; bparam=1;                     % ���ò���
etemp=sum(y.^2);                        % ��������
etemp1=log10(1+etemp/aparam);           % ���������Ķ���ֵ
zcr=zc2(y,fn);                          % ������ֵ
Ecr=etemp1./(zcr+bparam);               % ���������

Ecrm=multimidfilter(Ecr,2);             % ƽ������
dth=mean(Ecrm(1:(NIS)));                % ��ֵ����
T1=1.2*dth;
T2=2*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Ecrm,T1,T2);% ����ȷ���˫���޶˵���