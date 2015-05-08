function [y] = AheadGJR(NbrSim,Data,theta,P,Q,Dist)

switch(Dist)
    case 'Normal'
        a0 = theta(1);
        a = theta(2:1+P)';
        b = theta(1+P+1:1+P+Q)';
        c = theta(2+P+Q:end)';
        Innov = randn(NbrSim,1);
    case 'T'
        if theta(end) < 2
            error('degree of freedom need to be above 2')
        end
        a0 = theta(1);
        a = theta(2:1+P)';
        b = theta(1+P+1:1+P+Q)';
        c = theta(2+P+Q:end-1)';
        Innov = sqrt((theta(end)-2)/theta(end)).*trnd(theta(end),NbrSim,1);
    case 'SKT'
        if theta(end-1) < 2
            error('degree of freedom need to be above 2')  
        end
        a0 = theta(1);
        a = theta(2:1+P)';
        b = theta(1+P+1:1+P+Q)';
        c = theta(2+P+Q:end-2)';
        Innov = skewtrnd(theta(end-1),theta(end),NbrSim,1);
    otherwise
        error('Need a valid Distribution, T or Normal')
end
denom = sum(a) + sum(b)+sum(c)./2;
Start = max(P,Q);

%%% Initialize the conditional variances
sig2 = NaN(NbrSim+Start, 1);
y = NaN(NbrSim+Start, 1);
%%% Start with unconditional variancesP

sig2(1:Start) = a0 / (1 - denom);

y(1:Start) = Data(end-Start+1:end);

   
for i = 1: NbrSim
    sig2(i+Start) = a0 +  sum(a.*sig2(i:P-1+i)) + sum(b.*y(i:Q-1+i).^2) + sum(c.*y(i:Q-1+i).^2.*[y(i:Q-1+i)<0]);
    y(i+Start) = sqrt(sig2(i+Start-1)).*Innov(i+Start-1); 
end
    y = y(Start+1:end);
end
