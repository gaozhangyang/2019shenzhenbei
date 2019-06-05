%% %���ݳ�ʼ��
load('data_preprocessed.mat')
EL=deg2rad(EL);
AZ=deg2rad(AZ);
Phase_cleaned=deg2rad(Phase_cleaned);
phi_g=deg2rad(10);
theta_g=deg2rad(5);
G=zeros(5,32);%��������
sum_E=zeros(73,37,32,5);%�ۼӵ糡��73ˮƽ����λ��37��������λ��32�����У�5������������

%����������ת��Ϊ������ʾ
raw_E=zeros(73,37,32,5);%�糡�ĸ�����ʾ
for i=1:32
    for j=1:4
        raw_E(:,:,i,j+1)=10.^(LogMag_cleaned(:,:,i,j)/20).*exp(1i.*Phase_cleaned(:,:,i,j));
    end
end
raw_E(isnan(raw_E))=0;
raw_E(raw_E==-inf)=0;

z=zeros(1,32);%����������ʸ��
Prev=zeros(5,32);%