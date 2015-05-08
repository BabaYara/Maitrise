function [probGJR] = CalcProb(CondData,Range,listcondition)
l = length(listcondition);

    T = length(CondData.Date);
    prob=zeros(T,l); 
    probGJR= nan(length(Range),l);
    for i = 1:l
        Cond = eval(char(listcondition(i)));
        prob(Cond,i)= 1;
    
        for j = 1: length(Range)

            probGJR(j,i) = sum(prob(Range(j,1):Range(j,2),i));
    
        end
    
    probGJR(:,i) = probGJR(:,i)/sum(probGJR(:,i));
    
    end
    