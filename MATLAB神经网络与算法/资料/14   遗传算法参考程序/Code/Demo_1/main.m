%% I. ��ջ�������
%optimtool    solver   ��ѡ��   GA
%��� gaot������
clear all
clc

%% II. ���ƺ�������
x = 0:0.01:9;
y =  x + 10*sin(5*x)+7*cos(4*x);

figure
plot(x, y)
xlabel('�Ա���')
ylabel('�����')
title('y = x + 10*sin(5*x) + 7*cos(4*x)')
grid

%% III. ��ʼ����Ⱥ
initPop = initializega(50,[0 9],'fitness');    %��Ⱥ��С�������仯��Χ����Ӧ�Ⱥ���������
%��һ��initpop     �ڶ��д���   ��Ӧ�Ⱥ���ֵ
%% IV. �Ŵ��㷨�Ż�
[x endPop bpop trace] = ga([0 9],'fitness',[],initPop,[1e-6 1 1],'maxGenTerm',25,...
                           'normGeomSelect',0.08,'arithXover',2,'nonUnifMutation',[2 25 3]);
%������Χ���½磻��Ӧ�Ⱥ�������Ӧ�Ⱥ����Ĳ�������ʼ��Ⱥ�����Ⱥ���ʾ��ʽ����ֹ���������ƣ�
%��ֹ�����Ĳ�����ѡ���������ƣ�ѡ�����Ĳ��������溯�������ƣ����溯���Ĳ��������캯����
%���ƣ����캯���Ĳ���
%  X    ���Ÿ���     endpop   �Ż���ֹ��������Ⱥ    bpop ������Ⱥ�Ľ����켣   trace   ��������������
%���ŵ���Ӧ�Ⱥ���ֵ����Ӧ�Ⱥ���ֵ����

%% V. ������ŽⲢ�������ŵ�
x
hold on
plot (endPop(:,1),endPop(:,2),'ro')

%% VI. ���Ƶ�����������
figure(2)
plot(trace(:,1),trace(:,3),'b:')
hold on
plot(trace(:,1),trace(:,2),'r-')
xlabel('Generation'); ylabel('Fittness');
legend('Mean Fitness', 'Best Fitness')

