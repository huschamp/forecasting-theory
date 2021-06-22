clc
clear all
close all
warning('off')
% 2.Давление в абсорбере
%P = xlsread('TimeSeries.xls', 'Давление в абсорбере', 'A3:A902');
P = readtable('TimeSeriesP.xlsx')
P=table2array(P)
T(1)=1;
for t = 2:length(P)
    T(t) = T(t-1)+4;
end
%разность давлений

d_P=[0 diff(P)']';
figure
autocorr(d_P, 100);%ACF
title('ACF');
figure
parcorr(d_P, 100,6);%PACF
title('PACF');

p=6; %с. 104

%методом МНК оценим коэф AR(p-1), AR(p), A(p+1)
%формулы для Х и у из презентации 6 стр. 15

 % модель AR(p-1)
p1=p-1;
n = length(d_P);
X = zeros(n-p1, p1);
for i=1:n-p1
    y(i)=d_P(i+p1);
    for j=1:p1
        X(i,j)=d_P(i+p1-j);
    end
end

% модель AR(p)
X1 = zeros(n-p, p);
for i=1:n-p
    y1(i)=d_P(i+p);
    for j=1:p
        X1(i,j)=d_P(i+p-j);
    end
end

% модель AR(p+1)
p2=p+1;
X2 = zeros(n-p2, p2);
for i=1:n-p2
    y2(i)=d_P(i+p2);
    for j=1:p2
        X2(i,j)=d_P(i+p2-j);
    end
end

%%


[b,s2,sigma2,r2,e,S,y11]=regressOpt(X,y');

[b1,s2,sigma21,r2,e1,S,y11]=regressOpt(X1,y1');

[b2,s2,sigma22,r2,e2,S,y11]=regressOpt(X2,y2');


%так как остатки уже были найдены выше, построим их ACF и оценим дисперсии
figure
autocorr(e, 100);
title('МНК AR(p-1)');

figure
autocorr(e1, 100);
title('МНК AR(p)');

figure
autocorr(e2, 100);
title('МНК AR(p+1)');

%дисперсии
sigma2 %дисперсия AR(p-1)
sigma21 %дисперсия AR(p)
sigma22  %дисперсия AR(p+1)

%ацф похожи, потому сложно анализировать
%но можно сравнить дисперсии
%у модели А(р+1) наименьшая, можно сделать вывод, что эта модель подходит
%лучше



%построим прогноз с упреждением в 10 минут
nn=length(T);
TT(1)=T(nn);
for i = 1:150
    TT(i+1) = TT(i)+4;   
end

for i=nn+1:nn+150
    d_P(i) = b2(1)*d_P(i-1)+b2(2)*d_P(i-2)+b2(3)*d_P(i-3)+b2(4)*d_P(i-4)+b2(5)*d_P(i-5)+b2(6)*d_P(i-6)+b2(7)*d_P(i-7);
    P(i) = P(i-1) + d_P(i);
end

figure
hold on
plot(TT(1:length(TT)),P(nn:nn+150),'r');% прогноз
plot(T,P(1:nn),'b');%исходные значения
