function [value,way] = fU(i,j,gneed,distMat)
%U �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    if gneed(i)<=32 && distMat(i,j)<=200+10
        value=1;
        way=1;
    elseif  gneed(i)<=48 && distMat(i,j)<=100+10
        value=0.75;
        way=2;
    elseif gneed(i)<=64 && distMat(i,j)<=80+10
        value=0.5;
        way=3;
    else
        value=0;
        way=0;
    end
end

