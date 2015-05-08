function [Sim,rand] = SimulateARMVCond(nbrsimulTotal,Data,probGJR,Copulaparams,Arparams,rndsup,rand,start)


for q = 1:size(probGJR,2)
    h=0;
    for i = 1:length(probGJR(:,q))
        s = round(probGJR(i,q)*nbrsimulTotal);
        if s == 0 
            continue
        end
        for j = 1:s
            if rndsup == 0
            rand(q).rnd(h+j,:) = copularnd(Copulaparams(i).Type,Copulaparams(i).params,1);
            end
            for k = 1:length(GJRparams)
                Sim(q).SimulatedData(h+j,k) = ArAhead(Data(:,k), Arparams(k),rand(q).rnd(h+j,start));
            end
        end
        h = h+s;
    end
    Sim(q).ProbGJR = probGJR(:,q);
    
end
end