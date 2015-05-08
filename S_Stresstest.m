clc,clear
tic()
Ticker =  {'IBM';'^GSPC'};
Condticker = {'^VIX'};
StartDate ='01/01/02';
EndDate = '12/31/14';


[StockData,CondData] = fetchData(Ticker,Condticker,StartDate,EndDate);
load('Data.mat');  
HriskFree = data.riskfree.history;  %Historical Risk Free
CriskFree = data.riskfree.current;  %Current Risk Free
triskFree = data.riskfree.tau;

Option = struct('Strike',[1600,1650,1750,1800],'TimeRemaining',[20,20,40,40],'Type',[0,0,1,1]);
Option.TimeRemainingPerc = Option.TimeRemaining/250;
Option.Price =  SimulateVoption(data.riskfree,data.options,Option,StockData,CondData,StockData.Price(end,:),0);

%for 1000 rolling window parameter GSPC P = 1 Q = 1 sep = 1
%load(fullfile('DATA', 'GSPC','1000','Range.mat')); 
%GJRparams(1).skew = load(fullfile('DATA', 'GSPC','1000','GJRPARAMSSKEW.mat'));
%GJRparams(1).normal= load(fullfile('DATA','GSPC','1000','GJRPARAMSNORMAL.mat')); 
%GJRparams(1).T = load(fullfile('DATA', 'GSPC','1000','GJRPARAMST.mat'));
% 
% % for 1000 rolling window parameter IBM P = 1 Q = 1 sep = 1
%load(fullfile('DATA', 'IBM','1000','RANGE.mat')); 
%GJRparams(2).skew = load(fullfile('DATA', 'IBM','1000','IBMGJRSKEW.mat')); 
%GJRparams(2).normal =  load(fullfile('DATA', 'IBM','1000','IBMGJRNORMAL.mat')); 
%GJRparams(2).T =  load(fullfile('DATA', 'IBM','1000','IBMGJRT.mat'));

% % for 500 rolling window parameter IBM P = 1 Q = 1 sep = 1
% load(fullfile('DATA', 'IBM','500','RANGE.mat')); 
% GJRparams(1).skew = load(fullfile('DATA', 'IBM','500','GJRPARAMSSKEW.mat')); 
% GJRparams(1).normal= load(fullfile('DATA', 'IBM','500','GJRPARAMSNORMAL.mat')); 
% GJRparams(1).T = load(fullfile('DATA', 'IBM','500','GJRPARAMST.mat'));
% 
% % for 500 rolling window parameter P = 1 Q = 1 sep = 1
% load(fullfile('DATA', 'GSPC','500','RANGE.mat')); 
% GJRparams(2).skew =load(fullfile('DATA', 'GSPC','500','GJRPARAMSSKEW.mat'));
% GJRparams(2).normal=  load(fullfile('DATA', 'GSPC','500','GJRPARAMSNORMAL.mat')); 
% GJRparams(2).T = load(fullfile('DATA', 'GSPC','500','GJRPARAMST.mat'));

P = 1;
Q = 1;
Window = 500;
Sep = 5;

for i = 1:length(Ticker)
GJRparams(i).TrainingData = StockData.Logret(:,i);
GJRparams(i).Ticker = StockData.Ticker(i);
GJRparams(i).P = P;
GJRparams(i).Sep = Sep;
GJRparams(i).Q = Q;
GJRparams(i).Window = Window;
GJRparams(i).Dist = 'SKT';
[GJRparams(i).Params,GJRparams(i).Range] = RollingGJR(StockData.Logret(:,i),GJRparams(i).Window,...
                                    GJRparams(i).Sep,GJRparams(i).P,GJRparams(i).Q,...
                                    GJRparams(i).Dist);
