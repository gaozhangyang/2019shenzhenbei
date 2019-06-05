function re = dad(i,colink)
%DAD 此处显示有关此函数的摘要
%   此处显示详细说明
    re=[];
    while i~=1
        for j=1:20
            if colink(i,j)>0
                dad=[dad,j];
                i=j;
                break
            end
        end
    end
end

