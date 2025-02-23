function [IW,B,LW,TF,TYPE] = elmtrain(P,T,N,TF,TYPE)    %P  �������   T   �������    N    ������Ԫ���� TF    ���ݺ���   TYPE  0 �ع黹�Ƿ��� 1
%IW    �����������������Ȩֵ   B  ��������Ԫ��ֵ     LW ͨ���ⷽ����õ��������������������Ȩֵ    TF
%TYPE   һ����Ԥ��Ҫ�á�һ��������
if nargin < 2   %���ú����Ĳ�������С��2
    error('ELM:Arguments','Not enough input arguments.');   %��ʾ����������������
end
if nargin < 3
    N = size(P,2);          %��Ԫ�������������������
end
if nargin < 4
    TF = 'sig';    %Ĭ��  sig
end
if nargin < 5
    TYPE = 0;   %Ĭ�ϻع�����
end
if size(P,2) ~= size(T,2)      %���  ����   Ҳ�����������Ƿ����
    error('ELM:Arguments','The columns of P and T must be same.');     %����ȵĻ���ʾ����
end
[R,Q] = size(P);
if TYPE  == 1
    T  = ind2vec(T);        
end
[S,Q] = size(T);          

IW = rand(N,R) * 2 - 1;    %������������������������Ȩֵ

B = rand(N,1);            %���������ֵ
BiasMatrix = repmat(B,1,Q);    

tempH = IW * P + BiasMatrix;         %�õ���Ԫ������
switch TF                     %ͨ��������õ�����������
    case 'sig'
        H = 1 ./ (1 + exp(-tempH));
    case 'sin'
        H = sin(tempH);
    case 'hardlim'
        H = hardlim(tempH);
end

LW = pinv(H') * T';    %ͨ�����weini   �õ�  �����������������Ȩֵ
