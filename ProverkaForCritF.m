clc
clear all
data=readtable('Data1.xlsx');
x=data(:,1);
x=table2array(x);
y=data(:,2);
y=table2array(y);
size=size(x);
size=size(1);

model1='y=b1+b2*x+e';
m=2;
X=ones([size,m]);
for i=1:size
    for j=1:m
        if j==1
            X(i,j)=x(i)^0;
        else
            X(i,j)=x(i);
        end;
    end;
end;
b1=(X'*X)\(X'*y)
predict1=X*b1;
e1=y-predict1;
CritCachest1=[(e1'*e1);(e1'*e1)/(size-m);(1-(e1'*e1)/((y-mean(y))'*(y-mean(y))))]
X1=X;

H=CritF(y,predict1,size,m,0.05)