%运算使用弧度制
%问题：数据中存在NaN于inf
%% %数据初始化
load('data_preprocessed.mat')
EL_deg=EL;AZ_deg=AZ;
EL=deg2rad(EL);%水平测量角点
AZ=deg2rad(AZ);%俯仰测量角点
Phase_cleaned=deg2rad(Phase_cleaned);%幅度测量值（处理数据预误差后的）
phi_idg=deg2rad(10);%目标位置的水平角索引值
theta_idg=deg2rad(5);%目标位置的俯仰角索引值

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
Prev=zeros(5,32);%前面一层(前面一个移相器的最佳配置)

%% % 子覆盖: AZ水平index:31-43 EL俯仰index: 16-22  
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

%% %全局覆盖
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
        if ismember(i,index_chosen)%如果之前已经被选，直接跳过
            continue;
        end
        
        tmp_value=value(double(cover_g|covers(:,:,i)));
        if tmp_value>tmp_maxvalue
            tmp_maxvalue=tmp_value;%保存当前步骤下的最优价值
            tmp_i=i;%保存当前步骤下最优价值选择的波束编号
        end
    end
    
    if tmp_i==0
        break;
    end
    cover_g=double(cover_g|covers(:,:,tmp_i));
    ZM=[ZM,zs(tmp_i,:)'];
    index_chosen=[index_chosen,tmp_i];
end

%% %验证结果
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


%保存结果
result=zeros(73*37,3);
for i=1:73*37
    result(i,:)=[EL_deg(i),AZ_deg(i),EP(i)];
end
csvwrite('./results/Emod_result.csv',result)

%目标区域的能量分布
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


%绘制结果图
surf(EL_deg,AZ_deg,Emod_result)
xlabel('EL')
ylabel('AZ')
zlabel('power')

%% %增加额外波束 编号(AZ38,EL16） 方位(5EL,-15AZ)
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

%目标区域的能量分布
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

%% %增加额外波束 编号(31,19）（42,16）方位（AZ -30,EL 0） （AZ 25,EL -15）
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

%目标区域的能量分布
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
%% %全局覆盖的value
function v=value(cover_g)
    global az1 az2 el1 el2
    v=sum(sum(cover_g(az1:az2,el1:el2)));
end