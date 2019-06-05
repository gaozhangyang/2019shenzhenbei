load('distmat.mat')

name=["������","��ݸ��","������","��ɽ��","��Զ��","������","��ɽ��","������","�Ƹ���","��Դ��","÷����","�ع���","��β��","������","������","��ͷ��","������","ï����","�麣��","������"]';
data=[34.8208	0.941708641%"������"1
21.28822	0.317863954%"��ݸ��"2
12.26495	0.139214632%"������"3
19.16432	0.388772067%"��ɽ��"4
9.889592	0.030632305%"��Զ��"5
11.65628	0.087759793%"������"6
8.277907	0.119096288%"��ɽ��"7
10.47015	0.057870801%"������"8
6.345896	0           %"�Ƹ���"9
7.926889	0.006709375%"��Դ��"10
11.19539	0.01116925%"÷����"11
7.350457	0.021164849%"�ع���"12
7.793032	0.003041714%"��β��"13
15.62656	0.055758228%"������"14
6.810134	0.00933053%"������"15
14.31946	0.071142843%"��ͷ��"16
6.476655	0.021438701%"������"17
15.68304	0.095965573%"ï����"18
4.21452	0.088366179%"�麣��"19
29.34689	1];%"������"20

data=data*1.8;

dis=distMat;
capa=zeros(20,1);%���ڵ����뷽ʽ�����������
gneed=data(:,1);%���ڵ���ܺ����󣬰����ӽڵ������
covalue=data(:,2);%�ڵ������ֵ
conode=[];%�Ѿ���������Ľڵ�
colink=zeros(20,20);%���Ӿ���ÿһ��Ԫ�ش洢���ϵ����ӷ�ʽ
q=zeros(20,3);%�ڵ����ȼ�
q_conf=[200    32;
        100    48;
        80     64];
depth=zeros(20,1);
beta=10;%�ɳ�

%�ڵ����ȼ�
c4=2;c5=1;
for i=2:20
    U=[1,0.75,0.5]*c4;
    V=[2*(1-abs(32-gneed(i))/32), 2*(1-abs(48-gneed(i))/48), 2*(1-abs(64-gneed(i))/64)];
    g=U+V;
    [tmp,index]=sort(g);
    q(i,:)=index(end:-1:1);
end

% ���ӵ�sink
for i=2:20
    [value,way]=fU(i,1,gneed,dis);
    if value>0
        capa(i)=way*16+16;
        conode=[conode,i];
        colink(i,1)=way;
        %colink(1,i)=way;
        depth(i)=1;
    end
end
        
        
% ���ӵ����ڵ�,���ı�ԭ����ṹ
for i=2:20
    flag=0;%1:����i+1���ڵ�
    left_capa=capa-gneed;
    if ismember(i,conode)
        continue;
    end
    
    for j=2:20%��һ���ȼ�
        if j==i
            continue;
        end
        if dis(i,j)<=q_conf(q(i,1),1)+beta && gneed(i)<=left_capa(j) &&depth(j)<2
            gneed(j)=gneed(j)+gneed(i);
            capa(i)=q_conf(q(i,1),2);
            conode=[conode,i];
            colink(i,j)=q(i,1);
            %colink(j,i)=1;
            flag=1;
            depth(i)=2;
            break
        end
    end
    
    if flag==1%����ڵ�i�������磬����ڵ�i+1
        continue;
    end
    
    for j=2:20%�ڶ����ȼ�
        if j==i
            continue;
        end
        if dis(i,j)<=q_conf(q(i,2),1)+beta && gneed(i)<=left_capa(j)&&depth(j)<2
            gneed(j)=gneed(j)+gneed(i);
            capa(i)=q_conf(q(i,2),2);
            conode=[conode,i];
            colink(i,j)=q(i,2);
            %colink(j,i)=1;
            flag=1;
            depth(i)=2;
            break
        end
    end
    
    if flag==1%����ڵ�i�������磬����ڵ�i+1
        continue;
    end
    
    for j=2:20%�������ȼ�
        if j==i
            continue;
        end
        if dis(i,j)<=q_conf(q(i,3),1)+beta && gneed(i)<=left_capa(j)&&depth(j)<2
            gneed(j)=gneed(j)+gneed(i);
            capa(i)=q_conf(q(i,3),2);
            conode=[conode,i];
            colink(i,j)=q(i,3);
            %colink(j,i)=1;
            flag=1;
            depth(i)=2;
            break
        end
    end
end

left=capa-gneed;
save('colink.mat','colink')