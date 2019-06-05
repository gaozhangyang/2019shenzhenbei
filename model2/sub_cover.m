function [cover,E_mod,z] = sub_cover(phi_idg,theta_idg,LogMag_cleaned,Phase_cleaned,AZ,EL)
%SUB_COVER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    %%  %��ʼ��
    th_E=36;%�糡��ֹ��ֵ
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
    
    %% %ǰ�����
     N_z=0;
     for i=1:31
         for j=1:5
             m=-999;x2=1;%̽����һ�������������֮ǰ����Ŀ�꺯��ֵm��ʼ��Ϊ����С,����x2��ʼ��Ϊ1
             for x=1:5%Ѱ����õ�x,������x2
                 last_E=sum_E(:,:,i,x);%�ۼӵ���һ�㣬x�����µ��ܵ糡
                 next_E=last_E+raw_E(:,:,i+1,j);%�ۼӵ�������ܵ糡
                 try
                    tmp=calG(next_E,phi_idg,theta_idg);%���㱾���ۼӵ糡��Ŀ�꺯��ֵ
                 catch
                     tmp=calG(next_E,phi_idg,theta_idg);
                 end
                 if tmp>=m%�����һ����x�����£�Ŀ�꺯���������㣬��ô��һ��ѡ��x����
                     m=tmp;%����Ŀ�꺯��ֵ
                     x2=x;%��¼��һ��Ӧ��ȡ������
                     tmpE=next_E;%��¼����������ۼӵ糡
                     
                     Prev(j,i+1)=x2;%����j�����µģ�ǰһ�������������x2.ע�⣺�����ǵ�i+1��
                     sum_E(:,:,i+1,j)=tmpE;%ˢ�±���������ۼӵ糡
                     if x==5%��¼�����رյĸ���
                         N_z=N_z+1;
                     end
                 end
             end
         end
     end

     %�����һ����Ԫ���ߵĴ���
     m=-999;x2=1;
     for x=1:5
         tmpE=sum_E(:,:,32,x);
         tmp=calG(tmpE,phi_idg,theta_idg);
         if tmp>m
             m=tmp;
             x2=x;
             final_E=tmpE;
             if x==5%��¼�����رյĸ���
                N_z=N_z+1;
             end
         end
     end
     Gmax=m;

     %% %���������Ž�
     z(32)=x2;
     for i=31:-1:1
         z(i)=Prev(z(i+1),i+1);
     end
 
     %% %�����Ž�ĸ�������
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
%����Ŀ�꺯��ֵ
%   E:�糡
%   phi_goal:Ŀ���ˮƽ��
%   theta_goal:Ŀ��㸩����
%   AZ:ˮƽ������
%   EL:����������
    c1=10;%����Ŀ��
    c2=5;%�԰��ѹĿ��
    c3=0;%��ֹ����
    
    pattern=[1 1 1;1 2 1;1 1 1];
    %����Ŀ�� 20log(Em)
    E_mod=abs(E);
%     Em=sum(sum(100-abs(35-E_mod(pai_idg-1:pai_idg+1,theta_idg-1:theta_idg+1).*pattern)));
    
    %�԰��ѹĿ��
%     E_mod2=E_mod;%ɾ����������
%     E_mod2(pai_idg-1:pai_idg+1,theta_idg-1:theta_idg+1)=0;

%     if isempty(E_mod2)
%         Esm=0;
%     else
%         Esm=max(max(E_mod2));
%     end


%�԰��ѹĿ��
%     E_mod2=E_mod(pai_idg-2:pai_idg+2,theta_idg-2:theta_idg+2);%ɾ����������
% 
%     if isempty(E_mod2)
%         Esm=0;
%     else
%         Esm=max(max(E_mod2))-min(min(E_mod2));
%         Esm=100*Esm;
%     end
    
    %��ֹ����AZ=10,EL=10��վ�㣬������Ϊ39,21
%     forbid=E_mod(39,21);
    
    %�Ż�����ֵ
%     G=c1*Em-c2*Esm;%c1:10 c2:2 c3:10 Ч��2.11�������ʿɴ�35.56
    G=E_mod(pai_idg,theta_idg);
end


function G2 = calG2(E,phi_idg,theta_idg,th_E)
%����Ŀ�꺯��ֵ����(phi_g,theta_g)��������Ч�糡���ģ����Ҹ������Խ��Խ��
%   E:�糡
%   phi_g:Ŀ����ˮƽ������ֵ
%   theta_g��Ŀ���ĸ���������ֵ
%   th_E:�糡��ֹ��ֵ����ֵ�����������ֱֵ�ӹ�0�����������ֵΪ1�����������㸲�����
    E_mod=abs(E);
    I=E_mod>th_E;
    disp(max(max(E_mod)));
    if max(max(I))>0
        a=0;
    end
    [rows,cols] = size(I); 
    x = ones(rows,1)*[1:cols];
    y = [1:rows]'*ones(1,cols); 
    area = sum(sum(I)); %�������
    meanx = sum(sum(I.*x))/area; %(meanx,meany)Ϊ��������
    meany = sum(sum(I.*y))/area;
    
%     imshow(I);
%     hold on;
%     plot(meanx,meany,'r+'); %ʮ�ֱ������λ��
    
    d=sqrt((meanx-phi_idg)^2+(meany-theta_idg)^2);%Ŀ������������ĵľ���
    c1=10;%����Ŀ��
    c2=2;%�������Ŀ��
    G2=c1*d+c2*area;
end

