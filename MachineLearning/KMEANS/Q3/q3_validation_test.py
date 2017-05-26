# Loading requisite libraries
import sys
import os
import re
import pandas as pd
import numpy as np
import pdb
import math
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import OneHotEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn import svm
from sklearn.naive_bayes import GaussianNB
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
import numpy as np
from sklearn.externals import joblib
from sklearn.ensemble import VotingClassifier


# Read training data and partition into features and target label
data = pd.read_csv("data/train.csv",  header=None)
Xtrn = data.iloc[:,1:]
scaler = preprocessing.StandardScaler().fit(Xtrn)
Xtrn = scaler.transform(Xtrn) 
Xtrn = pd.DataFrame(Xtrn);
Ytrn = data.iloc[:,0]

data_val1= pd.read_csv("data/validation_1.csv", header=None)
data_val2 = pd.read_csv("data/validation_2.csv", header=None)
data_val3 = pd.read_csv("data/validation_3.csv", header=None)

Xval1 = data_val1.iloc[:,1:]
Xval1 = scaler.transform(Xval1) 
Yval1 = data_val1.iloc[:,0]

Xval2 = data_val2.iloc[:,1:]
Xval2 = scaler.transform(Xval2) 
Yval2 = data_val2.iloc[:,0]

Xval3 = data_val3.iloc[:,1:]
Xval3 = scaler.transform(Xval3) 
Yval3 = data_val3.iloc[:,0]

# Read test data and partition into features and target label
data = pd.read_csv("data/test.csv", header=None)
Xtst = data.iloc[:,1:]
Xtst = scaler.transform(Xtst) 
Ytst = data.iloc[:,0]

def model_verify(model, Xtrn, Ytrnh, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, description):
    print "\n"
    print "model = ", description;
    print "training accuracy: ",
    print model.score(Xtrn,Ytrn)
    print "validation 1 accuracy: ",
    print model.score(Xval1,Yval1)
    print "validation 2 accuracy: ",
    print model.score(Xval2,Yval2)
    print "validation 3 accuracy: ",
    print model.score(Xval3,Yval3)
    #print "test accuracy: ",
    #Ytst = model.predict(Xtst)    
    return;


pca = joblib.load('partb/pca.pkl');
Xtrn_pca = pca.transform(Xtrn)
Xval1_pca = pca.transform(Xval1)
Xval2_pca = pca.transform(Xval2);
Xval3_pca = pca.transform(Xval3);    
Xtst_pca = pca.transform(Xtst); 

dtree = joblib.load('partb/decision_tree.pkl');
model_verify(dtree, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Decision Tree')

rForest = joblib.load('partb/random_forest.pkl');
model_verify(rForest, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Random Forest')

etclass = joblib.load('partb/extra_random_forest.pkl');
model_verify(etclass, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Extra Random Forest')

bagtree = joblib.load('partb/bagtree.pkl');
model_verify(bagtree, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Bag Tree')

svm_rbf = joblib.load('partb/svm_rbf.pkl');
model_verify(svm_rbf, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'SVM RBF')

svm_lin = joblib.load('partb/svm_linear.pkl');
model_verify(svm_lin, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'SVM Linear')

gnb = joblib.load('partb/gaussian_naive_bayes.pkl'); 
model_verify(gnb, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Gaussian Naive Bayes')

adab = joblib.load('partb/ada_boost_classifier.pkl'); 
model_verify(adab, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Adaboost Model')

perceptron = joblib.load('partb/perceptron.pkl'); 
model_verify(perceptron, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Perceptron')

voting_classifier = joblib.load('partb/voting_classifier.pkl'); 
model_verify(voting_classifier, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Voting Classifier')


#clif = joblib.load('partb/voting_classifier.pkl'); 
#model_verify(clif, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Soft Voting Model')
    

