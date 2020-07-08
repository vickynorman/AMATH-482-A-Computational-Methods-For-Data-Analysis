M = csvread('train.csv',1,0);
digit = M(:,1);
X = M(:,2:end)';
[nr nc ] = size(X);

Train = X(:,1:24723);
Test = X(:,24724:end);

label = zeros(length(digit),10);
for i =1:length(digit)
   label(i,digit(i)+1)=1;
end
label=label';
labelTr = label(:,1:24723);
labelT = label(:,24724:end);



net = patternnet(10);
% transferFcn = 'tansig';
% transferFcn = 'logsig';
transferFcn = 'ReLU';


net = train(net,Train,labelTr); 
view(net)

y=net(Test);
perform(net,labelTr,net(Train))

%%

digres = zeros(1000,1);
for j = 1:1000
   digres(j) = find(y(:,j)==max(y(:,j)))-1;
end


100*sum(digres==digit(24724:end))/length(digres)