function [b,s2,sigma22,r22,e,S,y1] = regressOpt(X,y)
b=(X'*X)\(X'*y);
y1=X*b;

e=y-y1;
s2=e'*e; %остаточная сумма квадратов
sigma22=s2/(size(X,1)-size(X,2));%оценка дисперсии остатков
r22=(1-(s2)/((y-mean(y))'*(y-mean(y))));%коэф детерминации
S=sum(e.^2)/length(e);
