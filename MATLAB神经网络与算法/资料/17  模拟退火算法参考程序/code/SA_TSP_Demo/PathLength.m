function Length = PathLength(D,Route)
%% ����������·������
% ���룺
% D     ��������֮��ľ���
% Route ����Ĺ켣

Length = 0;
n = size(Route,2);
for i = 1:(n - 1)
    Length = Length + D(Route(i),Route(i + 1));
end
Length = Length + D(Route(n),Route(1));

