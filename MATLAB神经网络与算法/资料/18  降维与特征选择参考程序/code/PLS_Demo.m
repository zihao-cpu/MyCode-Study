%% I. ��ջ�������   ƫ��С����        1960009019    l13299109228
clear all
clc

%% II. ��������
load spectra;

%% III. �������ѵ��������Լ�
temp = randperm(size(NIR, 1));
% temp = 1:60;
%%
% 1. ѵ��������50������
P_train = NIR(temp(1:50),:);
T_train = octane(temp(1:50),:);
%%
% 2. ���Լ�����10������
P_test = NIR(temp(51:end),:);
T_test = octane(temp(51:end),:);

%% IV. PLS�ع�ģ��
%%
% 1. ����ģ��
k = 2;    %���ɷ�����Ϊ2
[Xloadings,Yloadings,Xscores,Yscores,betaPLS,PLSPctVar,MSE,stats] = plsregress(P_train,T_train,k);

%%
% 2. ���ɷֹ����ʷ���
figure
percent_explained = 100 * PLSPctVar(2,:) / sum(PLSPctVar(2,:));
pareto(percent_explained)
xlabel('���ɷ�')
ylabel('������(%)')
title('���ɷֹ�����')

%%
% 3. Ԥ�����
N = size(P_test,1);
T_sim = [ones(N,1) P_test] * betaPLS;

%% V. ����������ͼ
%%
% 1. ������error
error = abs(T_sim - T_test) ./ T_test;
%%
% 2. ����ϵ��R^2
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
%%
% 3. ����Ա�
result = [T_test T_sim error]

%% 
% 4. ��ͼ
figure
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o')
legend('��ʵֵ','Ԥ��ֵ','location','best')
xlabel('Ԥ������')
ylabel('����ֵ')
string = {'���Լ�����ֵ����Ԥ�����Ա�';['R^2=' num2str(R2)]};
title(string)


