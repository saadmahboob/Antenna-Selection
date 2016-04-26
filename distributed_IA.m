%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        K-user IA simulation       %
%           Xinyu Zhang             %
%            March 2014             %
%  Dalian University of Technology  %
%             ver 1.0               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
% close all

Mr = 2;    %����������
Mt = 2;    %����������
d = 1;    %������
K = 3;    %�û���
loop =  10; %ѭ������
iter_leakmin = 50; %��������

SNR = [0:5:100]; %���书�ʷ�Χ
tic
 
for k = 1:loop     %%ѭ��loop��ȡƽ��
    
    H = sqrt(1/2).*((normrnd(0,1,[Mr,Mt,K,K])+sqrt(-1).*normrnd(0,1,[Mr,Mt,K,K])));  %%��������ͬ�ֲ���ѭ���ԳƸ���˹�ֲ����������
    U = normalize(randn(Mr,d,K)); % ��ʼ���������ƾ���
    V = normalize(randn(Mt,d,K)); % ��ʼ���������ξ���
    for snr = 1:length(SNR)
        
    xigma = 10^(SNR(snr)/10)/(1*d);  
    [V,U] = maxSINR_K_user(H, V, xigma, iter_leakmin); %��������U��V
    R(snr,k) = rate_K_user(U, H, V, xigma);%���������ʣ�bits/s/Hz)
    end
  k
end
display(['Total Time :']);
toc
R_1 = mean(R,2);
handles=plot(SNR,R_1,'b-o');
set(handles,'LineWidth',1.5);
legend(handles,'�ֲ�ʽ���Ŷ���');
grid on;
xlabel('SNR(dB)');ylabel('sum rate(bits/s/hz)');
