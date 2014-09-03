Usage:
run run_script, which will call the init_model function and make_prediction function. And it returns a pred which is the predicted label for the quiz data. 



Our prediction model is a combination of the results from different prediction methods. It is trained in the following procedure:

1> First, the system load the features selected from the given dataset, including the top features for each kind of the rates selected using mutual information from 'review_dataset.mat', and the features from the previous selected groups that appeared more than 2 times in the dataset, which will be used in the LR prediction below. At last, the additional features are added up together. Here we use the bigrams parsed from the reviews.

3> Then we using the features above to train the models. Here we uses three different classification methods to do the prediction: 1) Logistic Regression to train the one-against-all model for each of the five rates, and predict the rates for the test set using the highest probability; 2) A Linear SVM model using the basic features as well as the additional bigrams; 3) A Naive Bayes model which gives multinomial distribution for classifying the count-based data.

4> Finally after we train the model and make predictions from each of the methods above, we combine the predictions together, and then train a Linear Regression model using the above predictions. This model is the one that are used to conduct the prediction.



We have implemented the following method:
Generative method:
NB: In the init_model function, we used the data that has been processed by the bigram method to train the model, with the multinomial distribution. And in the make_final_prediction function, we use this model to predict the label.  
Discriminative method: 
LR: First get the top features for each kind of the rated selected label with mutual information. Then use logistic regression to train the data to get 5 different models for 5 different rates. Then we predict the class with the highest probability.
SVM:Aftere we added the bigram feature into the original data, we use liblinear to train the data with one-class SVM, parameter c as 0.01 and p as 0.1. And we got the model. In the make_final_prediction function, we predict it. 
Unsupervised method:
PCA:In the PCA implementation fuction, we implemented the PCA function to reduce dimension. After we get the reduced dimension, we added it as a feature in the original feature.  But we don't use this function as it seems to make our result worse. 
Use additional features:
bigrams:
in make bigram.m script, we implemented bigram. We found not a very and relation between them. Then we generate features of this bigram and generate a feature called bigram_features. And we saved it as the bigram.mat, which to be used in the init_model.m. 
