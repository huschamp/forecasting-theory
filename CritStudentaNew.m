function [Xopt, index1,tnm,t,stats,q] = CritStudentaNew(X,x,y,sigma,alpha,index1)

n=length(x);
%%%%%%%%%%
m=length(X(1,:));
%tnm=tinv(alpha,(n-m));
b=(X'*X)\(X'*y);
C=sigma*inv(X'*X);
t=[];
tnm = tinv(1-alpha/2, n-m);
for i=1:length(b)
    t=[t b(i)/sqrt(C(i,i))];
end;
[beta,dfe,stats]=glmfit(X,y);
%%%%%%%%%%%%%%%%%% СТЬЮДЕНТ
[t1 index]=min(abs(t));
if (t1<tnm) && (t1>-tnm)
    %disp(index);
    disp('Незначим');
    if index>=min(index1)
        index1=[index1 index+length(index1)];
    else
        index1=[index1 index];
    end;
    if length(index1)==1
        disp(index1(1))
    else
        disp(index1(2))
    end;
    Xopt=X;
    Xopt(:,index)=[];
    q=0;
%     disp('Все значимы');
%     Xopt=X;
%     index1=[];
else
%         disp(index);
%     disp('Незначим');
%     if index>=min(index1)
%         index1=[index1 index+length(index1)];
%     else
%         index1=[index1 index];
%     end;
%     Xopt=X;
%     Xopt(:,index)=[];
    disp('Все значимы');
    Xopt=X;
    index1=[];
    q=1;
end;
