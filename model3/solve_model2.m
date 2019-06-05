%%

index=[0:99]';
N=zeros(100,1);
for n=0:1:99
    N(n+1)=mu(n,15,60);
end
csvwrite('mu.csv',[index,N]);

index=[500:500:20000]';
U=zeros(40,1);
for u=1:40
    U(u)=phai(u*500,3500,10000);
end
csvwrite('phai.csv',[index,U]);


