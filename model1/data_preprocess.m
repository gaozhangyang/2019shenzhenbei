%% %��ģ�����ڴ���������
load('raw_data.mat')
%AZ 73*37 ˮƽ�ǲ����㣬��Χ[-180,180]������5��
AZ=raw_data.AZ;
%EL 73*37 �����ǲ����㣬��Χ[-90,90]������5��
EL=raw_data.EL;
%LogMag 73*37*32*4 �����Ĺ��ʣ���λdBm 32�����ߵ�Ԫ��[0,90,180,270]������������ʱ
LogMag=raw_data.LogMag;
%Phase 73*37*32*4 ��õ���λ����λ��32�����ߵ�Ԫ��[0,90,180,270]������������ʱ
Phase=raw_data.Phase;

%data preprocessing
% employ your mathod

%LogMag_cleaned��Phase_cleaned�Ǵ�����֮�������
%���ֱ��������䣬д����Ĵ�������滻����������
LogMag_cleaned=LogMag;
Phase_cleaned=Phase;

%���洦����������������
save('data_preprocessed.mat','AZ','EL','LogMag_cleaned','Phase_cleaned')