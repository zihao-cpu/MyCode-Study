%% I. ��ջ�������
clear all
clc
warning off

%% II. ��������     ��һ�������     �ڶ��������Ի��Ƕ��ԣ����ٰ���  ��������������30��
load data.mat

%%
% 1. �������ѵ����/���Լ�
a = randperm(569);
Train = data(a(1:500),:);        %����500��ѵ����
Test = data(a(501:end),:);       %ʣ�µ��ǲ��Լ�  69��

%%
% 2. ѵ������
P_train = Train(:,3:end);
T_train = Train(:,2);

%%
% 3. ��������
P_test = Test(:,3:end);
T_test = Test(:,2);

%% III. ����������������
ctree = ClassificationTree.fit(P_train,T_train);

%%
% 1. �鿴��������ͼ
view(ctree);
view(ctree,'mode','graph');

%% IV. �������
T_sim = predict(ctree,P_test);

%% V. �������
count_B = length(find(T_train == 1));
count_M = length(find(T_train == 2));
rate_B = count_B / 500;
rate_M = count_M / 500;
total_B = length(find(data(:,2) == 1));
total_M = length(find(data(:,2) == 2));
number_B = length(find(T_test == 1));
number_M = length(find(T_test == 2));
number_B_sim = length(find(T_sim == 1 & T_test == 1));
number_M_sim = length(find(T_sim == 2 & T_test == 2));
disp(['����������' num2str(569)...
      '  ���ԣ�' num2str(total_B)...
      '  ���ԣ�' num2str(total_M)]);
disp(['ѵ��������������' num2str(500)...
      '  ���ԣ�' num2str(count_B)...
      '  ���ԣ�' num2str(count_M)]);
disp(['���Լ�����������' num2str(69)...
      '  ���ԣ�' num2str(number_B)...
      '  ���ԣ�' num2str(number_M)]);
disp(['������������ȷ�' num2str(number_B_sim)...
      '  ���' num2str(number_B - number_B_sim)...
      '  ȷ����p1=' num2str(number_B_sim/number_B*100) '%']);
disp(['������������ȷ�' num2str(number_M_sim)...
      '  ���' num2str(number_M - number_M_sim)...
      '  ȷ����p2=' num2str(number_M_sim/number_M*100) '%']);
  
%% VI. Ҷ�ӽڵ㺬�е���С�������Ծ��������ܵ�Ӱ��
leafs = logspace(1,2,10);

N = numel(leafs);

err = zeros(N,1);
for n = 1:N
    t = ClassificationTree.fit(P_train,T_train,'crossval','on','minleaf',leafs(n));
    err(n) = kfoldLoss(t);
end
plot(leafs,err);
xlabel('Ҷ�ӽڵ㺬�е���С������');
ylabel('������֤���');
title('Ҷ�ӽڵ㺬�е���С�������Ծ��������ܵ�Ӱ��')

%% VII. ����minleafΪ13�������Ż�������
OptimalTree = ClassificationTree.fit(P_train,T_train,'minleaf',13);
view(OptimalTree,'mode','graph')

%%
% 1. �����Ż�����������ز������ͽ�����֤���
resubOpt = resubLoss(OptimalTree)
lossOpt = kfoldLoss(crossval(OptimalTree))

%%
% 2. �����Ż�ǰ���������ز������ͽ�����֤���
resubDefault = resubLoss(ctree)
lossDefault = kfoldLoss(crossval(ctree))

%% VIII. ��֦
[~,~,~,bestlevel] = cvLoss(ctree,'subtrees','all','treesize','min')
cptree = prune(ctree,'Level',bestlevel);
view(cptree,'mode','graph')

%%
% 1. �����֦����������ز������ͽ�����֤���
resubPrune = resubLoss(cptree)
lossPrune = kfoldLoss(crossval(cptree))

