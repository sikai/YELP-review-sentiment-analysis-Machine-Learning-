load maomao2.mat;
Data= load('review_dataset.mat');

N = size(Data.train.counts,1);
temp=find(sum(Data.train.counts>3));
trainD = Data.train.counts(1:20000,temp);
testD = Data.train.counts(20001:25000,temp);
trainD = full(trainD);
testD = full(testD);
datapool = trainD;
[a,b,c] = pca(trainD);
trainD=trainD-repmat(mean(datapool),size(trainD,1),1);
testD=testD-repmat(mean(datapool),size(testD,1),1);
train_hat=trainD*a(:,1:1000);
test_hat=testD*a(:,1:1000);
final_train = [Data.train.counts(1:20000,idx_shrink),train_hat];
final_test = [Data.train.counts(20001:25000,idx_shrink),test_hat];
trainLabel = Data.train.labels(1:20000,:);
testLabel = Data.train.labels(20001:25000,:);

model = cell(5,1);
for k=1:5
    model{k} = train(double(trainLabel==k),final_train,'-s 1');
end
    %# get probability estimates of test instances using each model

prob = zeros(5000,5);
for k=1:5
    [~,~,p] = predict( double(testLabel==k), final_test, model{k}, '-b 1');
    prob(:,k) = p(:,model{k}.Label==1);    %# probability of class==k
end
    %# predict the class with the highest probability
[~,pred] = max(prob,[],2);


rmse = sqrt(sum((pred-testLabel).^2)/numel(pred));

