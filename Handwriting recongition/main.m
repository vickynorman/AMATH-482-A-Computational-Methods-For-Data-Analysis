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

%%

train = trainlabel(q(1:24723),2:end);
test = trainlabel(q(24724:end),2:end);

A=train_labels*pinv(train)';
prediction=(A*test');

%%

correct = 0;

for i = 1:length(test_labels)
    if find(max(prediction(:,i))==prediction(:,i))==(find(test_labels(:,i)==1))
    	correct = correct + 1;
    end
end

correct/1000