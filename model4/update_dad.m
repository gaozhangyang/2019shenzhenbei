function re = update_dad(i,dad,gneed,capa)
%UPDATE_DAD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    gneed2=gneed;
    dad=[i,dad];
    for i=2:length(dad)
        gneed2(dad(i))=gneed(dad(i))+gneed(dad(i-1));
    end
    
    re=gneed2;
end

