clear all
load('data_preprocessed.mat')
load('result_model1.mat')
Phase_cleaned=deg2rad(Phase_cleaned);

raw_E=zeros(73,37,32,5);%电场的复数表示
for i=1:32
    for j=1:4
        raw_E(:,:,i,j+1)=10.^(LogMag_cleaned(:,:,i,j)/20).*exp(1i.*Phase_cleaned(:,:,i,j));
    end
end
raw_E(isnan(raw_E))=0;
raw_E(raw_E==-inf)=0;

sum_E=0;
for i=1:32
    if z(i)==1
        continue
    end
    sum_E=sum_E+raw_E(:,:,i,z(i));
end

E_mod=abs(sum_E);
E_P=20*log(E_mod);
sprintf('target:%f',E_P(39,20))
sprintf('forbid:%f',E_P(39,21))
sprintf('target/forbid:%f',E_P(39,20)/E_P(39,21))