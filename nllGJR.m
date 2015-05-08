function [NLL] = nllGJR(y,theta,P,Q,Dist)
nobs = length(y);

 switch(Dist)
    case 'Normal'
        sig2 =  ComputeGJR(y,theta(1:end),P,Q);
        sig2 = sig2(1:nobs);
        NLL = Norm_NLL(y,0,sig2);
        
    case 'T'
        sig2 =  ComputeGJR(y,theta(1:end-1),P,Q);
        sig2 = sig2(1:nobs);
        NLL = T_NLL(y,0,sig2,theta(end)); 
        
    case 'SKT'
       sig2 =  ComputeGJR(y,theta(1:end-2),P,Q);
       sig2 = sig2(1:nobs);
       NLL = SKT_NLL(y,0,sig2,theta(end-1),theta(end)); 
     otherwise
         error('No distribution selected, Normal, T or SKT')
 end
end