function  [left,right]=doverieShirok(X,y1,sigma)
n=size(X,1);
m=size(X,2);
alpha=0.05;
t=tinv(1-alpha/2,n-m);
delta=[];
for i=1:n
    x=X(i,:)';
    delta=[delta t*sqrt(sigma)*sqrt(x'*inv(X'*X)*x+1)];
end;
for i=1:n
    left(i)=y1(i)-delta(i);
    right(i)=y1(i)+delta(i);   
end;
