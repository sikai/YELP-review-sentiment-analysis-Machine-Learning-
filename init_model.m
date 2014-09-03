function model = init_model(vocab)

% Example:
% model.svmw = SVM.w;
% model.lrw = LR.w;
% model.classifier_weight = [c_SVM, c_LR];
% 

% Load and process data
Data = load('review_dataset.mat');
load maomao2.mat;
load yijie.mat;
load bigram.mat;

trainData = Data.train.counts;
trainLabel = Data.train.labels;

idx_temp = unique(idx_shrink);
%## TRAIN LOGISTIC REGRESSION MODEL
    %# train one-against-all models
    model_lr = cell(5,1);
    
    for k=1:5
        model_lr{k} = liblinear_train(double(trainLabel==k),trainData(:,feat{k}),'-s 0');
    end
    %# get probability estimates of test instances using each model

    prob = zeros(25000,5);
    for k=1:5
        [~,~,p] = liblinear_predict( double(trainLabel==k), trainData(:,feat{k}), model_lr{k}, '-b 1 ');
        prob(:,k) = p(:,model_lr{k}.Label==1);    %# probability of class==k
    end
    %# predict the class with the highest probability
    [~,pred] = max(prob,[],2);
    
%## TRAIN LINEAR_SVM MODEL 
    svm_data = [trainData(:,idx_temp),bigram_features];
    model_svm = liblinear_train(trainLabel,svm_data,'-s 2 -c 0.01 -p 0.1'); 
    [pred_svm,~,~] = liblinear_predict( trainLabel,svm_data, model_svm);
    
%## TRAIN NAIVE BAYES MODEL
    nb_data = svm_data;
    nb2 = NaiveBayes.fit(nb_data, trainLabel,'Distribution','mn');
    pred_nb = nb2.predict(nb_data);
    
%## TRAIN LINEAR REGRESSION MODEL USING ABOVE PREDICTIONS
    new_feature = [pred,pred_svm,pred_nb];
    mdl = LinearModel.fit(new_feature,trainLabel);
    
% Save models
    model.lr = model_lr;
    model.svm = model_svm;
    model.nb = nb2;
    model.linear = mdl;
    
    
    