function prediction = make_final_prediction(model,test_words,test_meta)
% Input
% test_words : a 1xp vector representing "1" test sample.
% test_meta : a struct containing the metadata of the test sample.
% model : what you initialized from init_model.m
%
% Output
% prediction : a scalar which is your prediction of the test sample
%
% **Note: the function will only take 1 sample each time.

% ## LOAD DATA
persistent a;
persistent b;
persistent c;
if isempty(a)
   a=load('feature_names.mat');
end
if isempty(b)
   b=load('maomao2.mat');
end
if isempty(c)
   c=load('yijie.mat');
end
%load feature_names.mat;
%load maomao.mat;
%load yijie.mat;
idx_temp = unique(b.idx_shrink);
% ## ADD BI_GRAM FEATURES USING TEST_METADATA
feat_num = numel(a.bi);
exp = '[^ \f\n\r\t\v.,;:?!_()]*';
test_bigram_features = zeros(1,feat_num);

   if test_words(:,34482)>0
       for j=1:numel(test_meta.text)
           if strcmp(test_meta.text{j,1},'not')
               if strcmp(test_meta.text{j+1,1},'a')
                   if strcmp(test_meta.text{j+2,1},'very');
                       name = strcat('notavery ',test_meta.text{j+3,1});
                   else
                       name = strcat('nota ',test_meta.text{j+2,1});
                   end
               elseif strcmp(test_meta.text{j+1,1},'very')
                   name = strcat('notvery ',test_meta.text{j+2,1});
               elseif strcmp(test_meta.text{j+1,1},'too')
                   name = strcat('nottoo ',test_meta.text{j+2,1});                 
               else
                   name = strcat('not',test_meta.text{j+1,1});
               end
               temp1 = regexp(name,exp,'match');
               for k=1:feat_num
                   if strcmp(a.bi{k},[temp1{:}])
                      test_bigram_features(:,k) = test_bigram_features(:,k)+1; 
                   end
               end
           end
       end
   end
test_bigram_features = sparse(test_bigram_features);

%### MAKE PREDICTION
    testLabel=0;
%## PREDICT WITH LOGISTIC REGRESSION MODEL
    probb = zeros(1,5);
    for k=1:5
        [~,~,pp] = liblinear_predict( double(testLabel==k), test_words(:,c.feat{k}), model.lr{k}, '-b 1 ');
        probb(:,k) = pp(:,model.lr{k}.Label==1);    %# probability of class==k
    end
    %# predict the class with the highest probability
    [~,pred1] = max(probb,[],2);
    
%## PREDICT WITH LINEAR SVM MODEL
    svm_test_data = [test_words(:,idx_temp),test_bigram_features];
    [pred2,~,~] = liblinear_predict( testLabel, svm_test_data, model.svm);
    
%## PREDICT WITH NAIVE BAYES MODEL   
    nb_test_data = svm_test_data;
    pred3 = model.nb.predict(nb_test_data);
    
%## PREDICT WITH LINEAR REGRESSION OF ABOVE PREDICTIONS
    %weighted sum
    newX = [pred1,pred2,pred3];
    prediction = predict(model.linear,newX);









