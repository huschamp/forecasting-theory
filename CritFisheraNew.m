function X = CritFisheraNew(X,x,y,s,alpha,index1)
X2=X;
n=length(x);
%%%%%%%%%%
m=length(X(1,:));
% M=[];
l=length(index1);
index1=sort(index1);
for k=l:-1:1
    X(:,index1(k))=[];
end;
    [s1,sigma,rr22,e,S2,y11]=regressOpt(X,y);
    F=((s1-s)/l)/(s/(n-m));
    Fish=finv(alpha,l,n-m);
    if F<Fish
        disp('Факторы')
        disp(index1)
        disp('незначимы')

    else
        disp('Факторы')
        disp(index1)
        disp('значимы')
        X=X2;
        %All=1;
    end;
