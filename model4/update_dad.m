function re = update_dad(i,dad,gneed,capa)
%UPDATE_DAD 此处显示有关此函数的摘要
%   此处显示详细说明
    gneed2=gneed;
    dad=[i,dad];
    for i=2:length(dad)
        gneed2(dad(i))=gneed(dad(i))+gneed(dad(i-1));
    end
    
    re=gneed2;
end

