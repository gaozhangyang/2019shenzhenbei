function [cover,E_mod,z] = sub_cover(phi_idg,theta_idg,LogMag_cleaned,Phase_cleaned,AZ,EL)
%SUB_COVER 此处显示有关此函数的摘要
%   此处显示详细说明
    %%  %初始化
    th_E=36;%电场截止阈值
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
    
    %% %前向递推
     N_z=0;
     for i=1:31
         for j=1:5
             m=-999;x2=1;%探索上一层采用哪种配置之前，将目标函数值m初始化为无穷小,配置x2初始化为1
             for x=1:5%寻找最好的x,保存至x2
                 last_E=sum_E(:,:,i,x);%累加到上一层，x配置下的总电场
                 next_E=last_E+raw_E(:,:,i+1,j);%累加到本层的总电场
                 try
                    tmp=calG(next_E,phi_idg,theta_idg);%计算本层累加电场的目标函数值
                 catch
                     tmp=calG(next_E,phi_idg,theta_idg);
                 end
                 if tmp>=m%如果上一层在x配置下，目标函数更加优秀，那么上一层选择x配置
                     m=tmp;%更新目标函数值
                     x2=x;%记录上一层应采取的配置
                     tmpE=next_E;%记录本层的最优累加电场
                     
                     Prev(j,i+1)=x2;%本层j配置下的，前一层的最优配置是x2.注意：本层是第i+1层
                     sum_E(:,:,i+1,j)=tmpE;%刷新本层的最优累加电场
                     if x==5%记录波束关闭的个数
                         N_z=N_z+1;
                     end
                 end
             end
         end
     end

     %对最后一个单元天线的处理
     m=-999;x2=1;
     for x=1:5
         tmpE=sum_E(:,:,32,x);
         tmp=calG(tmpE,phi_idg,theta_idg);
         if tmp>m
             m=tmp;
             x2=x;
             final_E=tmpE;
             if x==5%记录波束关闭的个数
                N_z=N_z+1;
             end
         end
     end
     Gmax=m;

     %% %回溯求最优解
     z(32)=x2;
     for i=31:-1:1
         z(i)=Prev(z(i+1),i+1);
     end
 
     %% %求最优解的覆盖区域
     sum_E=0;
    for i=1:32
        if z(i)==1
            continue
        end
        sum_E=sum_E+raw_E(:,:,i,z(i));
    end

    E_mod=abs(sum_E);
    cover=double(E_mod>=th_E);
end


function G = calG(E,pai_idg,theta_idg)
%计算目标函数值
%   E:电场
%   phi_goal:目标点水平角
%   theta_goal:目标点俯仰角
%   AZ:水平测量角
%   EL:俯仰测量角
    c1=10;%功率目标
    c2=5;%旁瓣电压目标
    c3=0;%禁止干扰
    
    pattern=[1 1 1;1 2 1;1 1 1];
    %功率目标 20log(Em)
    E_mod=abs(E);
%     Em=sum(sum(100-abs(35-E_mod(pai_idg-1:pai_idg+1,theta_idg-1:theta_idg+1).*pattern)));
    
    %旁瓣电压目标
%     E_mod2=E_mod;%删除主瓣区域
%     E_mod2(pai_idg-1:pai_idg+1,theta_idg-1:theta_idg+1)=0;

%     if isempty(E_mod2)
%         Esm=0;
%     else
%         Esm=max(max(E_mod2));
%     end


%旁瓣电压目标
%     E_mod2=E_mod(pai_idg-2:pai_idg+2,theta_idg-2:theta_idg+2);%删除主瓣区域
% 
%     if isempty(E_mod2)
%         Esm=0;
%     else
%         Esm=max(max(E_mod2))-min(min(E_mod2));
%         Esm=100*Esm;
%     end
    
    %防止干扰AZ=10,EL=10的站点，其索引为39,21
%     forbid=E_mod(39,21);
    
    %优化函数值
%     G=c1*Em-c2*Esm;%c1:10 c2:2 c3:10 效果2.11倍，功率可达35.56
    G=E_mod(pai_idg,theta_idg);
end


function G2 = calG2(E,phi_idg,theta_idg,th_E)
%计算目标函数值：让(phi_g,theta_g)处居于有效电场中心，并且覆盖面积越大越好
%   E:电场
%   phi_g:目标点的水平角索引值
%   theta_g：目标点的俯仰角索引值
%   th_E:电场截止幅值的阈值，低于这个阈值直接归0，大于这个阈值为1，可用来计算覆盖面积
    E_mod=abs(E);
    I=E_mod>th_E;
    disp(max(max(E_mod)));
    if max(max(I))>0
        a=0;
    end
    [rows,cols] = size(I); 
    x = ones(rows,1)*[1:cols];
    y = [1:rows]'*ones(1,cols); 
    area = sum(sum(I)); %区域面积
    meanx = sum(sum(I.*x))/area; %(meanx,meany)为区域重心
    meany = sum(sum(I.*y))/area;
    
%     imshow(I);
%     hold on;
%     plot(meanx,meany,'r+'); %十字标出重心位置
    
    d=sqrt((meanx-phi_idg)^2+(meany-theta_idg)^2);%目标点与区域重心的距离
    c1=10;%方向目标
    c2=2;%覆盖面积目标
    G2=c1*d+c2*area;
end

