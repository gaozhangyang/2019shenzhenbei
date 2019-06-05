%����ʹ�û�����
%���⣺�����д���NaN��inf
%% %���ݳ�ʼ��
load('data_preprocessed.mat')
EL_deg=EL;AZ_deg=AZ;
EL=deg2rad(EL);%ˮƽ�����ǵ�
AZ=deg2rad(AZ);%���������ǵ�
Phase_cleaned=deg2rad(Phase_cleaned);%���Ȳ���ֵ����������Ԥ����ģ�
phi_idg=deg2rad(10);%Ŀ��λ�õ�ˮƽ������ֵ
theta_idg=deg2rad(5);%Ŀ��λ�õĸ���������ֵ

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
Prev=zeros(5,32);%ǰ��һ��(ǰ��һ�����������������)

%% % �Ӹ���: AZˮƽindex:31-43 EL����index: 16-22  
covers=zeros(73,37,91);
Emods=zeros(73,37,91);
zs=zeros(91,32);
idx=1;
for az=az1:az2
    for el=el1:el2
        [cover,E_mod,z] =sub_cover(az,el,LogMag_cleaned,Phase_cleaned,AZ,EL);
        
        covers(:,:,idx)=cover;
        Emods(:,:,idx)=E_mod;
        zs(idx,:)=z;
        
        surf(EL_deg,AZ_deg,cover),view(0,90)
        fcover = sprintf('./results/%d_cover(%d,%d).jpg',idx,az,el);
        xlabel('EL')
        ylabel('AZ')
        saveas(gcf,fcover); 
        
        surf(EL_deg,AZ_deg,E_mod),view(-30,60)
        xlabel('EL')
        ylabel('AZ')
        zlabel('power')
        fEmod = sprintf('./results/%d_Emod(%d,%d).jpg',idx,az,el);
        saveas(gcf,fEmod); 
        
        idx=idx+1;
    end
end
save('./results/sub_cover.mat','covers','Emods','zs')

%% %ȫ�ָ���
load('./results/sub_cover.mat')
global az1 az2 el1 el2
az1=31;az2=43;
el1=16;el2=22;
cover_g=zeros(73,37);
index_chosen=[];
ZM=[];

tmp_i=1;
while value(cover_g)<91
    tmp_maxvalue=0;
    tmp_i=0;
    for i=1:91
        if ismember(i,index_chosen)%���֮ǰ�Ѿ���ѡ��ֱ������
            continue;
        end
        
        tmp_value=value(double(cover_g|covers(:,:,i)));
        if tmp_value>tmp_maxvalue
            tmp_maxvalue=tmp_value;%���浱ǰ�����µ����ż�ֵ
            tmp_i=i;%���浱ǰ���������ż�ֵѡ��Ĳ������
        end
    end
    
    if tmp_i==0
        break;
    end
    cover_g=double(cover_g|covers(:,:,tmp_i));
    ZM=[ZM,zs(tmp_i,:)'];
    index_chosen=[index_chosen,tmp_i];
end

%% %��֤���
Emod_result=0;
M=length(index_chosen);
for i=1:M
    Emod_result=max(Emod_result,Emods(:,:,index_chosen(i)));
end
EP=20*log10(Emod_result);
target=EP(az1:az2,el1:el2);
sprintf("mean:%f",mean(mean(target)))
sprintf("max:%f",max(max(target)))
sprintf("min:%f",min(min(target)))


%������
result=zeros(73*37,3);
for i=1:73*37
    result(i,:)=[EL_deg(i),AZ_deg(i),EP(i)];
end
csvwrite('./results/Emod_result.csv',result)

%Ŀ������������ֲ�
P_target=zeros(91,3);
n=1;
x=EL_deg(1,:);
y=AZ_deg(:,1);
for j=az1:az2
    for i=el1:el2
        P_target(n,1)=x(i);
        P_target(n,2)=y(j);
        P_target(n,3)=EP(j,i);
        n=n+1;
    end
end
csvwrite('./results/P_target.csv',P_target)


%���ƽ��ͼ
surf(EL_deg,AZ_deg,Emod_result)
xlabel('EL')
ylabel('AZ')
zlabel('power')

%% %���Ӷ��Ⲩ�� ���(AZ38,EL16�� ��λ(5EL,-15AZ)
idx=(38-az1)*7+16-el1+1;
ZM=[ZM,zs(idx,:)'];
index_chosen=[index_chosen,idx];
Emod_result=0;
M=length(index_chosen);
for i=1:M
    Emod_result=max(Emod_result,Emods(:,:,index_chosen(i)));
end
EP=20*log10(Emod_result);
target=EP(az1:az2,el1:el2);
mean(mean(target))
min(min(target))

%Ŀ������������ֲ�
P_target=zeros(91,3);
n=1;
x=EL_deg(1,:);
y=AZ_deg(:,1);
for j=az1:az2
    for i=el1:el2
        P_target(n,1)=x(i);
        P_target(n,2)=y(j);
        P_target(n,3)=EP(j,i);
        n=n+1;
    end
end
csvwrite('./results/P_target2.csv',P_target)

%% %���Ӷ��Ⲩ�� ���(31,19����42,16����λ��AZ -30,EL 0�� ��AZ 25,EL -15��
idx2=(31-az1)*7+19-el1+1;
idx3=(42-az1)*7+16-el1+1;
ZM=[ZM,zs(idx2,:)'];
index_chosen=[index_chosen,idx2];
ZM=[ZM,zs(idx3,:)'];
index_chosen=[index_chosen,idx3];

Emod_result=0;
M=length(index_chosen);
for i=1:M
    Emod_result=max(Emod_result,Emods(:,:,index_chosen(i)));
end
EP=20*log10(Emod_result);
target=EP(az1:az2,el1:el2);
mean(mean(target))
min(min(target))

%Ŀ������������ֲ�
P_target=zeros(91,3);
n=1;
x=EL_deg(1,:);
y=AZ_deg(:,1);
for j=az1:az2
    for i=el1:el2
        P_target(n,1)=x(i);
        P_target(n,2)=y(j);
        P_target(n,3)=EP(j,i);
        n=n+1;
    end
end
csvwrite('./results/P_target3.csv',P_target)
mean(mean(target))
min(min(target))
%% %ȫ�ָ��ǵ�value
function v=value(cover_g)
    global az1 az2 el1 el2
    v=sum(sum(cover_g(az1:az2,el1:el2)));
end