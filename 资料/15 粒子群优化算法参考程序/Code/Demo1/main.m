%% I. ��ջ���
clc
clear all

%% II. ����Ŀ�꺯������ͼ
x = 1:0.01:2;
y = sin(10*pi*x) ./ x;
figure
plot(x, y)
hold on

%% III. ������ʼ��
c1 = 1.49445;
c2 = 1.49445;
ws = 0.9;
we = 0.4;
maxgen = 50;   % ��������  
sizepop = 10;   %��Ⱥ��ģ,10������
Vmax = 0.5;   %�ٶ����ֵ
Vmin = -0.5;
popmax = 2;  %����x��Χ���嵽1-2
popmin = 1;

%% IV. ������ʼ���Ӻ��ٶ�
for i = 1:sizepop
    % �������һ����Ⱥ
    pop(i,:) = (rands(1) + 1) / 2 + 1;    %��ʼ��Ⱥ�����ʵ����x���巶Χ1-2��rands�����ķ�ΧΪ-1��1
    V(i,:) = 0.5 * rands(1);  %��ʼ���ٶȣ��붨����ٶ����ֵ����СֵҪһ��
    % ������Ӧ��
    fitness(i) = fun(pop(i,:));   
end

%% V. ���弫ֵ��Ⱥ�弫ֵ
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   %ȫ�����
gbest = pop;    %�������
fitnessgbest = fitness;   %���������Ӧ��ֵ
fitnesszbest = bestfitness;   %ȫ�������Ӧ��ֵ

%% VI. ����Ѱ��
for i = 1:maxgen
    w = ws - (ws-we)*(i/maxgen);
    for j = 1:sizepop
        % �ٶȸ���
        %V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));  %�ٶȸ��¹�ʽ
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:)); 
        V(j,find(V(j,:)>Vmax)) = Vmax;       %�߽�Լ��
        V(j,find(V(j,:)<Vmin)) = Vmin;      
        
        % ��Ⱥ����
        pop(j,:) = pop(j,:) + V(j,:);        %λ�ø��¹�ʽ
        pop(j,find(pop(j,:)>popmax)) = popmax;    %λ��Լ��
        pop(j,find(pop(j,:)<popmin)) = popmin;
        
        % ��Ӧ��ֵ����
        fitness(j) = fun(pop(j,:)); 
    end
    
    for j = 1:sizepop    
        % �������Ÿ���
        if fitness(j) > fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % Ⱥ�����Ÿ���
        if fitness(j) > fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
    yy(i) = fitnesszbest;          
end

%% VII. ����������ͼ
[fitnesszbest zbest]
plot(zbest, fitnesszbest,'r*')

figure
plot(yy)
title('���Ÿ�����Ӧ��','fontsize',12);
xlabel('��������','fontsize',12);ylabel('��Ӧ��','fontsize',12);

