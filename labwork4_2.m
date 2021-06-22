clc;
close all;
clear all;
%Q=xlsread('TimeSeries.xls', '������ �� ���', 'B3:B446');
data=readtable('TimeSeriesQ.xlsx');
Q=data(1:444,2);
Q=table2array(Q);
T = zeros(length(Q),1);
for i=2:length(Q)
    T(i) = T(i-1)+2;
end

figure
title('������ ����������� ������� �� �������');
plot(T,Q);
figure
autocorr(Q,100);

%�������� ������ � ������� ���������������� ���������(�����������)
d_Q = zeros(length(Q),1);
for i = 2:length(Q)
    d_Q(i) = Q(i)-Q(i-1);
end
figure
autocorr(d_Q,100); 
title('ACF ������� ��� ������');

k=12;
X1 = [T.^0,  sin(pi*T/k), sin(2*pi*T/k),  sin(3*pi*T/k), cos(3*pi*T/k)];
X2 = [T.^0, sin(pi*T/k), cos(2*pi*T/k), cos(6*pi*T/k), sin(3*pi*T/k), cos(4*pi*T/k)];
X3 = [T.^0, cos(pi*T/k), sin(2*pi*T/k), sin(3*pi*T/k), cos(3*pi*T/k), cos(8*pi*T/k), sin(4*pi*T/k), cos(4*pi*T/k)];
X4 = [T.^0, sin(pi*T/k), cos(pi*T/k), sin(2*pi*T/k), cos(2*pi*T/k), sin(3*pi*T/k), cos(3*pi*T/k), sin(4*pi*T/k), cos(4*pi*T/k),sin(5*pi*T/k), cos(5*pi*T/k),sin(6*pi*T/k)];
X5 = [T.^0, cos(pi*T/k), cos(12*pi*T/k), sin(3*pi*T/k), cos(8*pi*T/k), sin(4*pi*T/k), sin(5*pi*T/k)];

X={X1,X2,X3,X4,X5};
R2=[];
for i=1:length(X)
[s2,sigma2,r2,e,S,y1]=regressOpt(X{i},d_Q);
R2=[R2 r2];
end;
[Opt j]=max(R2);
[s2,sigma2,r2,e,S,y1]=regressOpt(X{j},d_Q);


%(�)���������� � ������������� ���� ��� (������� ���� �����)


figure
autocorr(e,100); 
title('���');



%�������+11-�� ����
index1=[];
Xopt=X{j};
XoptCopy=Xopt;
y=d_Q;

All=0;
while All~=1
while length(index1)<2
    [Xopt, index1,tnm,t,stats,q]=CritStudentaNew(Xopt,T,y,sigma2,0.05,index1);
    if q==1
        break;
    end;
end;
if (q==1) && length(index1)==0
    break;
end;
size1=size(Xopt,2);
Xopt=CritFisheraNew(XoptCopy,T,y,s2,0.95,index1);
if size(Xopt,2)~=size1
    All=1;
    break;
end;
%%%
XoptCopy=Xopt;
%%%
index1=[];
end;
[s2,sigma2,r2,e12,S,y1]=regressOpt(Xopt,y);
figure
autocorr(e12,100); 
title('��� ���');


%(�)���������� � ������������� ���� ���+����������
I = zeros(length(Q),k);
for j=1:k
    for i=j:k:length(Q)
        I(i,j)=1;
    end
end
I;
[s2,sigma2,r2,e2,S,y1]=regressOpt(I,d_Q);
figure
autocorr(e2,100);
title('����������');

index1=[];
Xopt=I;
XoptCopy=Xopt;
y=d_Q;

All=0;
while All~=1
while length(index1)<2
    [Xopt, index1,tnm,t,stats,q]=CritStudentaNew(Xopt,T,y,sigma2,0.05,index1);
    if q==1
        break;
    end;
end;
if (q==1) && length(index1)==0
    break;
end;
size1=size(Xopt,2);
Xopt=CritFisheraNew(XoptCopy,T,y,s2,0.95,index1);
if size(Xopt,2)~=size1
    All=1;
    break;
end;
%%%
XoptCopy=Xopt;
%%%
index1=[];
end;
[s2,sigma2,r2,e24,S,y1]=regressOpt(Xopt,d_Q);
figure
autocorr(e24,100); 
title('���������� ���');


%(�)���������� � ������������� ���� ����������� ������ ��� ������� ��������
%��� ������� ����
days=length(Q)/k; %���������� ����
hour_mean=zeros(k,1);
for i=1:k
    for j=0:days-1
        hour_mean(i)=hour_mean(i)+d_Q(j*k+i);
    end
        hour_mean(i)=hour_mean(i)./days;
end
period_mean=zeros(length(d_Q),1);
l=1;
for i=1:length(d_Q)
    period_mean(i)= hour_mean(l);
    if l==12
       l=0;
    end  
    l=l+1;
end
m=d_Q-period_mean;
figure
autocorr(m,100);
title('������� �������� ��� ������� ����');
%� ���������� ������� ������ ��� ������� �� ����������� ����������


%(�)���������� � ������������� ���� ����������� ������������� (��������)
%���������
d_k_Q=[];
for i=13:1:length(d_Q)
    d_k_Q(i)=d_Q(i)-d_Q(i-12);
end

figure
autocorr(d_k_Q,100);
title('�������� ��������');
[std(e12) std(e2) std(m) std(d_k_Q)]

%�� �������� �������������� �������� ����� ������� �����, ��� ������ (�) �
%(�) ����� ������ ���������������. ����� ��������� � ������ ���� �������,
%��� ��� ��� ���� ���������� ����������


