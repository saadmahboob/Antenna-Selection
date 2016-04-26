%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        K-user IA simulation       %
%           Xinyu Zhang             %
%            March 2014             %
%  Dalian University of Technology  %
%             ver 1.0               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

Mr = 2;    %����������
Mt = 3;    %����������
M = Mt-1;  %ѡ��������
Q = 20;    %������
rho = 0.5; %���²���
lambda = 0.8; %���²���
delta = 1; %���
d = 1;     %������
K = 3;     %�û���
loop =  10; %ѭ������
iter_leakmin = 100; %��������

SNR = [0:5:50]; %���书�ʷ�Χ

tic
for k = 1:loop     %%ѭ��loop��ȡƽ��
    
    H = sqrt(1/2).*((normrnd(0,1,[Mr,Mt,K,K])+sqrt(-1).*normrnd(0,1,[Mr,Mt,K,K])));  %%��������ͬ�ֲ���ѭ���ԳƸ���˹�ֲ����������
    U = normalize(randn(Mr,d,K)); % ��ʼ���������ƾ���
    V = normalize(randn(M,d,K)); % ��ʼ���������ξ���
    
    for snr = 1:length(SNR)
        xigma = 10^(SNR(snr)/10)/(1*d);
        % Without Antenna Selection
        [V,U] = maxSINR_K_user(H(:,1:M,:,:), V, xigma, iter_leakmin); %��������U��V
        R_without_AS(snr,k) = rate_K_user(U, H(:,1:M,:,:), V, xigma);%���������ʣ�bits/s/Hz)
        
        % Cross-Entropy Optimization Search with max-SINR Algorithm
        delta = 1;
        p_old = M/Mt.*ones(1, K*Mt);
        while delta > 10^(-2)
            p_new = zeros(1, K*Mt);
            [samples_Mt, samples_M] = generate_bernoulli_samples(M, Mt, p_old, Q);
            H_AS = zeros(Mr,M,K,K);
            min_SINR = zeros(1,Q);
            for i =  1:Q
                for j = 1:K
                    tmp = samples_M(i,1+(j-1)*M:j*M);
                    H_AS(:,:,:,j) = H(:,tmp,:,j);
                end
                [V,U] = maxSINR_K_user(H_AS, V, xigma, iter_leakmin); %��������U��V
                min_SINR(i) = abs(min_stream_SINR(U, H_AS, V, xigma));
            end
            min_SINR_descend = sort(min_SINR,'descend');
            gamma = min_SINR_descend(ceil(Q*(1-rho)));
            num = 0;
            for i = 1:Q
                if min_SINR(i) > gamma
                    num = num + 1;
                    p_new = p_new + samples_Mt(i,:);
                end
            end
            p_new = p_new./num * lambda + (1-lambda) * p_old;
            delta = norm(p_new - p_old);
            p_old = p_new;
        end
        p_new
        for j = 1:K
            %             tmp = find(p_new(1+(j-1)*Mt:j*Mt) > min(p_new(1+(j-1)*Mt:j*Mt)));
            [~, ind] = sort(p_new(1+(j-1)*Mt:j*Mt), 'descend');
            H_AS(:,:,:,j) = H(:,ind(1:M),:,j);
        end
        [V,U] = maxSINR_K_user(H_AS, V, xigma, iter_leakmin);
        R_CEO(snr,k) = rate_K_user(U, H_AS, V, xigma);
        % Cross-Entropy Optimization Search with max-SINR Algorithm
    end
    k
end
display(['Total Time :']);
toc
R_1 = mean(R_without_AS,2);
R_2 = mean(R_CEO,2);
handles=plot(SNR,R_1,'b-o',SNR,R_2,'r-o');
set(handles,'LineWidth',1.5);
legend(handles,'�ֲ�ʽ���Ŷ���');
grid on;
xlabel('SNR(dB)');ylabel('sum rate(bits/s/hz)');
