function [Copparams] = RollingCopula(Data,Type,sep,window,Data2)

nbData2 = size(Data2,1);

if isequal(Data2,1) 
    nbData2 = 0;
end

nind = size(Data,2);
nobs = size(Data,1);
inx = 1:window;
M = zeros(nind,nind);


effectiveobs = (floor((nobs-window)/sep)*sep)+window;
llimit = nobs-effectiveobs+1;

if llimit == 0 
    llimit = sep;
end


l = llimit:sep:(nobs-window)+1;
u = l-1+window;
Copparams(length(l)).params = M;
Copparams(length(l)).range  = [0,0];

for i = 1:length(l)
    Copparams(i).range = [l(i),u(i)];
end

    for i = 1:length(l)

        for j = 1:nind
             sData = [Data(Copparams(i).range(1):Copparams(i).range(2),j),inx'];
             sData = sortrows(sData,1);
             [F,X] = ecdf(Data(Copparams(i).range(1):Copparams(i).range(2),j));
             c = interp1(X(2:end),F(2:end),sData(:,1));
             c = [sData(:,2),c];
             c = sortrows(c,1);
             Copparams(i).U(:,j) = c(:,2);
        end
        
        for j = 1:nbData2
             sData = [Data2(j).Errors(i,:)',inx'];
             sData = sortrows(sData,1);
             [F,X] = ecdf(Data2(j).Errors(i,:));
             c = interp1(X(2:end),F(2:end),sData(:,1));
             c = [sData(:,2),c];
             c = sortrows(c,1);
             Copparams(i).U(:,nind+j) = c(:,2);
        end
        Copparams(i).U =  Copparams(i).U.*(window/(window+1)); 
        Copparams(i).params = copulafit(Type,Copparams(i).U);
        Copparams(i).Type = Type;
    end
end
