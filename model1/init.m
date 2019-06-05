%% %数据初始化
load('data_preprocessed.mat')
EL=deg2rad(EL);
AZ=deg2rad(AZ);
Phase_cleaned=deg2rad(Phase_cleaned);
phi_g=deg2rad(10);
theta_g=deg2rad(5);
G=zeros(5,32);%评估函数
sum_E=zeros(73,37,32,5);%累加电场，73水平测量位，37俯仰测量位，32个阵列，5个移相器配置

%将测量数据转化为复数表示
raw_E=zeros(73,37,32,5);%电场的复数表示
for i=1:32
    for j=1:4
        raw_E(:,:,i,j+1)=10.^(LogMag_cleaned(:,:,i,j)/20).*exp(1i.*Phase_cleaned(:,:,i,j));
    end
end
raw_E(isnan(raw_E))=0;
raw_E(raw_E==-inf)=0;

z=zeros(1,32);%移相器配置矢量
Prev=zeros(5,32);%