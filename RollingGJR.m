function [theta,range] = RollingGJR(y,window,sep,P,Q,Dist)
%ROLLINGGJR Summary of this function goes here
%   Detailed explanation goes here
nobs = length(y);

effectiveobs = (floor((nobs-window)/sep)*sep)+window;
llimit = nobs-effectiveobs+1;
if llimit == 0 
    llimit = sep;
end

l = llimit:sep:(nobs-window)+1;
u = l-1+window;
range = [l',u'];
    parfor i = 1:length(l)
        [theta(i,:)] = estimateGJR(y(l(i):u(i)),P,Q,Dist);   
    end

end

