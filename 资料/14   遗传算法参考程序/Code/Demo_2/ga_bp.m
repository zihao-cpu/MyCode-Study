%% I. �����������
clear all
clc

%% II. ����ȫ�ֱ���
global p     % ѵ������������
global t     % ѵ�����������
global R     % ������Ԫ����
global S2    % �����Ԫ����
global S1    % ������Ԫ����
global S     % ���볤��  ��ʵ��������Ȩֵ��������ֵ�������ܺ�
S1 = 10;

%% III. ��������
%%
% 1. ѵ������     6-10-4   6*10+10*4+10+4
p = [0.01 0.01 0.00 0.90 0.05 0.00;
     0.00 0.00 0.00 0.40 0.50 0.00;
     0.80 0.00 0.10 0.00 0.00 0.00;
     0.00 0.20 0.10 0.00 0.00 0.10]';
t = [1.00 0.00 0.00 0.00;
     0.00 1.00 0.00 0.00;
     0.00 0.00 1.00 0.00;
     0.00 0.00 0.00 1.00]';
%%
% 2. ��������
P_test = [0.05 0    0.9  0.12 0.02 0.02;
          0    0    0.9  0.05 0.05 0.05;
          0.01 0.02 0.45 0.22 0.04 0.06;
          0    0    0.4  0.5  0.1  0;
          0    0.1  0    0    0    0]';

%% IV. BP������
%%
% 1. ���紴��
net = newff(minmax(p),[S1,4],{'tansig','purelin'},'trainlm'); 

%%
% 2. ����ѵ������
net.trainParam.show = 10;
net.trainParam.epochs = 2000;
net.trainParam.goal = 1.0e-3;
net.trainParam.lr = 0.1;

%%
% 3. ����ѵ��
[net,tr] = train(net,p,t);

%%
% 4. �������
s_bp = sim(net,P_test)    % BP������ķ�����

%% V. GA-BP������
R = size(p,1);
S2 = size(t,1);
S = R*S1 + S1*S2 + S1 + S2;        %������˸ղ�  114
aa = ones(S,1)*[-1,1];      

%% VI. �Ŵ��㷨�Ż�
%%
% 1. ��ʼ����Ⱥ
popu = 50;  % ��Ⱥ��ģ
initPpp = initializega(popu,aa,'gabpEval',[],[1e-6 1]);  % ��ʼ����Ⱥ      gabpEval   ��һ�������������������gadecod

%%
% 2. �����Ż�
gen = 100;  % �Ŵ�����
% ����GAOT�����䣬����Ŀ�꺯������ΪgabpEval     endpop  ǰ114���Ǻ�S��115�д���  ��Ӧ�Ⱥ���ֵ
[x,endPop,bPop,trace] = ga(aa,'gabpEval',[],initPpp,[1e-6 1 1],'maxGenTerm',gen,...
                           'normGeomSelect',[0.09],['arithXover'],[2],'nonUnifMutation',[2 gen 3]);
%%
% 3. ��������仯����
figure(1)
plot(trace(:,1),1./trace(:,3),'r-');
hold on
plot(trace(:,1),1./trace(:,2),'b-');
xlabel('Generation');
ylabel('Sum-Squared Error');

%%
% 4. ������Ӧ�Ⱥ����仯
figure(2)
plot(trace(:,1),trace(:,3),'r-');
hold on
plot(trace(:,1),trace(:,2),'b-');
xlabel('Generation');
ylabel('Fittness');

%% VII. �������ŽⲢ��ֵ
%%
% 1. �������Ž�
[W1,B1,W2,B2,val] = gadecod(x);

%%
% 2. ��ֵ��������
net.IW{1,1} = W1;
net.LW{2,1} = W2;
net.b{1} = B1;
net.b{2} = B2;

%% VIII. �����µ�Ȩֵ����ֵ����ѵ��
net = train(net,p,t);

%% IX. �������
s_ga = sim(net,P_test)    %�Ŵ��Ż���ķ�����

