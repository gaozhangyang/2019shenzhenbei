function re = phai(u,th1,th2)
%PHAI �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    if u<th1
        re=0.8*u/th1;
    elseif u<=th2
        re=0.8+0.2*(u-th1)/(th2-th1);
    else
        re=1;
    end
end

