clear all
pop=[1350.11	825.41	475.55		743.06	383.45	451.95		320.96...
    405.96	246.05	307.35	434.08	285.00	302.16	605.89...
    264.05	555.21	251.12	608.08	163.41	1137.87];
re=pop/sum(pop);
re=re';

%% %�����������
run calP.m
W=[0.1865 0.4198 0.4665
   0.3999 0.8998 0.9999
   0.1050 0.2362 0.2625];
need=zeros(10,1);
for i=1:10
    need(i)=sum(sum(W.*P10(:,:,i)));
end

%��10���������
need(10)*re