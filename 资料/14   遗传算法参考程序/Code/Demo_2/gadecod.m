function[W1,B1,W2,B2,val]=gadecod(x)
global p
global t
global R
global S2
global S1
% ǰR*S1������ΪW1
for i=1:S1
    for k=1:R
        W1(i,k)=x(R*(i-1)+k);
    end
end
% ���ŵ�S1*S2������(����R*S1����ı���)ΪW2
for i=1:S2
    for k=1:S1
        W2(i,k)=x(S1*(i-1)+k+R*S1);
    end
end
% ���ŵ�S1������(����R*SI+SI*S2����ı���)ΪB1
for i=1:S1
    B1(i,1)=x((R*S1+S1*S2)+i);
end
%���ŵ�S2������(����R*SI+SI*S2+S1����ı���)ΪB2
for i=1:S2
    B2(i,1)=x((R*S1+S1*S2+S1)+i);
end
% ����S1��S2������
A1=tansig(W1*p,B1);
A2=purelin(W2*A1,B2);
% �������ƽ����
SE=sumsqr(t-A2);
% �Ŵ��㷨����Ӧֵ
val=1/SE;