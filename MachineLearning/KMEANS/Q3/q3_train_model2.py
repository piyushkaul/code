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
from sklearn.ensemble import ExtraTreesClassifier
from sklearn import svm
from sklearn.naive_bayes import GaussianNB
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import Perceptron
import numpy as np
from sklearn.externals import joblib
from sklearn.ensemble import VotingClassifier
from sklearn.decomposition import PCA
from sklearn.ensemble import BaggingClassifier
import os.path


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
    print "test accuracy: ",
    #Ytst = model.predict(Xtst)
    #Ytst = model.predict(Xtst)
    #filename = description + '_train.csv'
    #df = pd.DataFrame(Ytst, columns = ['TARGET'])
    #df.to_csv(filename,columns=['TARGET'])    
    return Ytst;
    
# Read training data and partition into features and target label
data = pd.read_csv("data/train.csv",  header=None)
Xtrn = data.iloc[:,1:]
scaler = preprocessing.StandardScaler().fit(Xtrn)
Xtrn = scaler.transform(Xtrn) 
Xtrn = pd.DataFrame(Xtrn);
Ytrn = data.iloc[:,0]
#print(data.iloc[99])
#print "Xtrn training accuracy: ",
#print(Xtrn.iloc[0,:])
#print "Ytrn training accuracy: ",
#print(Ytrn)
# Read validation data and partition into features and target label
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

enable_PCA =  True;
enable_decision_tree = False ;
enable_random_forests = False;
enable_extreme_random_forests  = False;
enable_bagtree = False;
enable_svm_rbf = False;
enable_svm_linear = False;
enable_naive_bayes = False;
enable_adaboost = True;
enable_perceptron = True;
enable_voting_classifier = False;

#xframes = [pd.DataFrame(Xtrn), pd.DataFrame(Xval1), pd.DataFrame(Xval2), pd.DataFrame(Xval3)];
#yframes = [pd.DataFrame(Ytrn), pd.DataFrame(Yval1), pd.DataFrame(Yval2), pd.DataFrame(Yval3)];
#xframes = [pd.DataFrame(Xtrn), pd.DataFrame(Xval1), pd.DataFrame(Xval2)];
#yframes = [pd.DataFrame(Ytrn), pd.DataFrame(Yval1), pd.DataFrame(Yval2)];

#Xcomb = pd.concat(xframes);
#Ycomb = pd.concat(yframes);
#Xcomb_pca = Xcomb
Xtst_pca = Xtst
Xtrn_pca = Xtrn
Xval1_pca = Xval1
Xval2_pca = Xval2
Xval3_pca = Xval3

if enable_PCA:
    pca = PCA(n_components=30)
    pca.fit(Xtrn)
    joblib.dump(pca, 'partb/pca.pkl') 
    Xtrn_pca = pca.transform(Xtrn);
    Xval1_pca = pca.transform(Xval1)
    Xval2_pca = pca.transform(Xval2);
    Xval3_pca = pca.transform(Xval3);    
    Xtst_pca = pca.transform(Xtst); 
    #Xcomb_pca = pca.transform(Xcomb);      
    
#Xtrn = Xcomb
#Ytrn = Ycomb
#Xtrn_pca = Xcomb_pca

