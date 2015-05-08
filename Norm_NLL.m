function [NLL] = Norm_NLL(y,mean,sig2)

%%%Calculate the log-likelihood from a Normal distribution
% INPUTS
%   data    : [vecotr] [Size : Qx1] vector of random variable
%   theta   : [vector] [Size : 1x2] Parameter
%       theta(1): Mean
%       theta(2): Standard deviation
% OUTPUTS
%   LL     : Log-likelihood

nobs = length(y);
if length(sig2)>1
sig2 = sig2(1:nobs);
end

LL = sum(-0.5*log(2*pi()) - 0.5.*log(sig2)-(y-mean).^2./(2.*sig2));
NLL = -LL;
NLL = real(NLL);
end
