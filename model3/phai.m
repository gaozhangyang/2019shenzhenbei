function re = phai(u,th1,th2)
%PHAI 此处显示有关此函数的摘要
%   此处显示详细说明
    if u<th1
        re=0.8*u/th1;
    elseif u<=th2
        re=0.8+0.2*(u-th1)/(th2-th1);
    else
        re=1;
    end
end

