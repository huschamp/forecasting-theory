clc
clear all
warning('off')
data=readtable('Data1.xlsx');
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
[s22,sigma2,r2,S,y1]=regressOpt(X{i},x,y,0.95);
R2=[R2 r2];
end;
[Opt j]=max(R2);
[s22,sigma2,r2,S,y1]=regressOpt(X{j},x,y,0.95);
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


[s22,sigma2,rr2,SSS,y1]=regressOpt(Xopt,x,y,0.95);
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

e=y-y1;
s2=e'*e; %остаточная сумма квадратов
sigma22=s2/(size(X,1)-size(X,2));%оценка дисперсии остатков
r22=(1-(s2)/((y-mean(y))'*(y-mean(y))));%коэф детерминации
S=sum(e.^2)/length(e);

figure('Name','BETA')
plot(x,y1,'-r',x,y,'.b',xx,yy1,'-k')