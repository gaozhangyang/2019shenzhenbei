%运算使用弧度制
%问题：数据中存在NaN于inf
%% %数据初始化
run init.m

C=[1.1 1 1];
 
 %% %变参数求解
 target1=[]; forbid1=[];  pangban1=[];t_f1=[];
for ch=0.4:0.1:3
    C=[1.1 1 1];
    sum_E=zeros(73,37,32,5);
    Prev=zeros(5,32);
    C(1)=ch;
     
    z = solve(C,phi_g,theta_g,raw_E,sum_E,Prev,AZ,EL);

    E_P = check(z);
    E_P2=E_P(E_P<35/2);
    % max(max(E_P2))
    target1=[target1,E_P(39,20)];
    forbid1=[forbid1,E_P(39,21)];
    t_f1=[ t_f1,E_P(39,20)/E_P(39,21)];
    pangban1=[pangban1,mean(mean(E_P2))];
    sprintf('target:%f',E_P(39,20))
    sprintf('forbid:%f',E_P(39,21))
    sprintf('target/forbid:%f',E_P(39,20)/E_P(39,21))
    sprintf('pangban:%f',mean(mean(E_P2)))
end

 target2=[]; forbid2=[];  pangban2=[];t_f2=[];
for ch=0.4:0.1:3
    C=[1.1 1 1];
    sum_E=zeros(73,37,32,5);
    Prev=zeros(5,32);
    C(2)=ch;
     
    z = solve(C,phi_g,theta_g,raw_E,sum_E,Prev,AZ,EL);

    E_P = check(z);
    E_P2=E_P(E_P<35/2);
    % max(max(E_P2))
    target2=[target2,E_P(39,20)];
    forbid2=[forbid2,E_P(39,21)];
    t_f2=[ t_f2,E_P(39,20)/E_P(39,21)];
    pangban2=[pangban2,mean(mean(E_P2))];
    sprintf('target:%f',E_P(39,20))
    sprintf('forbid:%f',E_P(39,21))
    sprintf('target/forbid:%f',E_P(39,20)/E_P(39,21))
    sprintf('pangban:%f',mean(mean(E_P2)))
end


 target3=[]; forbid3=[];  pangban3=[];t_f3=[];
for ch=0.4:0.1:3
    C=[1.1 1 1];
    sum_E=zeros(73,37,32,5);
    Prev=zeros(5,32);
    C(3)=ch;
     
    z = solve(C,phi_g,theta_g,raw_E,sum_E,Prev,AZ,EL);

    E_P = check(z);
    E_P2=E_P(E_P<35/2);
    % max(max(E_P2))
    target3=[target3,E_P(39,20)];
    forbid3=[forbid3,E_P(39,21)];
    t_f3=[ t_f3,E_P(39,20)/E_P(39,21)];
    pangban3=[pangban3,mean(mean(E_P2))];
    sprintf('target:%f',E_P(39,20))
    sprintf('forbid:%f',E_P(39,21))
    sprintf('target/forbid:%f',E_P(39,20)/E_P(39,21))
    sprintf('pangban:%f',mean(mean(E_P2)))
end
x=[0.4:0.1:3];
target=[x',target1',target2',target3'];
forbid=[x',forbid1',forbid2',forbid3'];
pangban=[x',pangban1',pangban2',pangban3'];
t_f=[x',t_f1',t_f2',t_f3'];
csvwrite('target.csv',target);
csvwrite('forbid.csv',forbid);
csvwrite('pangban.csv',pangban);
csvwrite('t_f.csv',t_f);

%% %一次求解
C=[1.1,1,1];
z = solve(C,phi_g,theta_g,raw_E,sum_E,Prev,AZ,EL);

E_P = check(z);
E_P2=E_P(E_P<35/2);
% max(max(E_P2))
sprintf('target:%f',E_P(39,20))
sprintf('forbid:%f',E_P(39,21))
sprintf('target/forbid:%f',E_P(39,20)/E_P(39,21))
sprintf('pangban:%f',mean(mean(E_P2)))
    

%% %保存为csv
Point=zeros(73*37,3);
for i=1:73*37
    Point(i,1)=rad2deg(AZ(i));
    Point(i,2)=rad2deg(EL(i));
    Point(i,3)=E_P(i);
end
file=sprintf('model1_功率分布_Ex%d.csv',0);
csvwrite(file,[Point]);
