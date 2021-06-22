clc;
close all;
clear all;
P = readtable('TimeSeriesP.xlsx')
P=table2array(P)
T = zeros(length(P),1);
for i = 2:length(P)
    T(i) = T(i-1)+4;
end
plot(T,P,'.');
title('Облако точек');
figure
autocorr(P,100);
title('ACF для P');%ряд нестационарный
%2
X = [T.^0, T];
[s2,sigma22,r22,e,S,y1] = regressOpt(X,P);
figure
hold on
plot(T,y1,'r');
plot(T,P,'b.');
title('Линейный тренд');
figure
autocorr(e,100); 
title('МНК');

 d_P = [];
for i = 2:length(P)
    d_P(i) = P(i)-P(i-1);
end
figure
autocorr(d_P,100);
title('Разность');
[h,pValue,stat,cValue,reg]=adftest(P,'lags',100,'model','TS','test','F')
[h1,pValue1,stat1,cValue1,reg1]=adftest(e,'lags',4,'model','TS','test','F')
[h2,pValue2,stat2,cValue2,reg2]=adftest(d_P,'lags',4,'model','TS','test','t1')
%по графикам автокорреляции остатков можно сделать вывод, что вычисление разности лучше



