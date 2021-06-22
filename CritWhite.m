function []=CritWhite(x,e)
    alpha=0.05;
    X_vsp=[x.^0, x, x.*x];
    for i=1:length(x(1,:))
        for j=1:length(x(1,:))
            if i~=j
                X_vsp=[X_vsp,x(:,i).*x(:,j)];
            end;
        end;
    end;
    %%disp(X_vsp)
    X_vsp=X_vsp';
    X_vsp=unique(X_vsp,'rows')';
    
    [s2_vsp,sigma2_vsp,r2_vsp,e_vsp,S_vsp,y1_vsp]=regressOpt(X_vsp,e.^2);
    n_vsp=length(X_vsp(:,1));
    m_vsp=length(X_vsp(1,:));
    
    X_s=[x.^0];
    [s2,sigma2,r2,e2,S,y1]=regressOpt(X_s,e.^2);
    
    S=s2_vsp;
    S0=s2;
    R2=1-S/S0;
    
    %S0 = (e.^2-mean(e.^2))'*(e.^2-mean(e.^2));
    
    qF = ((S0-S)/(m_vsp-1)/(S/(n_vsp-m_vsp)));
    qChi = n_vsp*R2;
    disp(qF)
    if qChi<chi2inv(1-alpha,m_vsp-1)
        disp('Дисперсия ошибок постоянная по Хи2')
    else
        disp('Дисперсия ошибок не постоянная по Хи2')
    end;
    
    if qF<finv(1-alpha, m_vsp-1, n_vsp-m_vsp)
        disp('Дисперсия ошибок постоянная по Фишеру')
    else
        disp('Дисперсия ошибок не постоянная по Фишеру')
    end;
    if (qChi<chi2inv(1-alpha,m_vsp-1)) && (finv(1-alpha, m_vsp-1, n_vsp-m_vsp))
        disp('Дисперсия ошибок постоянная по критерию Уайта')
    end;
end