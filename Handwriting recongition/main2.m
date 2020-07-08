trainlabel = csvread('train.csv',1,0);
test = csvread('test.csv',1,0);

%%

[m, n] = size(trainlabel);

q = randperm(m);

labels = trainlabel(:,1);

matrix_labels = zeros(10,m);

for i = 1:m
    k = labels(i);
    col = zeros(10,1);
    col(k+1) = 1;
    matrix_labels(:,i)=col;
end

train_labels = matrix_labels(1:10,q(1:24723));
test_labels = matrix_labels(1:10,q(24724:end));

x = trainlabel(q(1:24723),2:end)';
x2 = trainlabel(q(24724:end),2:end)';
%%
net = patternnet(10, 'trainscg');

%%
% net.layers{1}.transferFcn = 'compet';
% net.layers{1}.transferFcn = 'elliotsig';
% net.layers{1}.transferFcn = 'hardlim';
% net.layers{1}.transferFcn = 'logsig';
% net.layers{1}.transferFcn = 'hardlims';
% net.layers{1}.transferFcn = 'netinv';
% net.layers{1}.transferFcn = 'poslin'; 
net.layers{1}.transferFcn = 'purelin'; 
% net.layers{1}.transferFcn = 'radbas';
% net.layers{1}.transferFcn = 'radbasn';
% net.layers{1}.transferFcn = 'satlin';
% net.layers{1}.transferFcn = 'satlins';
% net.layers{1}.transferFcn = 'softmax';
% net.layers{1}.transferFcn = 'tansig';
% net.layers{1}.transferFcn = 'tribas';

net = train(net,x,train_labels); 

view(net)

y = net(x2);

perf = perform(net,train_labels,net(x));

classes = vec2ind(y);

%%
correct = 0;

for i = 1:length(test_labels)
    if (classes(i))==(find(test_labels(:,i)==1))
    	correct = correct + 1;
    end
end

correct/1000



