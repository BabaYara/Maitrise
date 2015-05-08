
function Randomsstd = Rsstd(n, mean, sd, nu, xi)
%%%Generate random deviates from the skewed Student-t distribution
% INPUTS
%   n       : [scalar] [Size : 1x1] number of random variable to be create
%   mean: [scalar] [Size : 1x1] Mean
%   sd: [scalar] [Size : 1x1] Standard deviation
%   nu: [scalar] [Size : 1x1] Scale parameter(degree of freedom)
%   xi: [scalar] [Size : 1x1] Skew parameter
%   
% OUTPUTS
%   Randomsstd : [Vector] [Size : nx1] 
% A function implemented by Diethelm Wuertz in R
% Converted in Matlab by Keven Bluteau
    % A function implemented by Diethelm Wuertz


    % Shift and Scale:
    Randomsstd = irsstd(n ,nu, xi) * sd + mean;

     

end

function Randomsstd = irsstd(n, nu, xi)
    %   Internal Function

   
    beta = @(a, b) exp(gammaln(a) + gammaln(b) - gammaln(a+b));

    %Generate Random Deviates:
    weight = xi / (xi + 1/xi);
    z = unifrnd(-weight,1-weight ,n,1);
    Xi = xi.^sign(z);
    Randomsstd = -abs(trnd(nu,n,1))./Xi .* sign(z);

    %Scale:
    m1 = 2 * sqrt(nu-2) / (nu-1) / beta(1/2, nu/2);
    mu = m1*(xi-1/xi);
    sigma =  sqrt((1-m1^2).*(xi^2+1./xi^2) + 2*m1^2 - 1);
    Randomsstd = (Randomsstd - mu ) ./ sigma;
    
 end
    