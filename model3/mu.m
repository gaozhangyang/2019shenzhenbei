function re = mu(n,th1,th2)
%MU 此处显示有关此函数的摘要
%   此处显示详细说明
    if n<th1
        re=n/th1;
    elseif n<=th2
        re=1;
    elseif n<=80
        re=(80-n)/(80-th2);
    else
        re=0;
    end
end

