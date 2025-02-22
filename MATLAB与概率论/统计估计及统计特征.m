
%%正态概率图
%图形检验正态性
h=normplot(x);
%Quantile-Quantile  近似直线则来自同一分布
qqplot(x);
qqplot(x,y); 

%%4.3参数点估计
%极大似然估计
[muhat,sigmahat,muci,sigmaci]=normfit(X,0.01); % 99%的置信区间
[phat,pci]=mle(x,'distribution',dist,'alpha',a);

%%4.4区间估计
X;
mu=mean(X);
muLOWER=mean(X)-tinv(0.95,size(X)-1)*sqrt(var(x)/size(X));


