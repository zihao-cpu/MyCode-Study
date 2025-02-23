%% I. ��ջ�������
clear all
clc

%% II. ѵ����/���Լ�����
%%
% 1. ��������
load water_data.mat

%%
% 2. ���ݹ�һ��
attributes = mapminmax(attributes);

%%
% 3. ѵ�����Ͳ��Լ�����

% ѵ��������35������
P_train = attributes(:,1:35);
T_train = classes(:,1:35);
% ���Լ�����4������
P_test = attributes(:,36:end);
T_test = classes(:,36:end);

%% III. ���������紴����ѵ�����������
%%
% 1. ��������
net = newc(minmax(P_train),4,0.01,0.01);  %��Ϊ����ֳ����࣬��������������Ԫ����Ϊ4��0.01�ֱ�����Ȩֵ����ֵ��ѧϰ��
%����ִ��һ��minmax(P_train)�������ֵ��1����Сֵ��-1����P_train���ֵ��Сֵ���ϡ�
% ����      w=net.iw{1,1};      ��һ��   ����Ȩֵ      ƽ��ֵΪ0   �ĸ���Ԫ��������   4*6����Ԫ��ȫ��Ϊ0
%����      b=net.b{1}    ��һ��  ������ֵ      edit  initcon      rows=4
%134�п�һ��  x��ֵ�ǲ����������ֵ

%%
% 2. ����ѵ������
net.trainParam.epochs = 500;     %ѵ������

%%
% 3. ѵ������
net = train(net,P_train);     

%%
% 4. �������

% ѵ����
t_sim_compet_1 = sim(net,P_train);
T_sim_compet_1 = vec2ind(t_sim_compet_1);
% ���Լ�
t_sim_compet_2 = sim(net,P_test);
T_sim_compet_2 = vec2ind(t_sim_compet_2);     % vec2ind������ϡ�����ת����������������������T-train��classesû���õ����������޵�ʦѧϰ�Ĺ���
%����һ��  77 78 �п�һ�½��      �ļ�����Ԫ������ÿһ����
%% IV. SOFM�����紴����ѵ�����������
%%
% 1. ��������
net = newsom(P_train,[4 4]);

%%
% 2. ����ѵ������
net.trainParam.epochs = 200;

%%
% 3. ѵ������
net = train(net,P_train);

%%
% 4. �������

% ѵ����
t_sim_sofm_1 = sim(net,P_train);
T_sim_sofm_1 = vec2ind(t_sim_sofm_1);
% ���Լ�
t_sim_sofm_2 = sim(net,P_test);
T_sim_sofm_2 = vec2ind(t_sim_sofm_2);

%% V. ����Ա�
%%
% 1. ����������
result_compet_1 = [T_train' T_sim_compet_1']
result_compet_2 = [T_test' T_sim_compet_2']

%%    1960009019    l13299109228
% 2. SOFM������
result_sofm_1 = [T_train' T_sim_sofm_1']
result_sofm_2 = [T_test' T_sim_sofm_2']
