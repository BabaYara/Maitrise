function [GJRSim,ARSim,rand] = SimulateMVCond(nbrsimulTotal,Data,probGJR,Copulaparams,GJRparams,ARParams,rndsup,rand)
nbrGJR = length(GJRparams);
nbrAR = length(ARParams);

    for q = 1:size(probGJR,2)
        h=0;
        k=0;
        for i = 1:length(probGJR(:,q))
            s = round(probGJR(i,q)*nbrsimulTotal);
            if s == 0 
                continue
            end
            GJRSim(q).SimulatedData(h+1:h+s,:) = zeros(s,nbrGJR);
            ARSim(q).SimulatedData(h+1:h+s,:) = zeros(s,nbrAR);
            for j = 1:s

                if rndsup == 0
                rand(q).rnd(h+j,:) = copularnd(Copulaparams(i).Type,Copulaparams(i).params,1);

                end   

                if isequal(GJRparams,[]) == false
                    for k = 1:nbrGJR

                        GJRSim(q).SimulatedData(h+j,k) = mvnAheadGJR(Data(:,k), GJRparams(k).Params(i,:),...
                                                            GJRparams(k).P, GJRparams(k).Q,...
                                                            GJRparams(k).Dist, rand(q).rnd(h+j,k));
                    end
                end

                if isequal(ARParams,[]) == false
                    
                    for l = 1:nbrAR
                        ARSim(q).SimulatedData(h+j,l) = ArAhead(Data(:,k+l), ARParams(l).Diag(i,:).ARparameterization,...
                                                      ARParams(l).Params(i,1)*ARParams(l).Diag(i,:).C,ARParams(l).Sereg(i,:),...
                                                      rand(q).rnd(h+j,k+l));
                    end 
                end

            end
            h = h+s;
        end
        ARSim(q).ProbGJR = probGJR(:,q);
        GJRSim(q).ProbGJR = probGJR(:,q);
    end
end