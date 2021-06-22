function []=CritGold(X,x,e)
    alpha=0.05;
    n=length(x);
    m=length(X(1,:));
    len=fix(3*n/8);
    
    EforSort=[e X];
    for l=4:m+1
        %l=4
        if l==5
            break;
        end;
        EforSort=sortrows(EforSort,l);
        e1=EforSort(1:len,1);
        e2=EforSort(n-len:n,1);
        
        X_vsp=[x.^0, x, x.*x];
        for i=1:length(x(1,:))
            for j=1:length(x(1,:))
                if i~=j
                    X_vsp=[X_vsp,x(:,i).*x(:,j)];
                end;
            end;
        end;
        X_vsp=X_vsp';
        X_vsp=unique(X_vsp,'rows')';

        [s2_vsp1,sigma2_vsp1,r2_vsp1,e_vsp1,S_vsp,y1_vsp1]=regressOpt(X_vsp(1:len,:),e1.^2);
        [s2_vsp2,sigma2_vsp2,r2_vsp2,e_vsp2,S_vsp,y1_vsp2]=regressOpt(X_vsp(n-len:n,:),e2.^2);
        n_vsp=length(X_vsp(:,1));
        m_vsp=length(X_vsp(1,:));

        S1=s2_vsp1;
        S2=s2_vsp2;
        n1=len;
        n2=len;

        %S0 = (e.^2-mean(e.^2))'*(e.^2-mean(e.^2));

        qF = (S1/(n1-m)/(S2/(n2-m)));

        if qF<finv(1-alpha, n1-m, n2-m)
            disp('Дисперсия ошибок постоянная по критерию Голдфелда - Куандта')
        else
            disp('Дисперсия ошибок не постоянная по критерию Голдфелда - Куандта')
        end;
end