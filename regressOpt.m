function [s2,sigma22,r22,e,S,y1,b] = regressOpt(X,y)
b=(X'*X)\(X'*y);
y1=X*b;

e=y-y1;
s2=e'*e; %���������� ����� ���������
sigma22=s2/(size(X,1)-size(X,2));%������ ��������� ��������
r22=(1-(s2)/((y-mean(y))'*(y-mean(y))));%���� ������������
S=sum(e.^2)/length(e);
