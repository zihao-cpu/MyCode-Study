
%% ѧϰĿ�꣺ ����������
%%  �����ٶȺ;��ȱ�֮ǰ���ĸ�֪��������Ҫ�ߣ�
%%  ��ҪӦ���ں����ƽ����ź�Ԥ�⣬ģʽʶ��ϵͳ��ʶ����
clear all;
close all;
P=[1.1 2.2 3.1 4.1];
T=[2.2 4.02 5.8 8.1];
lr=maxlinlr(P);                   %��ȡ���ѧϰ����
net=newlin(minmax(P),1,0,lr);     %��������������
net.trainParam.epochs=500;        %ѵ��    ����500��
net.trainParam.goal=0.04;         %ѵ������趨Ϊ0.04
net=train(net,P,T);
Y=sim(net,P)                       %����
%%   ����QQ��1960009019
%%   ���߽���΢�Ź��ںţ�����һƷ��
%%   ����ţ����߽�������һƷ��
%%   һ����Ѷ�ţ�����һƷ��
%%    2018/3/20  ¼�ƣ���ӭָ��
%%  ������������������źŵ�Ԥ��
clear all;
close all;
t=0:pi/10:4*pi;
X=t.*sin(t);
T=2*X+3;
figure;
plot(t,X,'+-',t,T,'+--');
legend('ϵͳ����','ϵͳ���');
set(gca,'xlim',[0 4*pi]);
set(gcf,'position',[50,50,400,400]);
net=newlind(X,T);
y=sim(net,X);
figure;
plot(t,y,'+:',t,y-T,'r:');
legend('����Ԥ�����','���');
set(gca,'xlim',[0 4*pi]);
set(gcf,'position',[50,50,400,400]);

%%  