function [z] = solve(C,phi_g,theta_g,raw_E,sum_E,Prev,AZ,EL)
%SOLVE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    %% %ǰ�����
     for i=1:31
         for j=1:5
             m=-999;x2=1;%̽����һ�������������֮ǰ����Ŀ�꺯��ֵm��ʼ��Ϊ����С,����x2��ʼ��Ϊ1
             for x=1:5%Ѱ����õ�x,������x2
                 last_E=sum_E(:,:,i,x);%�ۼӵ���һ�㣬x�����µ��ܵ糡
                 next_E=last_E+raw_E(:,:,i+1,j);%�ۼӵ�������ܵ糡
                 tmp=calG(next_E,phi_g,theta_g,AZ,EL,C);%���㱾���ۼӵ糡��Ŀ�꺯��ֵ
                 if tmp>m%�����һ����x�����£�Ŀ�꺯���������㣬��ô��һ��ѡ��x����
                     m=tmp;%����Ŀ�꺯��ֵ
                     x2=x;%��¼��һ��Ӧ��ȡ������
                     tmpE=next_E;%��¼����������ۼӵ糡
                 end
             end
             sum_E(:,:,i+1,j)=tmpE;%ˢ�±���������ۼӵ糡
             Prev(j,i+1)=x2;%����j�����µģ�ǰһ�������������x2.ע�⣺�����ǵ�i+1��
         end
     end

     %�����һ����Ԫ���ߵĴ���
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

     %% %���������Ž�
     z(32)=x2;
     for i=31:-1:1
         z(i)=Prev(z(i+1),i+1);
     end
    disp(z)
    save('result_model1.mat','z')
end

