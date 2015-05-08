function [simOptionprice] = SimulateVoption(riskfree,options,Oportfolio,StockData,CondData,Stocksim,VixShift)
    CriskFree = riskfree.current;
    triskFree = riskfree.tau;

    Call = options.calls;         
    Put = options.puts;            

    Sig = CondData.Price(end)/100;
    S = StockData.Price(end,2);
    K = [Call(:,1);Put(:,1)]';
    m = K'./S;                                           %Monneyness
    imp = [Call(:,4);Put(:,4)];
    t4 = [Call(:,2);Put(:,2)];
    x = [ones(length(imp),1),(m-1).^2,(m-1).^3,sqrt(t4)]; 

    optionSimul = Oportfolio;    %New option Portfolio parameter
    nbDay = 1;               %days in Simulation
    optionSimul.TimeRemaining = Oportfolio.TimeRemaining - nbDay;     %ajusting time
    optionSimul.TimeRemainingPerc = optionSimul.TimeRemaining/250;%ajusting time

    ORiskFreeSimul = interp1q(triskFree,CriskFree,optionSimul.TimeRemainingPerc')'; %new risk free

    %Regressing Observed Implied vol with x

    Alpha = regress(imp,x);


    %%%Calulating Porfolio value at T=0 with Surface
    c0 = Sig - (Alpha(1)+Alpha(4)); % Offset for surface T=0

    %Calculating Options Implied Vol
    shift =  VixShift + c0;


    for j = 1:length(shift)
    OptionImpSigt1(j,:) = EvalModel(Alpha',Stocksim(j,2),optionSimul.Strike,optionSimul.TimeRemainingPerc)+...
                    repmat(shift(j),1,length(Oportfolio.Strike));

    simOptionprice(j,:) = Blackscholes(optionSimul.Type,Stocksim(j,2),optionSimul.Strike,...
                                    OptionImpSigt1(j,:),optionSimul.TimeRemainingPerc,ORiskFreeSimul);              
    end
end            
