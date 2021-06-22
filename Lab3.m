clc
clear all
close all
warning('off')
%data=readtable('Data1.xlsx');
data=readtable('d1.xlsx');
x=data(:,1);
x=table2array(x);
y=data(:,2);
y=table2array(y);
n=length(x);

kt=2*(x-min(x))/(max(x)-min(x))*2*pi;
X0=[x.^0,x];
X1=[x.^0,x,x.^2,x.^3,x.^4];
X2=[x.^0,sin(kt),x,x.^2,x.^3,x.^4,x.^5];
X3=[x.^0,cos(kt),x,x.^2,x.^3,x.^4,x.^5,x.^6];
X4=[x.^0,sin(kt),cos(kt),x,x.^2,x.^3,x.^4,x.^5,x.^6,x.^7];
X5=[x.^0,tan(kt),cos(kt),x,x.^2,x.^3,x.^4,x.^5,x.^6,x.^7,x.^8];
X6=[x.^0,tan(kt),sin(kt),cos(kt),x,exp(x),exp(x.^2),exp(x.^3)];
X7=[x.^0,tan(kt),sin(kt),cos(kt),cot(kt),x,exp(x),exp(x.^2),exp(x.^3),x.^2,x.^3,x.^4];

m=size(X1,2);
X={X0,X1,X2,X3,X4,X5,X6,X7};
R2=[];
for i=1:length(X)
[s22,sigma2,r2,e,S,y1]=regressOpt(X{i},y);
R2=[R2 r2];
end;
[Opt j]=max(R2);
[s22,sigma2,r2,e,S,y1]=regressOpt(X{j},y);
% % % figure
% % %     plot(x,y-y1,'.');
%figure('Name','Лучшая в мире модель')
%draw(x,y,y1);
    
% % % combs = nchoosek(repmat([1,2,3,4,5,6,7,8,9,10,11],1,2),2);
% % % combs=sort(combs');
% % % combs=unique(combs','rows');
% % % i=1;
% % % while i~=size(combs,1) 
% % %     if combs(i,1)==combs(i,2)
% % %         combs(i,:)=[];
% % %     end;
% % %     i=i+1;
% % % end;

% Xopt1=X{j};
% [s22,sigma2,rrr2,S,y1,tnew]=regressOpt(Xopt1,x,y,0.95);
% figure('Name','Модель после отбрасывания незначимых по Фишеру фактору ')
index1=[];
Xopt=X{j};
XoptCopy=Xopt;
All=0;
while All~=1
while length(index1)<2
    [Xopt, index1,tnm,t,stats,q]=CritStudentaNew(Xopt,x,y,sigma2,0.05,index1);
    if q==1
        break;
    end;
end;
if (q==1) && length(index1)==0
    break;
end;
size1=size(Xopt,2);
Xopt=CritFisheraNew(XoptCopy,x,y,s22,0.95,index1);
if size(Xopt,2)~=size1
    All=1;
    break;
end;
%%%
XoptCopy=Xopt;
%%%
index1=[];
end;


[s22,sigma2,rr2,e,SSS,y1]=regressOpt(Xopt,y);
figure('Name','Optimal Модель ')
draw(x,y,y1);
xx=x;
yy1=y1;



[leftS,rightS]=doverieSigma(Xopt,s22);
if (sigma2 > leftS) && (sigma2 < rightS)
    disp('Сигма лежит внутри доверительного интервала')
end;
[leftU,rightU]=doverieUzk(Xopt,y1,sigma2);
figure('Name','Доверительный интервал для прогноза')
plot(x,leftU,'--r',x,rightU,'--r',x,y1,'b-',x,y,'.k')

[left,right]=doverieShirok(Xopt,y1,sigma2);
figure('Name','Доверительный интервал для отклика')
plot(x,left,'--r',x,right,'--r',x,y1,'-b',x,y,'k.')

BETA=dover_interval(Xopt,sigma2,y)

b=double(BETA)'
X=Xopt
y1=X*b;

%e=y-y1;
s2=e'*e; %остаточная сумма квадратов
sigma22=s2/(size(X,1)-size(X,2));%оценка дисперсии остатков
r22=(1-(s2)/((y-mean(y))'*(y-mean(y))));%коэф детерминации
S=sum(e.^2)/length(e);

figure('Name','BETA')
plot(x,y1,'-r',x,y,'.b',xx,yy1,'-k')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  LAB 3

% график остатков
figure('Name','График остатков')
plot(x,e,'.')

% ANOVA
EforSort=[e Xopt];
k=20;
for l=2:length(Xopt(1,:))
    E={};
    EforSort=sortrows(EforSort,l);
    for j=1:k
        E{j}=EforSort((fix(n/k)*(j-1))+1:fix(n/k)*j,1);
    end;
    %E{k}=EforSort(round(n/k)*(k-1)+1:length(Xopt(1,:)),1);
    average=mean(e);
    S0=0;
    S=0;
    for j=1:k
        sum=0;
        aver_in_group=mean(E{j});
        S0=S0+(aver_in_group-average)^2;
        for i=1:length(E{j})
            E2=E{j};
            sum=sum+(E2(i)-aver_in_group)^2;
        end;
        S=S+sum;
    end;
    m=8;
%     DSa=S0/(k-m);
%     DS=S/(n-k);
%     % Вычислим фактическое значение критерия Фишера
    F = (S0/(k-m))/(S/(n-k));
    % Чтобы провести однофакторный дисперсионный анализ данных
    %статистического комплекса, нужно найти фактическое значение Фишера
    alfa = 0.05;
    qF = finv(1-alfa, k-m, n-k);
    % % Гипотеза H0: фактор не оказывает существенного влияния на данные(все факторы 
    % %имеют одно значение средних)
    % % Гипотеза H1: фактор существенно влияет на изменение данных (не все факторы
    % %имеют одно значение средних)
    if F<qF
         disp('Математическое ожидание ошибок постоянное');
     else
         disp('Математическое ожидание ошибок не постоянное');
    end
end;

% Критерий Уайта
CritWhite(x,e)

% Критерий Голдфелда-Куандта
CritGold(X,x,e)

% Проверка отсутствия автокорреляции
figure
autocorr(e,100)

%H=lbqtest(e,'lags',100,'dof',20);
H=lbqtest(e,'lags',100,'dof',100-m);

if H==0
    disp('Согласно Q-критерию Льюнга-Бокса автокорреляция отсутсвует');
else
    disp('Согласно Q-критерию Льюнга-Бокса автокорреляция присутствует');
end;

figure
histfit(e)

figure
normplot(e)
[h, p,st]=chi2gof(e,'NParams',m+1);
%nbins-1-nparams=15-m-2
%nparams=nbins-14+m
H=chi2gof(e,'NParams',m+1)
if H==0
    disp('Согласно хи-квадрат критерию Пирсона-Фишера остатки имеют нормальное распределение')
else
    disp('Согласно хи-квадрат критерию Пирсона-Фишера остатки имеют не нормальное распределение')
end;