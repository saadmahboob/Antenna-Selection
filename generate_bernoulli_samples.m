function [samples_Mt,samples_M] = generate_bernoulli_samples(M,Mt,p,Q)
% ���� M, Mt, p, Q
% M  ÿ���û�ѡȡ������
% Mt ÿ���û��ɹ�ѡ��������
% p  ���ʾ���
% Q  ������
% ��� ���� sample

len = size(p,2);
K = len/Mt; % �û���
samples_Mt = zeros(Q,len);
samples_M = zeros(Q,M*K);
trial = ones(1,len);
for i = 1:Q
    for j = 1:K
        tmp = binornd(trial(1+(j-1)*Mt:j*Mt),p(1+(j-1)*Mt:j*Mt));
        if sum(tmp) == M     % ǡ����������
            samples_Mt(i,1+(j-1)*Mt:j*Mt) = tmp;
        elseif sum(tmp) > M  % ��Ҫ���ɾ��1
            ind = sort(randperm(sum(tmp),sum(tmp)-M));
            num = 0;
            for k = 1:Mt
                if tmp(k) == 1 
                    num = num + 1;
                    if(find(ind == num))
                        tmp(k) = 0;  
                    end
                end
            end
            samples_Mt(i,1+(j-1)*Mt:j*Mt) = tmp;
        else                 % ��Ҫ������1
           ind = sort(randperm(Mt-sum(tmp),M-sum(tmp)));
           num = 0;
           for k = 1:Mt
                if tmp(k) == 0 
                    num = num + 1;
                    if(find(ind == num))
                        tmp(k) = 1;  
                    end
                end
           end
           samples_Mt(i,1+(j-1)*Mt:j*Mt) = tmp;
        end
    end
    for j = 1:K
        samples_M(i,1+(j-1)*M:j*M) = find(samples_Mt(i,1+(j-1)*Mt:j*Mt)== 1);
    end
end