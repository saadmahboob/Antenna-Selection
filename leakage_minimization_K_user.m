% leakage_minimization_K_user(H, V, iter) runs the leakage minimization 
% algorithm and returns the set of K beamforming V and the set of K zeroforcing U matrices. 
% The inputs are the K^2 MrxMt channels H, the K initialization beamformers V, and the number of iterations.

function [V, U] = leakage_minimization_K_user(H, V, iter)

[Mr, Mt, K, ~] = size(H); % obtain problem parameters
d = size(V,2);
U = zeros(Mr, d, K);

 for iteration=1:iter  %%һ���ڶ�ʮ���������� 
            Qv = zeros(Mr, Mr, K);   % ��ʼ������Э�������
            Qu = zeros(Mt, Mt, K);   % ��ʼ�������ŵ�Э�������
            
            for i = 1:K
               for j = [1:i-1 i+1:K]
                   Qv(:,:,i) = Qv(:,:,i) + H(:,:,j,i)*V(:,:,j)*V(:,:,j)'*H(:,:,j,i)'; %��Э�������
               end
              
            end
             for k = 1:K
                   U(:,:,k) = eig_mini_d(Qv(:,:,k),d);%�������ƾ���
             end
            for i = 1:K
               for j = [1:i-1 i+1:K]
                   Qu(:,:,i) = Qu(:,:,i) + H(:,:,i,j)'*U(:,:,j)*U(:,:,j)'*H(:,:,i,j); %����Э�������
               end
               
            end
            for k = 1:K
                   V(:,:,k)=eig_mini_d( Qu(:,:,k),d); %�������ξ���
            end
 end
end

