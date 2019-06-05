load('distmat.mat')

name=["广州市","东莞市","惠州市","佛山市","清远市","江门市","中山市","肇庆市","云浮市","河源市","梅州市","韶关市","汕尾市","揭阳市","潮州市","汕头市","阳江市","茂名市","珠海市","深圳市"]';
data=[34.8208	0.941708641%"广州市"1
21.28822	0.317863954%"东莞市"2
12.26495	0.139214632%"惠州市"3
19.16432	0.388772067%"佛山市"4
9.889592	0.030632305%"清远市"5
11.65628	0.087759793%"江门市"6
8.277907	0.119096288%"中山市"7
10.47015	0.057870801%"肇庆市"8
6.345896	0           %"云浮市"9
7.926889	0.006709375%"河源市"10
11.19539	0.01116925%"梅州市"11
7.350457	0.021164849%"韶关市"12
7.793032	0.003041714%"汕尾市"13
15.62656	0.055758228%"揭阳市"14
6.810134	0.00933053%"潮州市"15
14.31946	0.071142843%"汕头市"16
6.476655	0.021438701%"阳江市"17
15.68304	0.095965573%"茂名市"18
4.21452	0.088366179%"珠海市"19
29.34689	1];%"深圳市"20

data=data*1.8;

dis=distMat;
capa=zeros(20,1);%各节点连入方式的最大负载能力
gneed=data(:,1);%各节点的总和需求，包括子节点的需求
covalue=data(:,2);%节点连入价值
conode=[];%已经连入网络的节点
colink=zeros(20,20);%连接矩阵，每一个元素存储边上的连接方式
q=zeros(20,3);%节点优先级
q_conf=[200    32;
        100    48;
        80     64];
depth=zeros(20,1);
beta=10;%松弛

%节点优先级
c4=2;c5=1;
for i=2:20
    U=[1,0.75,0.5]*c4;
    V=[2*(1-abs(32-gneed(i))/32), 2*(1-abs(48-gneed(i))/48), 2*(1-abs(64-gneed(i))/64)];
    g=U+V;
    [tmp,index]=sort(g);
    q(i,:)=index(end:-1:1);
end

% 连接到sink
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
        
        
% 连接到父节点,不改变原网络结构
for i=2:20
    flag=0;%1:处理i+1个节点
    left_capa=capa-gneed;
    if ismember(i,conode)
        continue;
    end
    
    for j=2:20%第一优先级
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
    
    if flag==1%如果节点i连入网络，处理节点i+1
        continue;
    end
    
    for j=2:20%第二优先级
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
    
    if flag==1%如果节点i连入网络，处理节点i+1
        continue;
    end
    
    for j=2:20%第三优先级
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