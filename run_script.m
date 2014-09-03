addpath(genpath('liblinear-1.94'))
load ../data/review_dataset.mat;
load ../data/quizSet.mat;
load ../data/metadata.mat;
model = init_model(vocab);
obs_num = size(quiz.counts,1);
pred = zeros(obs_num,1);
for i=1:obs_num
   pred(i) = make_final_prediction(model,quiz.counts(i,:),quiz_metadata(1,i));
end
