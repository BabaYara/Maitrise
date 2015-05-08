function [y] = SimulateGJR(NbrSim,theta,P,Q,Dist,xtraParam)

a0 = theta(1);
a = theta(2:1+P)';
b = theta(1+P+1:1+P+Q)';
c = theta(2+P+Q:end)';

denom = sum(a) + sum(b)+sum(c)./2;
Start = max(P,Q);

%%% Initialize the conditional variances
sig2 = NaN(NbrSim+Start, 1);
y = NaN(NbrSim+Start, 1);
%%% Start with unconditional variancesP

sig2(1:Start) = a0 / (1 - denom);

switch(Dist)
    case 'Normal'
        Innov = randn(NbrSim,1);
    case 'T'
        if xtraParam(1) < 2
            error('degree of freedom need to be above 2')
        end
        Innov = sqrt((xtraParam -2)/xtraParam).*trnd(xtraParam,NbrSim,1);
    case 'SKT'
        if xtraParam(1) < 2
            error('degree of freedom need to be above 2')
            
        end
        Innov = skewtrnd(xtraParam(1),xtraParam(2),NbrSim,1);
    otherwise
        error('Need a valid Distribution, T or Normal')
end

y(1:Start) = sqrt(sig2(1:Start)).*Innov(1:Start);   


for i = 1: NbrSim
    sig2(i+Start) = a0 +  sum(a.*sig2(i:P-1+i)) + sum(b.*y(i:Q-1+i).^2) + sum(c.*y(i:Q-1+i).^2.*[y(i:Q-1+i)<0]);
    y(i+Start) = sqrt(sig2(i+Start)).*Innov(i+Start); 
end

end
