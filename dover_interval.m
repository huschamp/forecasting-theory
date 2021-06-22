function BETA=dover_interval(X,sigma2,y)
V=inv(X'*X);
b=(X'*X)\(X'*y);
alpha=0.05;
n=size(X,1);
m=size(X,2);
BETA=[];
for j=1:size(X,2)
    g=0;
    delta=tinv(1-alpha/2,n-m)*sqrt(sigma2)*sqrt(V(j,j));
    d=num2str(delta);
    disp(delta)
    for i=1:length(d)
        if (d(i)~='0') && (d(i)~='.')
            disp(d(i))
            nn=i-g-1;
            if g==0
                nn=-nn;
            end;
            break;
        end;
                if d(i)=='.'
                    g=1;
                end;
    end;
    BETA=[BETA vpa(round(b(j),nn),10)];
    disp('Доверительный интервал для beta №');disp(vpa(round(b(j),nn),10));disp([b(j)-delta b(j)+delta])
end;