Range = GJRparams(i).Range;                                
GJRparams(i).Date = StockData.LogretDate(Range(:,2));
end
[ARParams(1).Params,ARParams(1).Errors,ARParams(1).Sereg,ARParams(1).Diag] = RollingHAR(log(CondData.Price(2:end)),[1,5,10,22,66]',Sep,Window);
Copulaparams = RollingCopula(StockData.Logret,'Gaussian',Sep,Window,ARParams(1));


listCondition = {'CondData.Price(2:end,1)>=35',...
                'CondData.Price(2:end,1)>=30',...
                'CondData.Price(2:end,1)>=25',...
                'CondData.Price(2:end,1)>=20',...
                'CondData.Price(2:end,1)>=15',...
                'CondData.Price(2:end,1)>=10',...
                'CondData.Price(2:end,1)>30 & CondData.Price(2:end,1)<=35',...
                'CondData.Price(2:end,1)>25 & CondData.Price(2:end,1)<=30',...
                'CondData.Price(2:end,1)>20 & CondData.Price(2:end,1)<=25',...
                'CondData.Price(2:end,1)>15 & CondData.Price(2:end,1)<=20',...
                'CondData.Price(2:end,1)>10 & CondData.Price(2:end,1)<=15',...
                'CondData.Price(2:end,1)>30 & CondData.Price(2:end,1)<=40'...
                'CondData.Price(2:end,1)>20 & CondData.Price(2:end,1)<=30',...
                'CondData.Price(2:end,1)>10 & CondData.Price(2:end,1)<=20'};
                
                
                
probGJR = CalcProb(CondData,Range,listCondition);   

%for i = 1:length(probGJR)
    %s = round(probGJR(i)*nbrsimulTotal);
   % if s == 0 
  %      continue
 %   end  
%for j = 1:s
   % SimulatedData(h+j) = AheadGJR(1,Logret(:,2),GJRparams(1).skew.GJRparamsskew(i,2:end),1,1,'SKT');
  % end
 %   h = h+s;
%end


nbrsimulTotal = 10000;
%Simualte return for each probGJR

Data = [StockData.Logret,log(CondData.Price(2:end))];
[GJRSim,ARSim, rnd] = SimulateMVCond(nbrsimulTotal,Data,probGJR,Copulaparams,GJRparams,ARParams,0,[]);

sim = length(listCondition);

result = [];

parfor i = 1:sim
Portfolio(i).QuantityStock = [0;0];
Portfolio(i).QuantityOption = [1;1;1;1];
Portfolio(i).StockTicker = StockData.Ticker;
Portfolio(i).Option = Option
Portfolio(i).Condition = listCondition(i);
Portfolio(i).ProbGJR = probGJR(:,i);
VixShift(i).shift = (exp(ARSim(i).SimulatedData)- CondData(1).Price(end))/100;


Portfolio(i).InitValue = StockData.Price(end,:)*Portfolio(i).QuantityStock + Portfolio(i).Option.Price(end,:)*Portfolio(i).QuantityOption;

Stocksim(i).NextPrice = repmat(StockData.Price(end,:),size(GJRSim(i).SimulatedData,1),1).*exp(GJRSim(i).SimulatedData);
Optionsim(i).Nextprice = SimulateVoption(data.riskfree,data.options,Portfolio(i).Option,StockData,CondData,Stocksim(i).NextPrice ,VixShift(i).shift);
Portfolio(i).NextValue = Stocksim(i).NextPrice*Portfolio(i).QuantityStock + Optionsim(i).Nextprice*Portfolio(i).QuantityOption;

Portfolio(i).NextLoss = Portfolio(i).NextValue - Portfolio(i).InitValue ;

Portfolio(i).SVAR95 = quantile(Portfolio(i).NextLoss,0.05);
Portfolio(i).SVAR99 = quantile(Portfolio(i).NextLoss,0.01);
Portfolio(i).SVAR999 = quantile(Portfolio(i).NextLoss,0.001);

Portfolio(i).SES95 = sum(Portfolio(i).NextLoss(Portfolio(i).NextLoss<=Portfolio(i).SVAR95))/sum(Portfolio(i).NextLoss<=Portfolio(i).SVAR95);
Portfolio(i).SES99 = sum(Portfolio(i).NextLoss(Portfolio(i).NextLoss<=Portfolio(i).SVAR99))/sum(Portfolio(i).NextLoss<=Portfolio(i).SVAR99);
Portfolio(i).SES999 = sum(Portfolio(i).NextLoss(Portfolio(i).NextLoss<=Portfolio(i).SVAR999))/sum(Portfolio(i).NextLoss<=Portfolio(i).SVAR999);

end

DATASET.portfolio = Portfolio;
DATASET.StockData = StockData;
DATASET.CondData  = CondData;
DATASET.GJR = GJRparams;
DATASET.Range = Range;
DATASET.CopulaParams = Copulaparams;

result = [Portfolio.SVAR95;Portfolio.SVAR99;Portfolio.SVAR999;Portfolio.SES95;Portfolio.SES99;Portfolio.SES999];
toc()


    %SVaR95 = quantile(SimulatedData,0.05)
    %SVaR99 = quantile(SimulatedData,0.01)
    %SVaR999 = quantile(SimulatedData,0.00001)
    %SES95 = sum(SimulatedData(SimulatedData<=SVaR95))/sum(SimulatedData<=SVaR95)
    %SES99 = sum(SimulatedData(SimulatedData<=SVaR99))/sum(SimulatedData<=SVaR99)
   %SES999 = sum(SimulatedData(SimulatedData<=SVaR999))/sum(SimulatedData<=SVaR999)
    
    %sum(Logret(:,2)<SVaR95)/length(Logret(:,2))
    %sum(Logret(:,2)<SVaR99)/length(Logret(:,2))
    %sum(Logret(:,2)<SVaR999)/length(Logret(:,2))
%     
%     FGJRparamsSkew = estimateGJR(Logret(:,2),1,1,'SKT');
%      FGJRparamsNormal = estimateGJR(Logret(:,2),1,1,'Normal');
%     FGJRparamsT = estimateGJR(Logret(:,2),1,1,'T');
%      FGJRparamsSkew2 = estimateGJR(Logret2(:,2),1,1,'SKT');
%      FGJRparamsNormal2 = estimateGJR(Logret2(:,2),1,1,'Normal');
%      FGJRparamsT2 = estimateGJR(Logret2(:,2),1,1,'T');
%      FCopparams = RollingCopula(data,'Gaussian',1,3272);
%     sim = 10000
%      for i = 1:sim
%      rnd = copularnd('gaussian',FCopparams.params,1);    
%      FSimulatedData(i,1) = mvnAheadGJR(Logret(:,2),FGJRparamsT,1,1,'T',rnd(1));
%      FSimulatedData(i,2) = mvnAheadGJR(Logret2(:,2),FGJRparamsT,1,1,'T',rnd(2));
%      end
% 
% 
%  FSimNextPrice = repmat(lprice,sim,1).*exp(FSimulatedData);
%  FNextPValue = FSimNextPrice*InitQ;
%  FLoss= FNextPValue- InitPValue;
%  
%  FSVaR95 = quantile(FLoss,0.05)
%  FSVaR99 = quantile(FLoss,0.01)
%  FSVaR999 = quantile(FLoss,0.001)
% 
%  FMVSES95 = sum(FLoss(FLoss<=FSVaR95))/sum(FLoss<=FSVaR95);
%  FMVSES99 = sum(FLoss(FLoss<=FSVaR99))/sum(FLoss<=FSVaR99);
%  FMVSES999 = sum(FLoss(FLoss<=FSVaR999))/sum(FLoss<=FSVaR999);

%FsimualtedDataNormal = AheadGJR(100000,Logret(:,2),FGJRparamsNormal(i,2:end-2),1,1,'SKT',FGJRparamsNormal(i,end-1:end));
%FsimualtedDataT = AheadGJR(100000,Logret(:,2),FGJRparamsT(i,2:end-2),1,1,'SKT',FGJRparamsT(i,end-1:end));