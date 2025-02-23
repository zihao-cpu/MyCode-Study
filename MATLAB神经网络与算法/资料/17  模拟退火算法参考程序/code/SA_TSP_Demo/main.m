 %% I. ��ջ�������
clear all
clc

%% II. �������λ������
X = [16.4700   96.1000
     16.4700   94.4400
     20.0900   92.5400
     22.3900   93.3700
     25.2300   97.2400
     22.0000   96.0500
     20.4700   97.0200
     17.2000   96.2900
     16.3000   97.3800
     14.0500   98.1200
     16.5300   97.3800
     21.5200   95.5900
     19.4100   97.1300
     20.0900   92.5500];

%% III. ����������
D = Distance(X);  %����������   �Խ�����Ϊ0
N = size(D,1);    %���еĸ���

%% IV. ��ʼ������
T0 = 1e10;   % ��ʼ�¶�
Tend = 1e-30;  % ��ֹ�¶�
L = 2;    % ���¶��µĵ���������û���õ�
q = 0.9;    %��������
Time = ceil(double(solve([num2str(T0) '*(0.9)^x = ',num2str(Tend)])));  % ��������Ĵ���
% Time = 132;
count = 0;        %��������
Obj = zeros(Time,1);         %Ŀ��ֵ�����ʼ��
track = zeros(Time,N);       %ÿ��������·�߾����ʼ��

%% V. �������һ����ʼ·��
S1 = randperm(N);
DrawPath(S1,X)
disp('��ʼ��Ⱥ�е�һ�����ֵ:')
OutputPath(S1);
Rlength = PathLength(D,S1);
disp(['�ܾ��룺',num2str(Rlength)]);

%% VI. �����Ż�
while T0 > Tend
    count = count + 1;     %���µ�������
    temp = zeros(L,N+1);
    %%
    % 1. �����½�  ����һ���Ŷ�
    S2 = NewAnswer(S1);
    %%
    % 2. Metropolis�����ж��Ƿ�����½�
    [S1,R] = Metropolis(S1,S2,D,T0);  %Metropolis �����㷨
    %%
    % 3. ��¼ÿ�ε������̵�����·��
    if count == 1 || R < Obj(count-1)
        Obj(count) = R;           %�����ǰ�¶�������·��С����һ·�����¼��ǰ·��
    else
        Obj(count) = Obj(count-1);%�����ǰ�¶�������·�̴�����һ·�����¼��һ·��
    end
    track(count,:) = S1;
    T0 = q * T0;     %����
end

%% VII. �Ż����̵���ͼ
figure
plot(1:count,Obj)
xlabel('��������')
ylabel('����')
title('�Ż�����')

%% VIII. ��������·��ͼ
DrawPath(track(end,:),X)

%% IX. ������Ž��·�ߺ��ܾ���
disp('���Ž�:')
S = track(end,:);
p = OutputPath(S);
disp(['�ܾ��룺',num2str(PathLength(D,S))]);
