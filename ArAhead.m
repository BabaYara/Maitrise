function [sim] = ArAhead(Data,Beta,Const,std,rand)

Innov = norminv(rand,0,std);
Start = length(Beta);




   
for i = 1: 1
    sim(i) = Const + Beta(1:end)*flipud(Data(end-Start+1:end)) + Innov; 
end

end
