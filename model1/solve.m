function [z] = solve(C,phi_g,theta_g,raw_E,sum_E,Prev,AZ,EL)
%SOLVE 此处显示有关此函数的摘要
%   此处显示详细说明
    %% %前向递推
     for i=1:31
         for j=1:5
             m=-999;x2=1;%探索上一层采用哪种配置之前，将目标函数值m初始化为无穷小,配置x2初始化为1
             for x=1:5%寻找最好的x,保存至x2
                 last_E=sum_E(:,:,i,x);%累加到上一层，x配置下的总电场
                 next_E=last_E+raw_E(:,:,i+1,j);%累加到本层的总电场
                 tmp=calG(next_E,phi_g,theta_g,AZ,EL,C);%计算本层累加电场的目标函数值
                 if tmp>m%如果上一层在x配置下，目标函数更加优秀，那么上一层选择x配置
                     m=tmp;%更新目标函数值
                     x2=x;%记录上一层应采取的配置
                     tmpE=next_E;%记录本层的最优累加电场
                 end
             end
             sum_E(:,:,i+1,j)=tmpE;%刷新本层的最优累加电场
             Prev(j,i+1)=x2;%本层j配置下的，前一层的最优配置是x2.注意：本层是第i+1层
         end
     end

     %对最后一个单元天线的处理
     m=-999;x2=1;
     for x=1:5
         tmpE=sum_E(:,:,32,x);
         tmp=calG(tmpE,phi_g,theta_g,AZ,EL,C);
         if tmp>m
             m=tmp;
             x2=x;
             final_E=tmpE;
         end
     end
     Gmax=m;

     %% %回溯求最优解
     z(32)=x2;
     for i=31:-1:1
         z(i)=Prev(z(i+1),i+1);
     end
    disp(z)
    save('result_model1.mat','z')
end

