function re = fV(i,mi,need,value,addvalue)
    c=[32 48 64];
    tmp=c(mi);
    if addvalue==0
        re=1-abs(tmp-need(i))/tmp;
    else
        re=1-abs(tmp-need(i))/tmp+value(i);
    end
end

