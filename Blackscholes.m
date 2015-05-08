function [OPrice] = Blackscholes(Type,S,K,Sig,t,r)
    %Init
    Size = length(S);
    Size2 = length(K);
    K = repmat(K,Size,1); 
    t = repmat(t,Size,1);
    r = repmat(r,Size,1);
    S = repmat(S,1,Size2);
    if size(Sig,1)*size(Sig,2) ~= size(S,1)*size(S,2)
    Sig = repmat(Sig,Size/length(Sig),Size2);
    end
    OPrice = NaN(Size,Size2);
    
    %Calucation 
    D1 = (1./(Sig.*sqrt(t))).*(log(S./K)+(r+Sig.^2/2).*t);
    D2 = D1 - Sig.*sqrt(t);
    
    %Put or Call
for i = 1:length(Type)    
    if Type(1,i) == 1 
             OPrice(:,i) = S(:,1).*normcdf(D1(:,i)) - normcdf(D2(:,i)).*K(:,i).*exp(-r(:,i).*t(:,i));   

    elseif Type(1,i) == 0 
             OPrice(:,i) = normcdf(-D2(:,i)).*K(:,i).*exp(-r(:,i).*t(:,i)) - S(:,1).*normcdf(-D1(:,i));  

    else 
             error('type must be 1 for call or 0 for put');
             
    end         

end
