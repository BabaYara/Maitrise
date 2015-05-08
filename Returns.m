function [Ret] = Returns(X,Type)
%Calculate Various Return
%  X = Matrix of stock price
%    
switch(Type)
    case 1 
        Ret = log(X(2:end,:))- log(X(1:end-1,:))  ;
        
    case 2 
        Ret = (X(2:end,:) - (X(1:end-1,:)))./(X(2:end-1,:));
        
    otherwise
        warning('Wrong Type, 0 for logReturn, 1 for arithmetic return')
end

