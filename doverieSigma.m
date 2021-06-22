function  [left,right]=doverieSigma(X,S)
n=size(X,1);
m=size(X,2);
alpha=0.05;
Zl=norminv(1-alpha/2);
Zr=norminv(alpha/2);
left=S/(Zl*sqrt(2*n-2*m)+n-m);
right=S/(Zr*sqrt(2*n-2*m)+n-m);