function [StockData,CondData] = fetchData(Ticker,Condticker,StartDate,EndDate)
%change this line for other distributor
c = yahoo;

for i = 1:length(Ticker)
    %change this line for other distributor
    tmp = flipud(fetch(c,Ticker(i),'Close',StartDate,EndDate));
    StockData.Date = tmp(:,1);
    StockData.Price(:,i) =  tmp(:,2);
    StockData.LogretDate = StockData.Date(2:end);
    StockData.Logret(:,i) = Returns(StockData.Price(:,i),1);
end
StockData.Ticker = Ticker;
tmp = [];

for i = 1:length(Condticker)
    %change this line for other distributor
    tmp = flipud(fetch(c,Condticker(i),'Close',StartDate,EndDate));
    CondData.Date = tmp(:,1);
    CondData.Price(:,i) =  tmp(:,2);
    CondData.LogretDate = CondData.Date(2:end);
    CondData.Logret(:,i) = Returns(CondData.Price(:,i),1);
end
CondData.Ticker = Ticker;

end