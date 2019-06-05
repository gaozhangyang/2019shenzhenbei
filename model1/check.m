function E_P = check(z)
%CHECK �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    %% %check���
    clear all
    load('data_preprocessed.mat')
    load('result_model1.mat')
    Phase_cleaned=deg2rad(Phase_cleaned);

    raw_E=zeros(73,37,32,5);%�糡�ĸ�����ʾ
    for i=1:32
        for j=1:4
            raw_E(:,:,i,j+1)=10.^(LogMag_cleaned(:,:,i,j)/20).*exp(1i.*Phase_cleaned(:,:,i,j));
        end
    end
    raw_E(isnan(raw_E))=0;
    raw_E(raw_E==-inf)=0;

    sum_E=zeros(73,37);
    for i=1:32
        if z(i)==1
            continue
        end
        sum_E=sum_E+raw_E(:,:,i,z(i));
    end

    E_mod=abs(sum_E);
    E_P=20*log10(E_mod);
end

