function [sig2] = ComputeGJR(y,theta,P,Q)
%%% Function which computes the vector of conditional variance
%  INPUTS
%   theta : [vector] (3 x 1)
%   y     : [vector] (T x 1) log-returns
%  OUTPUTS 
%   sig2  : [vector] (T+1 x 1) conditional variances

%%% Extract the parameters

a0 = theta(1);
a = theta(2:1+P)';
b = theta(1+P+1:1+P+Q)';
c = theta(2+P+Q:end)';
denom = sum(a) + sum(b)+sum(c)./2;
    
Start = max(P,Q);
T = length(y);

%%% Initialize the conditional variances
sig2 = NaN(T + 1, 1);

%%% Start with unconditional variancesP
sig2(1:Start) = a0 / (1 - denom);

%%% Compute conditional variance at each step
% !!!
    for i = 1:T-Start+1
    sig2(i+Start) = a0 +  sum(a.*sig2(i:P-1+i)) + sum(b.*y(i:Q-1+i).^2) + sum(c.*y(i:Q-1+i).^2.*[y(i:Q-1+i)<0]);
    end
end