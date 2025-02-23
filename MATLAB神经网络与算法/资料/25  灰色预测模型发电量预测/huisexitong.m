%% ѧϰĿ�꣺ ��ɫԤ��ģ��Ԥ�ⷢ����
%%    QQ��1960009019
%%   ����matlab����ר��γ̺Ͱ�������������΢�Ź��ںţ�����һƷ��
function huisexitong()
%%  ԭʼ����������
X0=[306.35,311.2,324.9,343.4,361.61,390.76,421.36,458.75,494.9,522.78,547.22,588.7,647.18,712.34,778.32,835.31,888.1,923.16,939.48];
KK=300;                %KK����30��Խ��Խû������
x0=sin(sqrt(X0)/KK);    %�õ��任���ֵ����Ϊԭʼ������

n=length(x0);
for k=1:n   
    x1(k)=sum(x0(1:k));              %����x1
end
z(1)=0;
for k=1:n-1
    z(k+1)=(x1(k)+2*Newton(1:n,x1,k+2/4)+4*(Newton(1:n,x1,k+1/4)+Newton(1:n,x1,k+3/4))+x1(k+1))/12;        %����z1
end

Y=(x0(2:end))';
B=[-1*(z(2:end))' ones(n-1,1)];
au=(inv(B'*B))*(B')*Y;              %�õ�a��u
a=au(1);
u=au(2);



%x01��ʾԤ��ֵ
for m=1:n
    for k=0:n-1
        x01(k+1)=(x1(m)-u/a)*exp(-a*(k-m+1))+u/a;    %��Ԥ�⹫ʽ����Ԥ��ֵ
    end
    x02=huanyuan(x01);           %Ԥ�������ֵ��Ҫǰ����������õ�Ԥ��ֵ
    derta(m)=100*sum(abs((x02(1:n)-x0)./x0))/n;
end
figure
plot(derta)
title('��m�µ�ƽ���������')
xlabel('m')
ylabel('ƽ����� %')
[Y m_min]=min(derta);    %�ҵ�ƽ�������Сʱ��Ӧ��m

dd=3;       %��ҪԤ�������
m=m_min;    %�˴�mȡƽ�������С��m��Ҳ�����ڴ��޸�m
for k=0:n-1+dd
    x01(k+1)=(x1(m)-u/a)*exp(-a*(k-m+1))+u/a;    %��Ԥ�⹫ʽ����Ԥ��ֵ
end
x02=huanyuan(x01);           %Ԥ�������ֵ��Ҫǰ����������õ�Ԥ��ֵ

yucezhi=(asin(x02)*KK).^2;


X0all=[306.35,311.2,324.9,343.4,361.61,390.76,421.36,458.75,494.9,522.78,547.22,588.7,647.18,712.34,778.32,835.31,888.1,923.16,939.48,988.6,1073.62,1164.29];
num=1;
for i=1980:2001
    year{num}=num2str(i);
    num=num+1;
end

figure
axes('XTickLabel',year,'XTick',1:22)
axis([1 22 200 1400])
hold on
h(1)=plot(yucezhi,'*-');
h(2)=plot(X0all,'ro-');
legend(h,{'Ԥ��ֵ','ԭʼֵ'},'Location','NorthWest')
title('ԭʼ��������Ԥ�ⷢ����')
xlabel('���');
ylabel('������')
end

function XD=huanyuan(X)
%% ��ɫϵͳ����ԭ���ӣ�����ԭ����(������һ��)�����ʼ���㻯�������У�������һ�У�
n=length(X);
XD(1)=X(1);
for k=2:n
    XD(k)=X(k)-X(k-1);
end
end

function yi=Newton(x,y,xi)
%%  Newton��ֵ����������һϵ�в�ֵ�ĵ�(x,y)���õ���x=xi���ģ�ţ�ٲ�ֵ�����ֵyi
n=length(x);
m=length(y);
A=zeros(n);    %������̱�
A(:,1)=y;      %���̱��һ��Ϊy
for j=2:n               %jΪ�б�
    for i=1:(n-j+1)     %iΪ�б�
        A(i,j)=(A(i+1,j-1)-A(i,j-1))/(x(i+j-1)-x(i));   %������̱�
    end
end
%%  ���ݲ��̱�,���Ӧ��ţ�ٲ�ֵ����ʽ��x=xi����ֵyi
N(1)=A(1,1);
for j=2:n
    T=1;
    for i=1:j-1
        T=T*(xi-x(i));
    end
    N(j)=A(1,j)*T;
end
yi=sum(N);   %��x=xi����ţ�ٲ�ֵ����ʽ���õ���yi��ֵ
end







