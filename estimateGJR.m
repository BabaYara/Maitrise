function [theta,ncVol,NLL] = estimateGJR(y,P,Q,Dist)

switch Dist
        case 'Normal'
        theta0 = [var(y), repmat(0.1,1,P),repmat(0.05,1,2*Q)];
        LB     = [0,zeros(1,P), zeros(1,Q),zeros(1,Q)];
        UB     = [inf,ones(1,P),ones(1,2*Q)];
        A      = [0, ones(1,P), ones(1,Q),0.5*ones(1,Q)];
        
    case 'T'
        theta0 = [var(y), repmat(0.1,1,P),repmat(0.05,1,2*Q),5];
        LB     = [0,zeros(1,P), zeros(1,Q),zeros(1,Q),2];
        UB     = [inf,ones(1,P),ones(1,2*Q),inf];
        A      = [0, ones(1,P), ones(1,Q),0.5*ones(1,Q),0]; 
        
    case 'SKT'    
        theta0 = [var(y), repmat(0.1,1,P),repmat(0.05,1,2*Q),5,0];
        LB     = [0,zeros(1,P), zeros(1,Q),zeros(1,Q),2,-1];
        UB    =  [inf,ones(1,P),ones(1,2*Q),300,1];
        A      = [0, ones(1,P), ones(1,Q),0.5*ones(1,Q),0,0];
    otherwise
         error('No distribution selected, Normal, T or SKT')
end

B = 1;

options = optimset('Algorithm', 'interior-point', 'MaxFunEvals', 10000, 'Display', 'off');
[theta, ~, exitflag] = fmincon(@(x)nllGJR(y,x,P,Q,Dist), theta0, A, B, [], [], LB,UB, [], options);



a0 = theta(1);
a = theta(2:1+P)';
b = theta(1+P+1:1+P+Q)';
c = theta(2+P+Q:end)';

ncVol = a0/(sum(a) + sum(b)+sum(c)./2);
NLL = nllGJR(y,theta,P,Q,Dist);


end

