function D = Distance(citys)
%% ������������֮��ľ���
% ���� citys  �����е�λ������
% ��� D  ��������֮��ľ���

n = size(citys,1);
D = zeros(n,n);
for i = 1:n
    for j = i+1:n
        D(i,j) = sqrt(sum((citys(i,:) - citys(j,:)).^2));
        D(j,i) = D(i,j);
    end
end
