%% I. ��ջ�������   ���ɷַ���
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

%% IV. ���ɷַ���
%%
% 1. ���ɷֹ����ʷ���     PCAVar   ����ֵ
[PCALoadings,PCAScores,PCAVar] = princomp(NIR);
figure
percent_explained = 100 * PCAVar / sum(PCAVar);
pareto(percent_explained)
xlabel('���ɷ�')
ylabel('������(%)')
title('���ɷֹ�����')

%%
% 2. ��һ���ɷ�vs.�ڶ����ɷ�   ��������ѵ�������Ƿ�õ��ж�����
[PCALoadings,PCAScores,PCAVar] = princomp(P_train);
figure
plot(PCAScores(:,1),PCAScores(:,2),'r+')
hold on
[PCALoadings_test,PCAScores_test,PCAVar_test] = princomp(P_test);
plot(PCAScores_test(:,1),PCAScores_test(:,2),'o')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
legend('Training Set','Testing Set','location','best')

%% V. ���ɷֻع�ģ��
%%
% 1. ����ģ��
k = 4;    %���ɷ�����Ϊ4��
betaPCR = regress(T_train-mean(T_train),PCAScores(:,1:k));    %ǰ������ȡ���������ع�ģ��
betaPCR = PCALoadings(:,1:k) * betaPCR;
betaPCR = [mean(T_train)-mean(P_train) * betaPCR;betaPCR];
%%
% 2. Ԥ�����
N = size(P_test,1);       %��Ҹ����Լ��������Nֵ��P_test
T_sim = [ones(N,1) P_test] * betaPCR;         

%% VI. ����������ͼ
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


