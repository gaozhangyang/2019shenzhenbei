function G = calG(E,phi_g,theta_g,AZ,EL,C)
%计算目标函数值
%   E:电场
%   phi_goal:目标点水平角
%   theta_goal:目标点俯仰角
%   AZ:水平测量角
%   EL:俯仰测量角

%     c1=11;%功率目标
%     c2=2%旁瓣电压目标
%     c3=10;%禁止干扰
    
    c1=C(1);
    c2=C(2);
    c3=C(3);
    %功率目标 20log(Em)
    E_mod=abs(E);
    Em=E_mod(39,20);
    
    %旁瓣电压目标
    E_mod2=E_mod;
    E_mod2(E_mod>sqrt(Em))=0;%删除主瓣区域
    if isempty(E_mod2)
        Esm=0;
    else
        Esm=10*mean(mean(E_mod2));
    end
    
%     E_mod2=E_mod;
%     [L,num] = bwlabel(E_mod2>1,8);
%     m_erea=0;mi=0;
%     for i=1:num
%         erea=length(find(L==i));
%         if erea>m_erea
%             m_erea=erea;
%             mi=i;%最大面积的标签(主瓣的标签)
%         end
%     end
%     
%     L(find(L==mi))=0;%删除主瓣
%     L=L>0;%旁瓣索引
%     Esm=10*mean(mean(E_mod2(L)));%旁瓣平均功率
%     if isnan(Esm)
%         Esm=0;
%     end


    %防止干扰AZ=10,EL=10的站点，其索引为39,21
    forbid=E_mod(39,21);
    
    %优化函数值
    G=c1*Em-c2*Esm-c3*forbid;%c1:10 c2:2 c3:10 效果2.11倍，功率可达35.56
    %G=c1*(Em>10^1.75)*(1000-c2*Esm-c3*forbid);
    %disp("G: ")
    %disp(G)
end

