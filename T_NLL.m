function NLL = T_NLL(y,mean,sig2,fd)
%%%Calculate the negative log-likelihood from a Student-T distribution
% INPUTS
%   X       : [vector] [Size : Qx1] vector of random variable
%   theta   : [vector] [Size : 1x3] Parameters
%       theta(1): Mean
%       theta(2): Standard deviation
%       theta(3): Degree of freedom
% OUTPUTS
%   NLL     : Negative log-likelihood

    nobs = length(y);
    if length(sig2)>1
    sig2 = sig2(1:nobs);
    end
    term1 = nobs*(log(gamma((fd+1)/2)/(sqrt(pi()*(fd-2))*gamma(fd/2))));
    term2 = 1/2.*sum(log(sig2));
    term3 = ((fd+1)/2) * sum(log(1+(((y-mean).^2)./(sig2.*(fd-2)))));
    LL = term1 - term2 - term3;
    NLL = -LL;
    
end
