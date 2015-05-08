function [impSig] = EvalModel( Alpha,S,K,t )
m = repmat(K,length(S),1)./repmat(S,1,length(K));
t = repmat(t,length(S),1);
impSig = Alpha(1) + Alpha(2).*(m-1).^2 + Alpha(3).*(m-1).^3 + Alpha(4).*sqrt(t);

end