if enable_decision_tree:
    dtree_file = 'partb/decision_tree.pkl'
    if os.path.isfile(dtree_file) :
        dtree = joblib.load(dtree_file);
    else:
        dtree = DecisionTreeClassifier(criterion="entropy", splitter='best', max_depth=8,
        min_samples_split=5, min_samples_leaf=5, min_weight_fraction_leaf=0.0, 
        max_features=None, random_state=0, max_leaf_nodes=None, class_weight=None, 
        presort=False)
        dtree.fit(Xtrn_pca,Ytrn)
        joblib.dump(dtree, dtree_file) 
    model_verify(dtree, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Decision Tree')
        

if enable_random_forests:  
    rForest_file = 'partb/random_forest.pkl'
    if os.path.isfile(rForest_file) :
        rForest = joblib.load(rForest_file);
    else:      
        rForest = RandomForestClassifier(n_estimators=1000, criterion='gini', max_depth=None, 
        min_samples_split=5, min_samples_leaf=1, min_weight_fraction_leaf=0.0, max_features='auto', 
        max_leaf_nodes=None, bootstrap=True, oob_score=False, n_jobs=6, random_state=0, 
        verbose=0, warm_start=False, class_weight=None);
        rForest.fit(Xtrn_pca,Ytrn);
        joblib.dump(rForest, rForest_file) 
    model_verify(rForest, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Random Forest')

if enable_extreme_random_forests:
    etclass_file = 'partb/extra_random_forest.pkl'
    if os.path.isfile(etclass_file) :
        etclass = joblib.load(etclass_file);
    else:         
        etclass = ExtraTreesClassifier(n_estimators=1000, criterion='gini', max_depth=None, 
        min_samples_split=5, min_samples_leaf=1, min_weight_fraction_leaf=0.0, max_features='auto', 
        max_leaf_nodes=None, bootstrap=True, oob_score=False, n_jobs=10, random_state=0, 
        verbose=0, warm_start=False, class_weight=None);
        etclass.fit(Xtrn_pca,Ytrn);
        joblib.dump(etclass, etclass_file) 
    model_verify(etclass, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'ExtraTree')
    
if enable_bagtree:
    bagtree_file = 'partb/bagtree.pkl'
    if os.path.isfile(bagtree_file) :
        bagtree = joblib.load(bagtree_file);
    else:     
        bagtree =  BaggingClassifier(ExtraTreesClassifier(n_estimators=5, criterion='gini', max_depth=None, 
        min_samples_split=5, min_samples_leaf=1, min_weight_fraction_leaf=0.0, max_features='auto', 
        max_leaf_nodes=None, bootstrap=True, oob_score=False, random_state=0, 
        verbose=0, warm_start=False, class_weight=None,n_jobs=10),max_samples=0.5, max_features=0.5);
        bagtree.fit(Xtrn_pca,Ytrn);
        joblib.dump(bagtree, bagtree_file ) 
    model_verify(bagtree, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'bagtree')
    
if enable_svm_rbf:
    sv_file = 'partb/svm_rbf.pkl'
    if os.path.isfile(sv_file) :
        sv = joblib.load(sv_file);
    else:      
        sv = svm.SVC(C=2.0, cache_size=200, class_weight=None, coef0=0.0,
        decision_function_shape='ovo', degree=3, gamma=0.001, kernel='rbf',
        max_iter=-1, probability=False, random_state=0, shrinking=True,
        tol=0.001, verbose=False)
        sv.fit(Xtrn,Ytrn)  
        joblib.dump(sv, sv_file) 
    model_verify(sv, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'RBF Support Vector Machine')
    
if enable_svm_linear:
    svl_file = 'partb/svm_linear.pkl'
    if os.path.isfile(svl_file) :
        svl = joblib.load(svl_file);
    else:       
        svl = svm.LinearSVC(penalty='l2', loss='squared_hinge', dual=True, tol=0.0001, C=1.0, multi_class='ovr', 
        fit_intercept=True, intercept_scaling=1, class_weight=None, verbose=0, random_state=1, max_iter=10000)
        svl.fit(Xtrn,Ytrn)  
        joblib.dump(svl,svl_file ) 
    model_verify(svl, Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Linear Support Vector Machine')    

if enable_naive_bayes:
    gnb_file = 'partb/gaussian_naive_bayes.pkl'
    if os.path.isfile(gnb_file) :
        gnb = joblib.load(gnb_file);
    else:     
        gnb = GaussianNB()	
        gnb.fit(Xtrn_pca,Ytrn)  
        joblib.dump(gnb, gnb_file) 
    model_verify(gnb, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Gaussian Naive Bayes')

if enable_adaboost:
    adab_file = 'partb/ada_boost_classifier.pkl'
    if os.path.isfile(adab_file) :
        adab = joblib.load(adab_file);
    else:      
        adab = AdaBoostClassifier(n_estimators=1000);
        adab.fit(Xtrn_pca,Ytrn)  
        joblib.dump(adab, adab_file) 
    model_verify(adab, Xtrn_pca, Ytrn, Xval1_pca, Yval1, Xval2_pca, Yval2, Xval3_pca, Yval3, Xtst_pca, 'Adaboost Model')

if enable_perceptron:
    percept_file =  'partb/perceptron.pkl'
    if os.path.isfile(percept_file) :
        percept = joblib.load(percept_file);
    else:       
        percept = Perceptron()
        percept .fit(Xtrn,Ytrn)  
        joblib.dump(percept ,percept_file) 
    model_verify(percept , Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Perceptron Model')

if enable_voting_classifier:
    eclf_file =  'partb/voting_classifier.pkl'
    if os.path.isfile(percept_file) :
        eclf = joblib.load(eclf_file);
    else:       
        eclf = VotingClassifier(estimators=[('dt', dtree), ('rf', rForest), ('svm', sv),('gnb', gnb), ('adab', adab)], voting='hard', weights=[1,1,1,1,1])
        eclf.fit(Xtrn,Ytrn)  
        joblib.dump(eclf , eclf_file) 
    model_verify(eclf , Xtrn, Ytrn, Xval1, Yval1, Xval2, Yval2, Xval3, Yval3, Xtst, 'Voting Classifier Model')


