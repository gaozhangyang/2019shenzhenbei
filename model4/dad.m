function re = dad(i,colink)
%DAD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

