function G = calG(E,phi_g,theta_g,AZ,EL,C)
%����Ŀ�꺯��ֵ
%   E:�糡
%   phi_goal:Ŀ���ˮƽ��
%   theta_goal:Ŀ��㸩����
%   AZ:ˮƽ������
%   EL:����������

%     c1=11;%����Ŀ��
%     c2=2%�԰��ѹĿ��
%     c3=10;%��ֹ����
    
    c1=C(1);
    c2=C(2);
    c3=C(3);
    %����Ŀ�� 20log(Em)
    E_mod=abs(E);
    Em=E_mod(39,20);
    
    %�԰��ѹĿ��
    E_mod2=E_mod;
    E_mod2(E_mod>sqrt(Em))=0;%ɾ����������
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
%             mi=i;%�������ı�ǩ(����ı�ǩ)
%         end
%     end
%     
%     L(find(L==mi))=0;%ɾ������
%     L=L>0;%�԰�����
%     Esm=10*mean(mean(E_mod2(L)));%�԰�ƽ������
%     if isnan(Esm)
%         Esm=0;
%     end


    %��ֹ����AZ=10,EL=10��վ�㣬������Ϊ39,21
    forbid=E_mod(39,21);
    
    %�Ż�����ֵ
    G=c1*Em-c2*Esm-c3*forbid;%c1:10 c2:2 c3:10 Ч��2.11�������ʿɴ�35.56
    %G=c1*(Em>10^1.75)*(1000-c2*Esm-c3*forbid);
    %disp("G: ")
    %disp(G)
end

