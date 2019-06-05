num=1;sum=0;
for n=60:99
    y1=mu(n,15,60);
    for u=20:0.1:40
        y2=phai(u*500,3500,10000);
        sum=sum+y1*y2;
        num=num+1;
    end
end
sum/num