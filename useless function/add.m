%% Plots/submission for Perceptron portion, Question 2.

%% Put your written answers here.
clear all
close all

%% Load and process data
load ../data/review_dataset.mat;
load ../data/metadata.mat;
nima = cell(25000,1);
p=1;
for i=1:25000
   if train.counts(i,34482)>0
       for j=1:numel(train_metadata(1,i).text)
           if strcmp(train_metadata(1,i).text{j,1},'not')
               if strcmp(train_metadata(1,i).text{j+1,1},'a')
                   if strcmp(train_metadata(1,i).text{j+2,1},'very');
                       nima{p} = strcat('notavery ',train_metadata(1,i).text{j+3,1});
                       p=p+1;
                   else
                    nima{p} = strcat('nota ',train_metadata(1,i).text{j+2,1});
                    p=p+1;
                   end
               elseif strcmp(train_metadata(1,i).text{j+1,1},'very')
                   nima{p} = strcat('notvery ',train_metadata(1,i).text{j+2,1});
                   p=p+1;
               elseif strcmp(train_metadata(1,i).text{j+1,1},'too')
                   nima{p} = strcat('nottoo ',train_metadata(1,i).text{j+2,1});
                   p=p+1;                   
               else
                   nima{p} = strcat('not',train_metadata(1,i).text{j+1,1});
                   p=p+1;
               end

           end
       end
   end
end

bigram = cell(15501,1);
exp = '[^ \f\n\r\t\v.,;:?!_()]*';
for i=1:15501
    temp = regexp(nima{i},exp,'match');
    bigram{i} = [temp{:}];
end
bi = unique(bigram);

feat_num = numel(bi);
bigram_features = zeros(25000,feat_num);
for i=1:25000
   if train.counts(i,34482)>0
       for j=1:numel(train_metadata(1,i).text)
           if strcmp(train_metadata(1,i).text{j,1},'not')
               if strcmp(train_metadata(1,i).text{j+1,1},'a')
                   if strcmp(train_metadata(1,i).text{j+2,1},'very');
                       name = strcat('notavery ',train_metadata(1,i).text{j+3,1});
                   else
                       name = strcat('nota ',train_metadata(1,i).text{j+2,1});
                   end
               elseif strcmp(train_metadata(1,i).text{j+1,1},'very')
                   name = strcat('notvery ',train_metadata(1,i).text{j+2,1});
               elseif strcmp(train_metadata(1,i).text{j+1,1},'too')
                   name = strcat('nottoo ',train_metadata(1,i).text{j+2,1});                 
               else
                   name = strcat('not',train_metadata(1,i).text{j+1,1});
               end
               temp1 = regexp(name,exp,'match');
               for k=1:feat_num
                   if strcmp(bi{k},[temp1{:}])
                      bigram_features(i,k) = bigram_features(i,k)+1; 
                   end
               end
           end
       end

   end
end

bigram_features = sparse(bigram_features);
