function [varargout]=eig_mini_d(A,d)
%%���ڲ���d����С����ֵ��Ӧ����������
[V, D] = eig(A);
D = abs(diag(D));
[D, I] = sort(D, 'ascend');
if d > length(D)
    d = length(D);
end
%varargout = {D(1 : d)};
varargout = {V(:, I(1 : d))};
end