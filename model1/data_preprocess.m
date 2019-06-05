%% %本模块用于处理测量误差
load('raw_data.mat')
%AZ 73*37 水平角测量点，范围[-180,180]，步进5度
AZ=raw_data.AZ;
%EL 73*37 俯仰角测量点，范围[-90,90]，步进5度
EL=raw_data.EL;
%LogMag 73*37*32*4 测量的功率，单位dBm 32个天线单元在[0,90,180,270]度移相器配置时
LogMag=raw_data.LogMag;
%Phase 73*37*32*4 测得的相位，单位°32个天线单元在[0,90,180,270]度移相器配置时
Phase=raw_data.Phase;

%data preprocessing
% employ your mathod

%LogMag_cleaned与Phase_cleaned是处理完之后的数据
%保持变量名不变，写好你的处理程序，替换接下来两行
LogMag_cleaned=LogMag;
Phase_cleaned=Phase;

%保存处理完测量误差后的数据
save('data_preprocessed.mat','AZ','EL','LogMag_cleaned','Phase_cleaned')