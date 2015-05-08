function [Theta,Errors,Sereg,Diag] = RollingHAR(y,lag,sep,window)
%ROLLINGHAR Summary of this function goes here
%   Detailed explanation goes here

nobs = length(y);

effectiveobs = (floor((nobs-window)/sep)*sep)+window;
llimit = nobs-effectiveobs+1;
if llimit == 0 
    llimit = sep;
end

l = llimit:sep:(nobs-window)+1;
u = l-1+window;
Out(length(l)).range  = [0,0];
for i = 1:length(l)
    Out(i).range = [l(i),u(i)];
end

    parfor i = 1:length(l)
        [Theta(i,:),Errors(i,:),Sereg(i,:),Diag(i,:)] = heterogeneousar(y(l(i):u(i)),0,lag);          
    end
    
    


end

